//
//  YYUserInfo.m
//  Analytics
//
//  Created by jiyw on 2022/4/14.
//

#import "YYUserInfoTool.h"
#import "JYSystemTool.h"
#import "YYModel.h"

#define YY_USER_INFO_KEY  @"YY_USER_INFO_KEY"

@implementation YYUserInfo

@end

@interface YYUserInfoTool ()


@end

@implementation YYUserInfoTool

+ (instancetype)shareInstance
{
    static YYUserInfoTool *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)saveUserInfo
{
    if (self.userInfo) {
        NSDictionary *dict = [self convertToDictFromUserModel:_userInfo];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:YY_USER_INFO_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)loadUserInfo
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:YY_USER_INFO_KEY];
    if (dict) {
        self.userInfo = [self convertToUserModelFromDict:dict];
    }
}


- (NSDictionary *)convertToDictFromUserModel:(YYUserInfo *)userInfo
{
    // 将模型转数据
    NSDictionary *dict = [userInfo yy_modelToJSONObject];
    return dict;
}

- (YYUserInfo *)convertToUserModelFromDict:(NSDictionary *)dict
{
    // 将数据转模型
    YYUserInfo *model = [YYUserInfo yy_modelWithDictionary:dict];
    return model;
}

@end
