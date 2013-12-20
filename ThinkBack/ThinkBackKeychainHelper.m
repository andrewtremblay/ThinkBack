#import "ThinkBackKeychainHelper.h"
#import <Security/Security.h>


@implementation ThinkBackKeychainHelper
// Accepts service name and NSCoding-complaint data object. Automatically overwrites if something exists.
//Returns true on success
+ (BOOL)save:(NSString *)service data:(id)data
{
    
    BOOL wasSuccessful = YES;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    OSStatus resultCode = SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    resultCode =  SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    if(resultCode != noErr){
        NSLog(@"Attempting to store %@ failed", data);
        NSLog(@"Error storing to keychain: %ld : %@", resultCode, [ThinkBackKeychainHelper errorMessageFromCode:resultCode]);
        if(resultCode == errSecDuplicateItem){
            id dataExistenceCheck = [ThinkBackKeychainHelper load:service];
            NSLog(@"This exists instead: %@", dataExistenceCheck);
        }
         wasSuccessful = NO;
    }else{
        wasSuccessful = YES;
    }
    
    return wasSuccessful;
}

// Returns an object inflated from the data stored in the keychain entry for the given service.
+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    //NSLog(@"load with query: %@", keychainQuery  );

    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
            if(ret == nil){ NSLog(@"Keychain data not found." ); }
        }
        @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        }
        @finally {}
    }
    
    //NSLog(@"what do we have %@", ret);
    if (keyData) CFRelease(keyData);
    return ret;
}

// Removes the entry for the given service from keychain.
+ (BOOL)delete:(NSString *)service
{
    BOOL wasSuccessful = YES;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    OSStatus resultCode = SecItemDelete((__bridge CFDictionaryRef) keychainQuery);
    if(resultCode != noErr){
        NSLog(@"Error deleting from keychain: %ld : %@", resultCode, [ThinkBackKeychainHelper errorMessageFromCode:resultCode]);
        wasSuccessful = NO;
    }else{
        wasSuccessful = YES;
    }
    return wasSuccessful;
}



+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock, (__bridge id)kSecAttrAccessible, // Keychain must be unlocked to access this value. It will persist across backups.
            nil];
    
}

//SecCopyErrorMessageString doesn't work in iOS! Consternation! This will have to do in the meantime
+(NSString*) errorMessageFromCode:(OSStatus)keychainErrorCode
{
    NSString *errorMessage = @"";
    switch (keychainErrorCode) {
        case errSecSuccess:
            errorMessage = @"\"No error.\" Wait. What? ";
            break;
        case errSecUnimplemented:
            errorMessage = @"Function or operation not implemented.";
            break;
        case errSecParam:
            errorMessage = @"One or more parameters passed to a function where not valid.";
            break;
        case errSecAllocate:
            errorMessage = @"Failed to allocate memory.";
            break;
        case errSecNotAvailable:
            errorMessage = @"No keychain is available. You may need to restart your device.";
            break;
        case errSecDuplicateItem:
            errorMessage = @"The specified item already exists in the keychain.";
            break;
        case errSecItemNotFound:
            errorMessage = @"The specified item could not be found in the keychain.";
            break;
        case errSecInteractionNotAllowed:
            errorMessage = @"User interaction is not allowed.";
            break;
        case errSecDecode:
            errorMessage = @"Unable to decode the provided data.";
            break;
        default:
            errorMessage = @"(unknown error)";
            break;
    } //Not using the AppBlade Logs here because this is a CRITICAL error that should not be kept quiet.
    return errorMessage;
}




@end