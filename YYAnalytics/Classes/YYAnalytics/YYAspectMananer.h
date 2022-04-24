//
//  YYAspectMananer.h
//  Analytics
//
//  Created by jiyw on 2022/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYAspectMananer : NSObject

+ (void)trackAspectHooksWithEventDict:(NSDictionary *)eventDict;

@end

NS_ASSUME_NONNULL_END
