//
//  JYSystemTool.m
//  VideoClip
//
//  Created by 刘浩 on 2019/4/17.
//  Copyright © 2019 admin. All rights reserved.
//

#import "JYSystemTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
#import <NetworkExtension/NetworkExtension.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <Photos/PHPhotoLibrary.h>

#define KEY_UDID_INSTEAD [NSString stringWithFormat:@"%@_UDID_INSTEAD", [[NSBundle mainBundle] bundleIdentifier]]

static JYSystemTool *instance;
@interface JYSystemTool()
@property(nonatomic,strong) NSString *mMacAddress;
@property(nonatomic,strong) NSString *mUniqueIdentification;
@property(nonatomic,assign) BOOL hasShownMsg;

@end
@implementation JYSystemTool
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JYSystemTool new];
    });
    return instance;
}

+ (NSString *) md5:(NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString *)getUUID{
    NSString *k_uuid = [self loadSevice:KEY_UDID_INSTEAD];
    if (k_uuid) {
        return k_uuid;
    }else{
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        
        NSString* app_uuid = [NSString stringWithString:(__bridge NSString*)uuidString];
        
        CFRelease(uuidString);
        
        CFRelease(uuidRef);
        [self saveSevice:KEY_UDID_INSTEAD data:app_uuid];
        return app_uuid;
    }
}

+ (void)deleteSevice:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
+(void)deleteUuid{
    [self deleteSevice:KEY_UDID_INSTEAD];
//    [[JYVIPCheckManager shared] clean];
}
+ (id)loadSevice:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)saveSevice:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+(NSString *)getAppVersion{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+ (id)objectFromJsonString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    return  object;
}

+ (NSString *)jsonStringFromObject:(id)object
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}

+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

// 获取当前显示的ViewController
+ (UIViewController *)currentViewController
{
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (1) {
        if ([topVC isKindOfClass:[UITabBarController class]]) {
            topVC = ((UITabBarController*)topVC).selectedViewController;
        }
        if ([topVC isKindOfClass:[UINavigationController class]]) {
            topVC = ((UINavigationController*)topVC).visibleViewController;
        }
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        } else {
            break;
        }
    }
    return topVC;
}

+ (UIViewController *)viewControllerOfView:(UIView *)view
{
    // 遍历响应者链。返回第一个找到视图控制器
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: [UIViewController class]]){
            return (UIViewController *)responder;
        }
    }
    // 如果没有找到则返回nil
    return nil;
}


+ (PHAuthorizationStatus)authorizationStatus {
    PHAuthorizationStatus status;
#ifdef __IPHONE_14_0
    if (@available(iOS 14, *)) {
        status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
#else
    if(NO) {
#endif
    }else {
        status = [PHPhotoLibrary authorizationStatus];
    }
    return status;
}

+ (void)requestImageAuthorizationWithResult:(void (^)(id status))result
{
    PHAuthorizationStatus status = [self authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        result([NSNumber numberWithBool:YES]);
    }
#ifdef __IPHONE_14_0
    else if (@available(iOS 14, *)) {
        if (status == PHAuthorizationStatusLimited) {
            result([NSNumber numberWithBool:YES]);
        }
#endif
    else if (status == PHAuthorizationStatusDenied ||
             status == PHAuthorizationStatusRestricted) {
        result([NSNumber numberWithBool:NO]);
    }else {
#ifdef __IPHONE_14_0
        if (@available(iOS 14, *)) {
            [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status != PHAuthorizationStatusAuthorized &&
                        status != PHAuthorizationStatusLimited) {
                        result([NSNumber numberWithBool:NO]);
                    }else {
                        result([NSNumber numberWithBool:YES]);
                    }
                });
            }];
        }
#else
        if (NO) {}
#endif
        else {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status != PHAuthorizationStatusAuthorized) {
                        result([NSNumber numberWithBool:NO]);
                    }else {
                        result([NSNumber numberWithBool:YES]);
                    }
                });
            }];
        }
    }
#ifdef __IPHONE_14_0
    }else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status != PHAuthorizationStatusAuthorized) {
                    result([NSNumber numberWithBool:NO]);
                }else {
                    result([NSNumber numberWithBool:YES]);
                }
            });
        }];
    }
#endif
}

@end
