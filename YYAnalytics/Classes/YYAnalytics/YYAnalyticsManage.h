//
//  YYAnalyticsManage.h
//  Analytics
//
//  Created by jiyw on 2022/4/12.
//

#import <Foundation/Foundation.h>
#import "YYAnalyticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYAnalyticsManage : NSObject

/// 单例对象
+ (instancetype)shareInstance;

/// 开启埋点监听
- (void)startMonitor;

/// 上传更新埋点数据
- (void)updateAnalyticsData;

/// 存储埋点数据
- (void)saveAnalyticsData;

/// 获取埋点数据
- (NSArray *)getAnalyticsData;

/// 新增埋点
/// @param eventType 埋点类型
/// @param pageName 页面名称
/// @param clickName 点击事件名称
- (void)addAnalyticsEvent:(YYAnalyticsEventType)eventType pageName:(NSString *)pageName clickName:(NSString *)clickName;

/// 新增埋点
/// @param model 埋点模型
- (void)addAnalyticsModel:(YYAnalyticsModel *)model;

/// 清除埋点数据
- (void)clearAnalyticsData;

@end

NS_ASSUME_NONNULL_END
