//
//  NSObject+Swizzle.h
//  Analytics
//
//  Created by jiyw on 2022/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzle)

+ (BOOL)yy_swizzleInstanceMethodSEL:(SEL)originalSEL withSEL:(SEL)targetSEL;

+ (BOOL)yy_swizzleClassMethodSEL:(SEL)originalSEL withSEL:(SEL)targetSEL;

@end

NS_ASSUME_NONNULL_END
