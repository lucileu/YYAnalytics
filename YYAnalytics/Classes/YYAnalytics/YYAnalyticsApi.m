//
//  YYAnalyticsApi.m
//  Analytics
//
//  Created by jiyw on 2022/4/14.
//

#import "YYAnalyticsApi.h"
#import "YYApiTool.h"
#import "YYConfig.h"
#import "YYAnalyticsModel.h"
#import "JYSystemTool.h"
#import "YYUserInfoTool.h"

@implementation YYAnalyticsApi

+ (void)requestUploadAnalyticsData:(NSArray *)dataArray result:(void(^)(BOOL success))result
{
    NSMutableArray *dataList = [NSMutableArray array];
    for (YYAnalyticsModel *model in dataArray) {
        NSDictionary *data = @{
            @"type" : @1,
            @"smid" : @"",
            @"userId" : [YYUserInfoTool shareInstance].userInfo.userCode?:@"",
            @"channelId" : YYConfig.channelId,
            @"productId" : YYConfig.productId,
            @"appVer" : [JYSystemTool getAppVersion],
            @"scriptVer" : @"",
            @"eventType" : [YYAnalyticsModel eventTypeToString:model.eventType]?:@"",
            @"pageName" : model.pageName?:@"",
            @"clickName" : model.clickName?:@"",
            @"eventTime" : model.createdAt?:@"",
            @"extraJson" : @"",
        };
        [dataList addObject:data];
    }
    
    [YYApiTool baseRequestWithOperate:@"https://action.nianyuxinxi.cn/mobile/api/free/action/handlenew" code:@"fizz" data:dataList headers:nil response:^(NSDictionary *resultDict, NSError *error) {
        NSLog(@"resultDict = %@", resultDict);
        if (result) {
            if (resultDict != nil && [resultDict[@"code"] intValue] == 0) {
                result(YES);
            } else {
                result(NO);
            }
        }
    }];
}

@end
