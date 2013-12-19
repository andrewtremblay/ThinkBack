//
//  CoreDataHelper.m
//  ThinkBack
//
//  Created by AndrewTremblay on 11/4/13.
//  Copyright (c) 2013 DanDrew. All rights reserved.
//

#import "CoreDataHelper.h"
#import "NSDate+ThinkBack.h"

@implementation CoreDataHelper

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
    ThinkBackIdeaDataObject *i1 = [CoreDataHelper createIdea];
    [i1 setText:@"Story Idea: Boy meets Grill"];
    [i1 setRemindAt:[NSDate new]];

    
    ThinkBackIdeaDataObject *i2 = [CoreDataHelper createIdea];
    [i2 setText:@"A Dyslexic Twitter"];
    [i2 setRemindAt:[NSDate new]];

    ThinkBackIdeaDataObject *i3 = [CoreDataHelper createIdea];
    [i3 setText:@"A restaurant that only serves soup-flavored air."];
    [i3 setRemindAt:[NSDate new]];

    [[CoreDataHelper getManagedObjectContext] save:nil];
}


#pragma mark - primary Idea behavior

+(ThinkBackIdeaDataObject *)createIdea
{
    NSManagedObjectContext *context = [CoreDataHelper getManagedObjectContext];
    NSManagedObject *newContact = [NSEntityDescription insertNewObjectForEntityForName:kIdeaLogEntityName inManagedObjectContext:context];
    return (ThinkBackIdeaDataObject *)newContact;
}

+(NSArray *) getAllIdeas
{
    NSManagedObjectContext *context = [CoreDataHelper getManagedObjectContext];
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
    NSManagedObjectContext *context = [CoreDataHelper getManagedObjectContext];
    [context insertObject:ideaToSave];
    NSError *error;
    [context save:&error];
    return error;
}

+(NSError *)deleteIdea:(ThinkBackIdeaDataObject *)ideaToSave
{
    NSManagedObjectContext *context = [CoreDataHelper getManagedObjectContext];
    [context deleteObject:ideaToSave];
    NSError *error;
    [context save:&error];
    return error;
}

+(BOOL)ideaObjectIsValid:(ThinkBackIdeaDataObject *)ideaToCheck
{
    return [ideaToCheck text] != nil && [[ideaToCheck text] length] > 0;
}




#pragma mark String Formatting


+(NSString *) formattedRemindAtTimeForIdea:(ThinkBackIdeaDataObject *)object
{
    NSString *toRet = @"whenever";
    if(object != nil && object.remindAt != nil){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];

        NSDate *dateCheck = object.remindAt;
        if([dateCheck isToday]){
            [dateFormatter setDateFormat:@"'today at' h:mm aa"];
        }else if([dateCheck isTomorrow]){
            [dateFormatter setDateFormat:@"'tomorrow at' h:mm aa"];
        }else if([dateCheck isThisWeek]){
            [dateFormatter setDateFormat:@"EEEE 'at' h:mm aa"];
        }else {
            [dateFormatter setDateFormat:@"dd/mm/yy 'at' h:mm aa"];
        }
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        
        toRet = [dateFormatter stringFromDate:object.remindAt];
    }
    
    return toRet;
}



@end
