//
//  CoreDataHelper.h
//  ThinkBack
//
//  Created by AndrewTremblay on 11/4/13.
//  Copyright (c) 2013 DanDrew. All rights reserved.
//

#import <Foundation/Foundation.h>

NSManagedObjectContext *testingContext;

@interface CoreDataHelper : NSObject

+(NSManagedObjectContext *) getManagedObjectContext;

@end
