//
//  YYAnalyticsModel.h
//  Analytics
//
//  Created by jiyw on 2022/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYAnalyticsEventType) {
    YYAnalyticsEventTypeAppStart,
    YYAnalyticsEventTypeAppStop,
    YYAnalyticsEventTypePageShow,
    YYAnalyticsEventTypePageHide,
    YYAnalyticsEventTypeClick
};


@interface YYAnalyticsModel : NSObject

/** 页面名称 */
@property (nonatomic, strong) NSString *pageName;
/** 点击事件 */
@property (nonatomic, strong) NSString *clickName;
/** 创建时间 */
@property (nonatomic, strong) NSString *createdAt;
/** 事件类型 */
@property (nonatomic, assign) YYAnalyticsEventType eventType;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (NSDictionary *)modelToDict;

+ (YYAnalyticsEventType)eventTypeWithValue:(NSString *)value;

+ (NSString *)eventTypeToString:(YYAnalyticsEventType)eventType;

@end

NS_ASSUME_NONNULL_END
