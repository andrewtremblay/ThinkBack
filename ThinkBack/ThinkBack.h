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
#import "ThinkBackKeychainHelper.h"

NSManagedObjectContext *testingContext;
static NSString* kIdeaLogEntityName = @"IdeaLogEntity";


static NSString* kSettingsWebOptionsSafari = @"safari";
static NSString* kSettingsWebOptionsChrome = @"chrome";
static NSString* kSettingsWebOptionsPopup  = @"popup";

@interface ThinkBack : NSObject

#pragma - Database helpers
+(NSManagedObjectContext *) getManagedObjectContext;
+(void)prepareDataModelForTesting;

+(void)populateDebugDataModel;

#pragma mark Settings page
+(void)setDefaultSettings;
+(BOOL)shouldContextScan;
+(void)setShouldContextScan:(BOOL)contextScan;
+(NSString *)webPrompt;
+(void)setWebPrompt:(NSString *)webPrompt;

#pragma mark primary Idea behavior (common CRUD)

+(ThinkBackIdeaDataObject *)createIdea; //creates a new predicate with default values and adds it to the database. Returns a reference to that managed object.
+(NSArray *)getAllIdeas; //returns all ideas in the database (potentially huge)
+(NSError *)saveIdea:(ThinkBackIdeaDataObject *)ideaToSave;
+(NSError *)deleteIdea:(ThinkBackIdeaDataObject *)ideaToDelete; //takes an existing idea and atempts to remove it from the database. Returns true on successful deletion

#pragma mark - Data logic
+(BOOL)ideaObjectIsValid:(ThinkBackIdeaDataObject *)ideaToCheck;

#pragma mark - helper setters and getters
+(void)setRemindType:(ThinkBackRemindType)remindTypeInt forIdea:(ThinkBackIdeaDataObject *)idea;
+(ThinkBackRemindType)getRemindTypeForIdea:(ThinkBackIdeaDataObject *)idea;

#pragma mark String Formatting
+(NSString *) formattedRemindAtTimeForIdea:(ThinkBackIdeaDataObject *)object;

@end
