//
//  YYAspectMananer.m
//  Analytics
//
//  Created by jiyw on 2022/4/13.
//

#import "YYAspectMananer.h"
#import "Aspects.h"
#import <objc/runtime.h>
#import "YYEvent.h"
#import "YYDefine.h"
#import "YYAnalyticsManage.h"

@implementation YYAspectMananer

+ (void)trackAspectHooksWithEventDict:(NSDictionary *)eventDict
{
    [self trackViewAppearWithEventDict:eventDict];
    [self trackClickEventWithEventDict:eventDict];
}


#pragma mark -- 监控统计用户进入此界面的时长，频率等信息
+ (void)trackViewAppearWithEventDict:(NSDictionary *)eventDict
{
//    NSDictionary *eventDict = [YYEvent getEventDictionary];
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *className = NSStringFromClass([[aspectInfo instance] class]);
            NSString *pageName = eventDict[className][YYEvent.pageName];
            if (pageName.length > 0) {
                NSLog(@"viewWillAppear --- %@", pageName);
            }
        });
    } error:NULL];
    
    
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *className = NSStringFromClass([[aspectInfo instance] class]);
            NSString *pageName = eventDict[className][YYEvent.pageName];
            if (pageName.length > 0) {
                NSLog(@"viewWillDisappear --- %@", pageName);
            }
        });
    } error:NULL];
}

#pragma mark --- 监控点击事件
+ (void)trackClickEventWithEventDict:(NSDictionary *)eventDict
{
    __weak typeof(self) ws = self;
    
    //设置事件统计
    //放到异步线程去执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //读取配置文件，获取需要统计的事件列表
//        NSDictionary *eventDict = [YYEvent getEventDictionary];
        for (NSString *classNameString in eventDict.allKeys) {
            //使用运行时创建类对象
            const char * className = [classNameString UTF8String];
            //从一个字串返回一个类
            Class newClass = objc_getClass(className);
            
            NSDictionary *pageDict = [eventDict objectForKey:classNameString];
            NSString *pageName = pageDict[YYEvent.pageName];
            
            // 手势点击事件
            [ws hookButtonEventWithClass:newClass pageDict:pageDict pageName:pageName];
            
            // tableView点击事件
            [ws hookTableViewEventWithClass:newClass pageDict:pageDict pageName:pageName];
            
            // collectionView点击事件
            [ws hookCollectionViewEventWithClass:newClass pageDict:pageDict pageName:pageName];
            
            // 手势点击事件
            [ws hookGestureEventWithClass:newClass pageDict:pageDict pageName:pageName];
        }
    });
}

#pragma mark -- hook 按钮点击事件
+ (void)hookButtonEventWithClass:(Class)newClass pageDict:(NSDictionary *)pageDict pageName:(NSString *)pageName
{
    __weak typeof(self) ws = self;
    
    NSArray *buttonEventList = pageDict[YYEvent.buttonEvent];
    for (NSDictionary *eventDict in buttonEventList) {
        //事件方法名称
        NSString *eventMethodName = eventDict[YYEvent.methodName];
        SEL selector = NSSelectorFromString(eventMethodName);
        
        NSString *clickName = eventDict[YYEvent.clickName];
        
        id block = ^(id<AspectInfo> aspectInfo){
            [ws clickButton:nil pageName:pageName clickName:clickName];
        };
        
        if ([eventMethodName hasSuffix:@":"]) {
            block = ^(id<AspectInfo> aspectInfo, UIButton *button) {
                
                [ws clickButton:button pageName:pageName clickName:clickName];
                
            };
        }
        [newClass aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:block error:NULL];
    }
}

#pragma mark -- hook TableView点击事件
+ (void)hookTableViewEventWithClass:(Class)newClass pageDict:(NSDictionary *)pageDict pageName:(NSString *)pageName
{
    __weak typeof(self) ws = self;
    
    NSArray *tableViewEventList = pageDict[YYEvent.tableViewEvent];
    for (NSDictionary *eventDict in tableViewEventList) {
        //事件方法名称
        NSString *eventMethodName = eventDict[YYEvent.methodName];
        SEL selector = NSSelectorFromString(eventMethodName);
        
        NSString *clickName = eventDict[YYEvent.clickName];
        
        [newClass aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UITableView *tableView, NSIndexPath *indexPath) {
            
            [ws tableView:tableView cellForRowAtIndexPath:indexPath pageName:pageName clickName:clickName];
            
        } error:NULL];
    }
}

#pragma mark -- hook CollectionView点击事件
+ (void)hookCollectionViewEventWithClass:(Class)newClass pageDict:(NSDictionary *)pageDict pageName:(NSString *)pageName
{
    __weak typeof(self) ws = self;
    
    NSArray *collectionViewEventList = pageDict[YYEvent.collectionViewEvent];
    for (NSDictionary *eventDict in collectionViewEventList) {
        //事件方法名称
        NSString *eventMethodName = eventDict[YYEvent.methodName];
        SEL selector = NSSelectorFromString(eventMethodName);
        
        NSString *clickName = eventDict[YYEvent.clickName];
        
        [newClass aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UICollectionView *collectionView, NSIndexPath *indexPath) {
            
            [ws collectionView:collectionView didSelectItemAtIndexPath:indexPath pageName:pageName clickName:clickName];
            
        } error:NULL];
    }
}

#pragma mark -- hook 手势事件
+ (void)hookGestureEventWithClass:(Class)newClass pageDict:(NSDictionary *)pageDict pageName:(NSString *)pageName
{
    __weak typeof(self) ws = self;
    
    NSArray *gestureEventList = pageDict[YYEvent.gestureEvent];
    for (NSDictionary *eventDict in gestureEventList) {
        //事件方法名称
        NSString *eventMethodName = eventDict[YYEvent.methodName];
        SEL selector = NSSelectorFromString(eventMethodName);
        
        NSString *clickName = eventDict[YYEvent.clickName];
        
        [newClass aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UIGestureRecognizer *gesture) {
            
            [ws gesture:gesture pageName:pageName clickName:clickName];
            
        } error:NULL];
    }
}

#pragma mark --------------------
#pragma mark -- 1.监控button事件
+ (void)clickButton:(UIButton *)button pageName:(NSString*)pageName clickName:(NSString *)clickName
{
    NSLog(@"pageName--->%@",pageName);
    NSLog(@"clickName--->%@",clickName);
    [[YYAnalyticsManage shareInstance] addAnalyticsEvent:YYAnalyticsEventTypeClick pageName:pageName clickName:clickName];
}


#pragma mark -- 2.监控tableview
+ (void)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath pageName:(NSString*)pageName clickName:(NSString *)clickName
{
    
    NSLog(@"pageName--->%@",pageName);
    NSLog(@"clickName--->%@",clickName);
    [[YYAnalyticsManage shareInstance] addAnalyticsEvent:YYAnalyticsEventTypeClick pageName:pageName clickName:clickName];
}


#pragma mark -- 3.监控collection
+ (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath pageName:(NSString*)pageName clickName:(NSString *)clickName
{
    NSLog(@"pageName--->%@",pageName);
    NSLog(@"clickName--->%@",clickName);
    [[YYAnalyticsManage shareInstance] addAnalyticsEvent:YYAnalyticsEventTypeClick pageName:pageName clickName:clickName];
}

#pragma mark -- 4.监控手势
+ (void)gesture:(UIGestureRecognizer *)gesture pageName:(NSString*)pageName clickName:(NSString *)clickName
{
    NSLog(@"pageName--->%@",pageName);
    NSLog(@"clickName--->%@",clickName);
    [[YYAnalyticsManage shareInstance] addAnalyticsEvent:YYAnalyticsEventTypeClick pageName:pageName clickName:clickName];
}

@end
