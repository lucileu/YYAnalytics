//
//  YYEvent.h
//  Analytics
//
//  Created by jiyw on 2022/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYEvent : NSObject

/** 埋点事件 */
@property (nonatomic, strong) NSMutableDictionary *eventDict;

+ (instancetype)shareInstance;

+ (NSString *)pageName;

+ (NSString *)methodName;

+ (NSString *)clickName;

+ (NSString *)buttonEvent;

+ (NSString *)tableViewEvent;

+ (NSString *)collectionViewEvent;

+ (NSString *)gestureEvent;

+ (void)saveEvent;

/// 获取所有埋点事件
+ (NSDictionary *)getEventDictionary;

@end

NS_ASSUME_NONNULL_END
