//
//  CoreDataHelper.m
//  ThinkBack
//
//  Created by AndrewTremblay on 11/4/13.
//  Copyright (c) 2013 DanDrew. All rights reserved.
//

#import "CoreDataHelper.h"
#import "ThinkBackAppDelegate.h"

@implementation CoreDataHelper

+(NSManagedObjectContext *) getManagedObjectContext {
    if ([UIApplication sharedApplication] == nil) {
        return testingContext;
    }
    ThinkBackAppDelegate *delegate = (ThinkBackAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [delegate managedObjectContext];
}
@end
