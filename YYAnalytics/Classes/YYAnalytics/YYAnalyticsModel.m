//
//  YYAnalyticsModel.m
//  Analytics
//
//  Created by jiyw on 2022/4/12.
//

#import "YYAnalyticsModel.h"

@implementation YYAnalyticsModel

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    YYAnalyticsModel *model = [[YYAnalyticsModel alloc] init];
    model.pageName = dict[@"pageName"];
    model.clickName = dict[@"clickName"];
    model.createdAt = dict[@"createdAt"];
    model.eventType = [YYAnalyticsModel eventTypeWithValue:dict[@"eventType"]];
    return model;
}

- (NSDictionary *)modelToDict
{
    return @{
        @"pageName" : self.pageName,
        @"clickName" : self.clickName,
        @"createdAt" : self.createdAt?:@"",
        @"eventType" : [YYAnalyticsModel eventTypeToString:self.eventType],
    };
}

+ (YYAnalyticsEventType)eventTypeWithValue:(NSString *)value
{
    YYAnalyticsEventType eventType = -1;
    if ([value isEqualToString:@"appStart"]) {
        eventType = YYAnalyticsEventTypeAppStart;
    } else if ([value isEqualToString:@"appstop"]) {
        eventType = YYAnalyticsEventTypeAppStop;
    } else if ([value isEqualToString:@"pageshow"]) {
        eventType = YYAnalyticsEventTypePageShow;
    } else if ([value isEqualToString:@"pagehide"]) {
        eventType = YYAnalyticsEventTypePageHide;
    } else if ([value isEqualToString:@"click"]) {
        eventType = YYAnalyticsEventTypeClick;
    }
    return eventType;
}

+ (NSString *)eventTypeToString:(YYAnalyticsEventType)eventType
{
    NSString *value;
    switch (eventType) {
        case YYAnalyticsEventTypeAppStart:
            value = @"appStart";
            break;
        case YYAnalyticsEventTypeAppStop:
            value = @"appstop";
            break;
        case YYAnalyticsEventTypePageShow:
            value = @"pageshow";
            break;
        case YYAnalyticsEventTypePageHide:
            value = @"pagehide";
            break;
        case YYAnalyticsEventTypeClick:
            value = @"click";
            break;
            
        default:
            break;
    }
    return value;
}

@end
