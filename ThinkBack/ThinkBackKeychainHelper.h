
#import <Foundation/Foundation.h>


@interface ThinkBackKeychainHelper : NSObject

+ (BOOL)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (BOOL)delete:(NSString *)service;

@end