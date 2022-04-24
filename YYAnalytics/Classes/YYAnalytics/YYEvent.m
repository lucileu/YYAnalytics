//
//  YYEvent.m
//  Analytics
//
//  Created by jiyw on 2022/4/14.
//

#import "YYEvent.h"

@interface YYEvent ()



@end

@implementation YYEvent

+ (instancetype)shareInstance
{
    static YYEvent *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (NSMutableDictionary *)eventDict
{
    if (_eventDict == nil) {
        _eventDict = [NSMutableDictionary dictionary];
    }
    return _eventDict;
}

+ (NSString *)pageName
{
    return @"pageName";
}

+ (NSString *)methodName
{
    return @"methodName";
}

+ (NSString *)clickName
{
    return @"clickName";
}

+ (NSString *)buttonEvent
{
    return @"buttonEvent";
}

+ (NSString *)tableViewEvent
{
    return @"tableViewEvent";
}

+ (NSString *)collectionViewEvent
{
    return @"collectionViewEvent";
}

+ (NSString *)gestureEvent
{
    return @"gestureEvent";
}

+ (void)saveEvent
{
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    filePath = [filePath stringByAppendingPathComponent:@"Event.plist"];
    [[self shareInstance].eventDict writeToFile:filePath atomically:YES];
    NSLog(@"filePath = %@", filePath);
}



@end
