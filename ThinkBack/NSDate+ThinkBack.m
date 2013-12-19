//
//  NSDate+ThinkBack.m
//  ThinkBack
//
//  Created by AndrewTremblay on 12/19/13.
//  Copyright (c) 2013 andrewtremblay. All rights reserved.
//

#import "NSDate+ThinkBack.h"

#define ONE_WEEK_IN_SECONDS 604800 // (60 * 60 * 24 * 7)
#define ONE_DAY_IN_SECONDS  86400 // (60 * 60 * 24)

@implementation NSDate (ThinkBack)

//the current datetime
+(NSDate *)now
{
    return [NSDate date];
}

+(NSDate *)today
{
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    NSDate *todayMidnightDate = [[NSCalendar currentCalendar] dateFromComponents:dc];
    return todayMidnightDate;
}

+(NSDate *)tomorrow
{
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    [dc setDay:dc.day + 1]; //tomorrow
    NSDate *tomorrowMidnightDate = [[NSCalendar currentCalendar] dateFromComponents:dc];
    return tomorrowMidnightDate;
}


+(NSTimeInterval)secondsLeftForToday
{
    //(will never be less than zero)
    return [[NSDate tomorrow] timeIntervalSince1970] -  [[NSDate date] timeIntervalSince1970];
}

//warning does not account for leap days / seconds
-(BOOL)isThisWeek{
    NSTimeInterval time = [self timeIntervalSinceNow];
    return (time < ONE_WEEK_IN_SECONDS && time > 0); //one week in the future (ignoring leap seconds)
}

//does not account for leap-seconds
-(BOOL)isTomorrow {
 return [self timeIntervalSince1970] >= [[NSDate tomorrow] timeIntervalSince1970]
    &&  [self timeIntervalSince1970] < ([[NSDate tomorrow] timeIntervalSince1970] + ONE_DAY_IN_SECONDS);
}

-(BOOL)isToday {
    return ([self timeIntervalSince1970] >= [[NSDate today] timeIntervalSince1970])
        && ([self timeIntervalSince1970] < [[NSDate tomorrow] timeIntervalSince1970]);
}

@end
