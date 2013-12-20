//
//  AppDetect.m
//  ThinkBack
//
//  Created by AndrewTremblay on 12/19/13.
//  Copyright (c) 2013 andrewtremblay. All rights reserved.
//

#import "ThirdPartyAppFeatures.h"

@implementation ThirdPartyAppFeatures

#pragma Chrome
+(BOOL)canDetectChrome
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]];
}

+(NSURL *)chromeInstallURL
{
    return [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/chrome/id535886823"];
}
+(void)presentInstallationAlertViewForChromeWithDelegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"We haven't detected Chrome on this device. Would you like to install it?" delegate:delegate cancelButtonTitle:@"Cancel" otherButtonTitles:@"Install", nil];
    alert.tag = [self chromeInstallAlertViewTag];
    [alert show];
}
+(NSInteger)chromeInstallAlertViewTag
{
    return [@11111111111 integerValue];
}

@end
