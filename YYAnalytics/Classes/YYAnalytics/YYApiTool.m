//
//  YYApiTool.m
//  Analytics
//
//  Created by jiyw on 2022/4/14.
//

#import "YYApiTool.h"
#import "AFNetworking.h"
#import "JYSystemTool.h"
#import "YYConfig.h"
#import "YYUserInfoTool.h"

@implementation YYApiTool

+ (AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer.timeoutInterval = 30;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}

+ (NSMutableDictionary *)getCommonParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"messageId"] = @"";
    parameters[@"productId"] = YYConfig.productId;
    parameters[@"channelNo"] = YYConfig.channelId;
    parameters[@"platform"] = YYConfig.platform;
    parameters[@"timeStamp"] = @(round(CFAbsoluteTimeGetCurrent() * 1000));
    parameters[@"innerVersion"] = [JYSystemTool getAppVersion];
    if ([YYUserInfoTool shareInstance].userInfo) {
        parameters[@"userCode"] = [YYUserInfoTool shareInstance].userInfo.userCode;
    }
    return parameters;
}

//MARK: 基础请求url
+ (void)baseRequestWithOperate:(NSString *)operate code:(NSString *)code data:(id)data headers:(NSDictionary *)headers response:(JY_RESPONSE_BLOCK)response
{
    NSString *url = YY_BaseUrl;
    NSMutableDictionary *parameters = [self getCommonParameters];
    parameters[@"operate"] = operate;
    parameters[@"code"] = code;
    parameters[@"data"] = [JYSystemTool jsonStringFromObject:data];
    if ([operate hasPrefix:@"http"]) {
        parameters[@"operate"] = @"";
        url = operate;
    }
    
    NSLog(@"url = %@ --- parameters = %@", url, parameters);
    [self.manager POST:url parameters:parameters headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            NSDictionary *dict = responseObject;
            NSNumber *msgCodeNum = [dict valueForKey:@"msgCode"];
            if ([msgCodeNum intValue]==0) {
                NSDictionary *newDict = [JYSystemTool objectFromJsonString:[dict valueForKey:@"data"]];
                response(newDict, nil);
            }else{
                response(nil, nil);
            }
        } else {
            response(nil, nil);
        }
        NSLog(@"url = %@ --- parameters = %@ --- responseObject = %@", url, parameters, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        response(nil,error);
        NSLog(@"url = %@ --- parameters = %@ --- error = %@", url, parameters, error);
    }];
}

@end
