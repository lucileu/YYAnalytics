//
//  YYApiTool.h
//  Analytics
//
//  Created by jiyw on 2022/4/14.
//

#import <Foundation/Foundation.h>

#define formal true

#define YY_BaseUrlRelease @"https://platform.fuguizhukj.cn/mobile/api/united/sendnewnet"
#define YY_BaseUrlDebug @"http://platform-test.fuguizhukj.cn/mobile/api/united/sendnewnet"
#define YY_BaseUrl formal?YY_BaseUrlRelease:YY_BaseUrlDebug

typedef void(^JY_RESPONSE_BLOCK)(NSDictionary *result, NSError *error);
typedef void(^JY_RESPONSE_ORIGINAL_BLOCK)(id responseObject, NSError *error);


@interface YYApiTool : NSObject

+ (void)baseRequestWithOperate:(NSString *)operate code:(NSString *)code data:(id)data headers:(NSDictionary *)headers response:(JY_RESPONSE_BLOCK)response;

@end


