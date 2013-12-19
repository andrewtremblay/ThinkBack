//
//  ThinkBackIdeaDataObject.m
//  ThinkBack
//
//  Created by AndrewTremblay on 11/4/13.
//  Copyright (c) 2013 andrewtremblay. All rights reserved.
//

#import "ThinkBackIdeaDataObject.h"

@implementation ThinkBackIdeaDataObject
-(void)setText:(NSString *)text
{
    [self willChangeValueForKey:@"text"];
    [self setValue:text forKey:@"text"];
    [self didChangeValueForKey:@"text"];
}

-(NSString *)text
{
    return [self valueForKey:@"text"];
}


-(void)setRemindAt:(NSDate *)newDate
{
    [self willChangeValueForKey:@"remindAt"];
    [self setValue:newDate forKey:@"remindAt"];
    [self didChangeValueForKey:@"remindAt"];
}

-(NSDate *)remindAt
{
    return [self valueForKey:@"remindAt"];
}
@end

