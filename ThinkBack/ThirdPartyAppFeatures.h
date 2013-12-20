//
//  AppDetect.h
//  ThinkBack
//
//  Created by AndrewTremblay on 12/19/13.
//  Copyright (c) 2013 andrewtremblay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdPartyAppFeatures : NSObject
+(BOOL)canDetectChrome;
+(NSURL *)chromeInstallURL;
+(void)presentInstallationAlertViewForChromeWithDelegate:(id<UIAlertViewDelegate>)delegate;
+(NSInteger)chromeInstallAlertViewTag;

@end
