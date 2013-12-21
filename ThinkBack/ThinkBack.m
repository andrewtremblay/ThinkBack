//
//  CoreDataHelper.m
//  ThinkBack
//
//  Created by AndrewTremblay on 11/4/13.
//  Copyright (c) 2013 DanDrew. All rights reserved.
//

#import "ThinkBack.h"
#import "NSDate+ThinkBack.h"

@implementation ThinkBack

+(NSManagedObjectContext *) getManagedObjectContext {
    if ([UIApplication sharedApplication] == nil) {
        return testingContext;
    }
    
    ThinkBackAppDelegate *delegate = (ThinkBackAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [delegate managedObjectContext];
}

+(void)prepareDataModelForTesting
{
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"ThinkBackAppDelegate")];
    NSString* path = [bundle pathForResource:@"IdeaModel" ofType:@"momd"];
    NSURL *modURL = [NSURL URLWithString:path];
    NSManagedObjectModel *model =
    [[NSManagedObjectModel alloc] initWithContentsOfURL:modURL];
    NSPersistentStoreCoordinator *coord =
    [[NSPersistentStoreCoordinator alloc]
     initWithManagedObjectModel: model];
//    NSPersistentStore *store = [coord addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    testingContext = [[NSManagedObjectContext alloc] init];
    [testingContext setPersistentStoreCoordinator: coord];
}

+(void)populateDebugDataModel
{
    ThinkBackIdeaDataObject *i1 = [ThinkBack createIdea];
    [i1 setText:@"Story Idea: Boy meets Grill"];
    [i1 setRemindAt:[NSDate randomTimeFromSettings]];
    [ThinkBack setRemindType:ThinkBackRemindTypeTimeExact forIdea:i1];
    
    ThinkBackIdeaDataObject *i2 = [ThinkBack createIdea];
    [i2 setText:@"A Dyslexic Twitter"];
    [i2 setRemindAt:[NSDate randomTimeFromSettings]];
    [ThinkBack setRemindType:ThinkBackRemindTypeTimeFuzzy forIdea:i2];

    ThinkBackIdeaDataObject *i3 = [ThinkBack createIdea];
    [i3 setText:@"A restaurant that only serves soup-flavored air."];
    [i3 setRemindAt:[NSDate randomTimeFromSettings]];
    [ThinkBack setRemindType:ThinkBackRemindTypeTimeNever forIdea:i3];
    
    [[ThinkBack getManagedObjectContext] save:nil];
}


+(void)setDefaultSettings {
    [self setShouldContextScan:YES];
    [self setWebPrompt:kSettingsWebOptionsSafari];
}
+(BOOL)shouldContextScan
{
    return [(NSNumber *)[ThinkBackKeychainHelper load:@"shouldContextScan"] boolValue];
}
+(void)setShouldContextScan:(BOOL)contextScan
{
    [ThinkBackKeychainHelper save:@"shouldContextScan" data:[NSNumber numberWithBool:contextScan]];
}
+(NSString *)webPrompt
{
   return [ThinkBackKeychainHelper load:@"webPrompt"];
}
+(void)setWebPrompt:(NSString *)webPrompt
{
    //kSettingsWebOptionsSafari kSettingsWebOptionsChrome kSettingsWebOptionsPopup
    //if safari, then http:// https://
    // if popup, then http:// https:// (in webview modal)
    // if chrome, then googlechrome:// googlechromes://
    //chrome is not installed, would you like to install it? [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms-apps://itunes.apple.com/us/app/chrome/id535886823"]];
    [ThinkBackKeychainHelper save:@"webPrompt" data:webPrompt];
}




#pragma mark - primary Idea behavior

+(ThinkBackIdeaDataObject *)createIdea
{
    NSManagedObjectContext *context = [ThinkBack getManagedObjectContext];
    NSManagedObject *newContact = [NSEntityDescription insertNewObjectForEntityForName:kIdeaLogEntityName inManagedObjectContext:context];
    
    return (ThinkBackIdeaDataObject *)newContact;
}

+(NSArray *) getAllIdeas
{
    NSManagedObjectContext *context = [ThinkBack getManagedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:kIdeaLogEntityName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0) {
        NSLog(@"No matches");
    } else {
        matches = objects[0];
        NSLog(@"%lu matches found", (unsigned long)[objects count]);
    }
    
    return objects;
}

+(NSError *)saveIdea:(ThinkBackIdeaDataObject *)ideaToSave
{
    NSManagedObjectContext *context = [ThinkBack getManagedObjectContext];
    [context insertObject:ideaToSave];
    NSError *error;
    [context save:&error];
    return error;
}

+(NSError *)deleteIdea:(ThinkBackIdeaDataObject *)ideaToSave
{
    NSManagedObjectContext *context = [ThinkBack getManagedObjectContext];
    [context deleteObject:ideaToSave];
    NSError *error;
    [context save:&error];
    return error;
}



+(BOOL)ideaObjectIsValid:(ThinkBackIdeaDataObject *)ideaToCheck
{
    return [ideaToCheck text] != nil && [[ideaToCheck text] length] > 0;
}
+(void)setRemindType:(ThinkBackRemindType)type forIdea:(ThinkBackIdeaDataObject *)idea
{
    //do more remind logic for the type we get (make sure dates are set properly)
    [idea setRemindType: [NSNumber numberWithUnsignedInteger:type]];
}
+(ThinkBackRemindType)getRemindTypeForIdea:(ThinkBackIdeaDataObject *)idea
{
    return [idea.remindType unsignedIntegerValue];
}



#pragma mark String Formatting


+(NSString *) formattedRemindAtTimeForIdea:(ThinkBackIdeaDataObject *)object
{
    NSString *toRet = @"";
    ThinkBackRemindType remindType = [ThinkBack getRemindTypeForIdea:object];
    
    if((remindType & ThinkBackRemindTypeTimeExact)){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        NSDate *dateCheck = object.remindAt;
        if([dateCheck isToday]){
            [dateFormatter setDateFormat:@"'Today at' h:mm aa"];
        }else if([dateCheck isTomorrow]){
            [dateFormatter setDateFormat:@"'Tomorrow at' h:mm aa"];
        }else if([dateCheck isThisWeek]){
            [dateFormatter setDateFormat:@"EEEE 'at' h:mm aa"];
        }else if(dateCheck == [NSDate never]){
            toRet = @"Never";
        }else {
            [dateFormatter setDateFormat:@"M/d/yy 'at' h:mm aa"];
        }
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        
        
        toRet = [dateFormatter stringFromDate:object.remindAt];
    }else if ((remindType & ThinkBackRemindTypeTimeFuzzy)){
        toRet = @"Whenever";
    }else if ((remindType & ThinkBackRemindTypeTimeNever)){
        toRet = @"Never";
    }
    
    return toRet;
}



@end
