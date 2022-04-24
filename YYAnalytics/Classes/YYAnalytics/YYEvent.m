//
//  YYEvent.m
//  Analytics
//
//  Created by jiyw on 2022/4/14.
//

#import "YYEvent.h"
#import "YYBuriedPoint.h"

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

+ (NSDictionary *)getEventDictionary
{
    return @{
        @"RedViewController" : @{
            YYEvent.pageName : Page0.pageName,
            YYEvent.buttonEvent : @[
                @{
                    YYEvent.methodName : @"clickButton:",
                    YYEvent.clickName : Page0.click0
                },
                @{
                    YYEvent.methodName : @"notParams",
                    YYEvent.clickName : Page0.click1
                },
            ],
            YYEvent.tableViewEvent : @[
                @{
                    YYEvent.methodName : @"tableView:didSelectRowAtIndexPath:",
                    YYEvent.clickName : Page0.click2
                },
            ],
            YYEvent.collectionViewEvent : @[
                @{
                    YYEvent.methodName : @"collectionView:didSelectItemAtIndexPath:",
                    YYEvent.clickName : Page0.click3
                },
            ]
        },
        @"BlueViewController" : @{
            YYEvent.pageName : Page1.pageName,
            YYEvent.buttonEvent : @[
                @{
                    YYEvent.methodName : @"testClick:",
                    YYEvent.clickName : Page1.click0
                },
            ]
        },
    };
}

@end
