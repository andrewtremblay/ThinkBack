//
//  NSDate+ThinkBack.m
//  ThinkBack
//
//  Created by AndrewTremblay on 12/19/13.
//  Copyright (c) 2013 andrewtremblay. All rights reserved.
//

#import "NSDate+ThinkBack.h"
#include <stdlib.h>


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

+(NSDate *)never
{
    return [NSDate distantFuture];
}

+(NSDate *)randomTimeInNextHour{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.year = 0;
    offsetComponents.month = 0;
    offsetComponents.day = 0;
    offsetComponents.hour = 0;
    offsetComponents.minute = arc4random() % 59; // LEAP MINUTES????
    offsetComponents.second = arc4random() % 60; // LEAP SECONDS????
    NSDate *randomHourDateTime = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:[NSDate today] options:0];
    return randomHourDateTime;
}
+(NSDate *)randomTimeInNextDay {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.year = 0;
    offsetComponents.month = 0;
    offsetComponents.day = 0;
    offsetComponents.hour = arc4random() % 24; //LEAP DAYS???
    offsetComponents.minute = arc4random() % 60; // LEAP MINUTES????
    offsetComponents.second = arc4random() % 60; // LEAP SECONDS????
    NSDate *randomDayDateTime = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:[NSDate today] options:0];
    return randomDayDateTime;
}
+(NSDate *)randomTimeInNextWeek {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.year = 0;
    offsetComponents.month = 0;
    offsetComponents.day = arc4random() % 7;
    offsetComponents.hour = arc4random() % 24; //LEAP DAYS???
    offsetComponents.minute = arc4random() % 60; // LEAP MINUTES????
    offsetComponents.second = arc4random() % 60; // LEAP SECONDS????
    NSDate *randomWeekDateTime = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:[NSDate today] options:0];
    return randomWeekDateTime;
}
+(NSDate *)randomTimeInNextMonth {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.year = 0;
    offsetComponents.month = 0;
    offsetComponents.day = arc4random() % 30;
    offsetComponents.hour = arc4random() % 24; //LEAP DAYS???
    offsetComponents.minute = arc4random() % 60; // LEAP MINUTES????
    offsetComponents.second = arc4random() % 60; // LEAP SECONDS????
    NSDate *randomMonthDateTime = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:[NSDate today] options:0];
    return randomMonthDateTime;
}
+(NSDate *)randomTimeInNextYear {
    //get some chaos
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.year = 0;
    offsetComponents.month = arc4random() % 12;
    offsetComponents.day = arc4random() % 30;
    offsetComponents.hour = arc4random() % 24; //LEAP DAYS???
    offsetComponents.minute = arc4random() % 60; // LEAP MINUTES????
    offsetComponents.second = arc4random() % 60; // LEAP SECONDS????

    NSDate *randomYearDateTime = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:[NSDate today] options:0];
    return randomYearDateTime;
}



+(NSDate *)randomTimeFromSettings
{
    //no settings at the moment, just use our week
    return [NSDate randomTimeInNextYear];
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
