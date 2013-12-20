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
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    //get some chaos
    int randMin  = arc4random() % 59; //0 - 59
    int randSec  = 5 + arc4random() % 55; //5 - 60 //at least 5 seconds
    //set our random digits
    [dc setMinute:randMin];
    [dc setSecond:randSec];
    NSDate *randomHourDateTime = [[NSCalendar currentCalendar] dateFromComponents:dc];
    return randomHourDateTime;
}
+(NSDate *)randomTimeInNextDay {
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    //get some chaos
    int randHour = arc4random() % 23; //0 - 23
    int randMin  = arc4random() % 59; //0 - 59
    int randSec  = 5 + arc4random() % 55; //5 - 60 //at least 5 seconds
    //set our random digits
    [dc setHour:randHour];
    [dc setMinute:randMin];
    [dc setSecond:randSec];
    NSDate *randomDayDateTime = [[NSCalendar currentCalendar] dateFromComponents:dc];
    return randomDayDateTime;
}
+(NSDate *)randomTimeInNextWeek {
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    //get some chaos
    int randDay  = arc4random() % 6; //0 - 6
    int randHour = arc4random() % 23; //0 - 23
    int randMin  = arc4random() % 59; //0 - 59
    int randSec  = 5 + arc4random() % 55; //5 - 60 //at least 5 seconds
    //set our random digits
    [dc setDay:dc.day + randDay];
    [dc setHour:randHour];
    [dc setMinute:randMin];
    [dc setSecond:randSec];

    NSDate *randomWeekDateTime = [[NSCalendar currentCalendar] dateFromComponents:dc];
    return randomWeekDateTime;
}
+(NSDate *)randomTimeInNextMonth {
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    //get some chaos
    int randDay  = arc4random() % 30; //0 - 6
    int randHour = arc4random() % 23; //0 - 23
    int randMin  = arc4random() % 59; //0 - 59
    int randSec  = 5 + arc4random() % 55; //5 - 60 //at least 5 seconds
    //set our random digits
    [dc setDay:dc.day + randDay];
    [dc setHour:randHour];
    [dc setMinute:randMin];
    [dc setSecond:randSec];
    
    NSDate *randomWeekDateTime = [[NSCalendar currentCalendar] dateFromComponents:dc];
    return randomWeekDateTime;
}
+(NSDate *)randomTimeInNextYear {
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    //get some chaos
    int randDay  = arc4random() % 365; //0 - 365
    int randHour = arc4random() % 23; //0 - 23
    int randMin  = arc4random() % 59; //0 - 59
    int randSec  = 5 + arc4random() % 55; //5 - 60 //at least 5 seconds
    //set our random digits
    [dc setDay:dc.day + randDay];
    [dc setHour:randHour];
    [dc setMinute:randMin];
    [dc setSecond:randSec];
    
    NSDate *randomYearDateTime = [[NSCalendar currentCalendar] dateFromComponents:dc];
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
