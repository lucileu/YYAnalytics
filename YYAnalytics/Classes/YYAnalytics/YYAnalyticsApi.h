//
//  YYAnalyticsApi.h
//  Analytics
//
//  Created by jiyw on 2022/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYAnalyticsApi : NSObject

+ (void)requestUploadAnalyticsData:(NSArray *)dataArray result:(void(^)(BOOL success))result;

@end

NS_ASSUME_NONNULL_END
