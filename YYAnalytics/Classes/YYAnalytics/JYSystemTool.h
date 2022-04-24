//
//  JYSystemTool.h
//  VideoClip
//
//  Created by 刘浩 on 2019/4/17.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

typedef void(^JY_RESPONSE_BLOCK)(NSDictionary* resultDict, NSError* _Nullable  error);

@interface JYSystemTool : NSObject
+ (NSString *) md5:(NSString *) str;

+ (NSString *)getUUID;

+ (NSString *)getAppVersion;
//清除之前存在keychain上的uuid
+ (void)deleteUuid;
//利用keychain存uuid
+ (id)loadSevice:(NSString *)service ;
+ (void)deleteSevice:(NSString *)service ;
+ (void)saveSevice:(NSString *)service data:(id)data ;

+ (id)objectFromJsonString:(NSString *)string;

+ (NSString *)jsonStringFromObject:(id)object;

+ (BOOL)isBlankString:(NSString *)string;

/// 获取当前显示的ViewController
+ (UIViewController *)currentViewController;

+ (UIViewController *)viewControllerOfView:(UIView *)view;

+ (void)requestImageAuthorizationWithResult:(void (^)(id status))result;

@end

NS_ASSUME_NONNULL_END

