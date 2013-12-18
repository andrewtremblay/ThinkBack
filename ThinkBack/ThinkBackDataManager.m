//
//  ThinkBackDataManager.m
//  ThinkBack
//
//  Created by AndrewTremblay on 11/30/13.
//  Copyright (c) 2013 andrewtremblay. All rights reserved.
//

#import "ThinkBackDataManager.h"

@implementation ThinkBackDataManager
+(NSString *)databaseName
{
    return @"appblade.sqlite";
}

+(NSString *)databaseDirectory
{
     [NSFileManager defaultManager];
   return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
}

@end
