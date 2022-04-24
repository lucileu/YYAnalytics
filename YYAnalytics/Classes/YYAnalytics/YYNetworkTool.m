//
//  YYNetworkTool.m
//  Analytics
//
//  Created by jiyw on 2022/4/12.
//

#import "YYNetworkTool.h"
#import "YYAnalyticsModel.h"
#import "JYSystemTool.h"
#import <AFNetworking/AFNetworking.h>
#import "YYDefine.h"

#define JY_BaseUrl @"https://action.nianyuxinxi.cn/mobile/api/free/action/handlenew"

@implementation YYNetworkTool

+ (void)requestUploadAnalyticsData:(NSArray *)dataArray result:(void(^)(BOOL success))result
{
    NSMutableArray *dataList = [NSMutableArray array];
    for (YYAnalyticsModel *model in dataArray) {
        NSDictionary *data = @{
            @"type" : @1,
            @"smid" : @"",
            @"userId" : @"",
            @"channelId" : @14900,
            @"productId" : @149,
            @"appVer" : @"",
            @"scriptVer" : @"",
            @"eventType" : [YYAnalyticsModel eventTypeToString:model.eventType],
            @"pageName" : model.pageName,
            @"clickName" : model.clickName,
            @"eventTime" : @(round(CFAbsoluteTimeGetCurrent() * 1000)),
            @"extraJson" : @"",
        };
        [dataList addObject:data];
    }
    NSDictionary *parameters = @{
        @"messageId" : @"",
        @"productId" : @149,
        @"channelNo" : @14900,
        @"platform" : @"iOS",
        @"timeStamp" : @(round(CFAbsoluteTimeGetCurrent() * 1000)),
        @"innerVersion" : [JYSystemTool getAppVersion],
        @"userCode" : @"",
        @"code" : @"fizz",
        @"data" : [JYSystemTool jsonStringFromObject:dataList],
        @"operate" : @""
    };
    NSLog(@"验证接口 = %@", parameters);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer.timeoutInterval = 30;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:JY_BaseUrl parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)[JYSystemTool objectFromJsonString:responseObject[@"data"]];
        NSLog(@"dict = %@", dict);
        if (result) {
            if ([dict[@"code"] intValue] == 0) {
                result(YES);
            } else {
                result(NO);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        if (result) {
            result(NO);
        }
    }];
}

@end
