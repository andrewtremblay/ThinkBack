//
//  ThinkBackIdeaDataObject.h
//  ThinkBack
//
//  Created by AndrewTremblay on 11/4/13.
//  Copyright (c) 2013 andrewtremblay. All rights reserved.
//

#import <CoreData/CoreData.h>
typedef NS_OPTIONS(NSUInteger, ThinkBackRemindType) {
    ThinkBackRemindTypeTimeUnset      = 1 <<  0,
    ThinkBackRemindTypeTimeExact      = 1 <<  1, // turn on user interaction while animating
    ThinkBackRemindTypeTimeFuzzy      = 1 <<  2, // start all views from current value, not initial value
    ThinkBackRemindTypeTimeNever      = 1 <<  3, // repeat animation indefinitely
    
//    ThinkBackRemindTypeLocationUnset  = 0 << 16, // default
//    ThinkBackRemindTypeLocationNone   = 1 << 16, // default
//    
//    ThinkBackRemindTypeTriggerUnset = 0 << 20, // default
//    ThinkBackRemindTypeTriggerNone  = 1 << 20  // default
};

@interface ThinkBackIdeaDataObject : NSManagedObject
    @property (nonatomic, strong) NSString  *text;
    @property (nonatomic, strong) NSDate    *remindAt;
    @property (nonatomic, strong) NSNumber  *remindType;
@end
