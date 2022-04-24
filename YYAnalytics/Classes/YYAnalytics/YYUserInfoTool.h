//
//  YYUserInfo.h
//  Analytics
//
//  Created by jiyw on 2022/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYUserInfo : NSObject

/** Authorization */
@property (nonatomic, strong) NSString *Authorization;
/** unionId */
@property (nonatomic, strong) NSString *unionId;
/** nickName */
@property (nonatomic, strong) NSString *nickName;
/** sex */
@property (nonatomic, strong) NSString *sex;
/** mobile */
@property (nonatomic, strong) NSString *mobile;
/** userDesc */
@property (nonatomic, strong) NSString *userDesc;
/** accessToken */
@property (nonatomic, strong) NSString *accessToken;
/** userHeader */
@property (nonatomic, strong) NSString *userHeader;
/** userId */
@property (nonatomic, strong) NSString *userId;
/** userCode */
@property (nonatomic, strong) NSString *userCode;
/** isBindingWechat */
@property (nonatomic, strong) NSString *isBindingWechat;
/** userName */
@property (nonatomic, strong) NSString *userName;
/** vipType */
@property (nonatomic, strong) NSString *vipType;
/** vipEndTime */
@property (nonatomic, strong) NSString *vipEndTime;

@end

@interface YYUserInfoTool : NSObject

/** userInfo */
@property (nonatomic, strong) YYUserInfo *userInfo;

+ (instancetype)shareInstance;

- (void)saveUserInfo;

- (void)loadUserInfo;

- (NSDictionary *)convertToDictFromUserModel:(YYUserInfo *)userInfo;

- (YYUserInfo *)convertToUserModelFromDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
