//
//  AppDelegate+Analytics.m
//  Analytics
//
//  Created by jiyw on 2022/4/14.
//

#import "AppDelegate+Analytics.h"
#import "YYAnalyticsManage.h"
#import "YYAspectMananer.h"

@implementation AppDelegate (Analytics)

+ (void)setUpAnalytics
{
//    [YYAspectMananer trackAspectHooks];
    [[YYAnalyticsManage shareInstance] startMonitor];
}



@end
