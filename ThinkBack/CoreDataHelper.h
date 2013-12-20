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
static NSString* kIdeaLogEntityName = @"IdeaLogEntity";

@interface CoreDataHelper : NSObject

+(NSManagedObjectContext *) getManagedObjectContext;

/*
 Set up the context for testing
 */
+(void)prepareDataModelForTesting;
+(void)populateDebugDataModel;


#pragma mark - primary Idea behavior (common CRUD)
+(ThinkBackIdeaDataObject *)createIdea; //creates a new predicate with default values and adds it to the database. Returns a reference to that managed object.
+(NSError *)saveIdea:(ThinkBackIdeaDataObject *)ideaToSave;
+(NSError *)deleteIdea:(ThinkBackIdeaDataObject *)ideaToDelete; //takes an existing idea and atempts to remove it from the database. Returns true on successful deletion

+(BOOL)ideaObjectIsValid:(ThinkBackIdeaDataObject *)ideaToCheck;
//helper setters and getters
+(void)setRemindType:(ThinkBackRemindType)remindTypeInt forIdea:(ThinkBackIdeaDataObject *)idea;
+(ThinkBackRemindType)getRemindTypeForIdea:(ThinkBackIdeaDataObject *)idea;

+(NSArray *)getAllIdeas;

#pragma mark String Formatting
+(NSString *) formattedRemindAtTimeForIdea:(ThinkBackIdeaDataObject *)object;


@end
