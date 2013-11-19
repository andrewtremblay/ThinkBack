//
//  CoreDataHelper.m
//  ThinkBack
//
//  Created by AndrewTremblay on 11/4/13.
//  Copyright (c) 2013 DanDrew. All rights reserved.
//

#import "CoreDataHelper.h"

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
    NSBundle *bundle =
    [NSBundle bundleForClass:NSClassFromString(@"ThinkBackAppDelegate")];
    NSString* path =
    [bundle pathForResource:@"IdeaModel" ofType:@"momd"];
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

#pragma mark - primary Idea behavior
//really simple CRUD becavior
+(ThinkBackIdeaDataObject *)createIdea
{
    return [ThinkBackIdeaDataObject alloc];
}

//Returns the most recent idea, null otherwise
+(ThinkBackIdeaDataObject *)getIdea
{
    return [ThinkBackIdeaDataObject alloc];
}

//first idea from predicate
+(ThinkBackIdeaDataObject *)getFirstIdeaFromPredicate:(NSPredicate *)predicate
{    
    return [ThinkBackIdeaDataObject alloc];
}


//TODO:
+(ThinkBackIdeaDataObject *)updateIdea:(ThinkBackIdeaDataObject *)idea
{
    return [ThinkBackIdeaDataObject alloc];
}

//takes an existing idea and atempts to remove it from the database. Returns true on successful deletion
+(BOOL)deleteIdea:(ThinkBackIdeaDataObject *)ideaToDelete;
{
    return true;
}


@end
