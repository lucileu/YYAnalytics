//
//  YYDefine.h
//  Analytics
//
//  Created by jiyw on 2022/4/14.
//

#ifndef YYDefine_h
#define YYDefine_h

#ifdef DEBUG
#define NSLog(s, ...) NSLog( @"<%p %@:(%d)%s> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __func__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog(s, ...)
#endif


#define BURIED_POINT true


#endif /* YYDefine_h */
