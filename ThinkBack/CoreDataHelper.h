//
//  CoreDataHelper.h
//  ThinkBack
//
//  Created by AndrewTremblay on 11/4/13.
//  Copyright (c) 2013 DanDrew. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ThinkBackAppDelegate.h"
#import "ThinkBackIdeaDataObject.h"

NSManagedObjectContext *testingContext;

@interface CoreDataHelper : NSObject

+(NSManagedObjectContext *) getManagedObjectContext;

/*
 Set up the context for testing
 */
+(void)prepareDataModelForTesting;

#pragma mark - primary Idea behavior (common CRUD)
+(ThinkBackIdeaDataObject *)createIdea; //creates a new predicate with default values and adds it to the database. Returns a reference to that managed object.
+(ThinkBackIdeaDataObject *)getIdea; //Gets the first idea object that the default predicate returns. null otherwise.
+(ThinkBackIdeaDataObject *)getFirstIdeaFromPredicate:(NSPredicate *)predicate; //the gets te first idea that the predicate object comes back with. Null otherwise.
+(ThinkBackIdeaDataObject *)updateIdea:(ThinkBackIdeaDataObject *)idea; //updates existing idea in database with pased object
+(BOOL)deleteIdea:(ThinkBackIdeaDataObject *)ideaToDelete; //takes an existing idea and atempts to remove it from the database. Returns true on successful deletion

@end
