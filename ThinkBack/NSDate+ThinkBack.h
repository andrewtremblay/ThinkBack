//
//  NSDate+ThinkBack.h
//  ThinkBack
//
//  Created by AndrewTremblay on 12/19/13.
//  Copyright (c) 2013 andrewtremblay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ThinkBack)

+(NSDate *)today; //returns time today at midnight
+(NSDate *)tomorrow; //tomorrow at midnight
-(BOOL)isThisWeek; //checks if date will fall one week in the future.
-(BOOL)isTomorrow; //checks if date will be tomorrow.
-(BOOL)isToday; //checks if date will be today.


+(NSTimeInterval)secondsLeftForToday; //time from now until the next midnight

@end
