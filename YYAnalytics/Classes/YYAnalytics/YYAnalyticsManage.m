//
//  YYAnalyticsManage.m
//  Analytics
//
//  Created by jiyw on 2022/4/12.
//

#import "YYAnalyticsManage.h"
#import "YYTimerTool.h"
#import "YYAnalyticsApi.h"

static NSString * const key = @"YYAnalyticsManage";
#define TimeInterval 5.0
#define MaxCount 20

@interface YYAnalyticsManage ()

/** 埋点数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YYAnalyticsManage

+ (instancetype)shareInstance
{
    static YYAnalyticsManage *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)startMonitor
{
    NSArray *saveArray = [self getAnalyticsData];
    if (saveArray.count > 0) {
        self.dataArray = [NSMutableArray arrayWithArray:saveArray];
    }
    [YYTimerTool execTask:^{
        [self updateAnalyticsData];
    } start:0 interval:TimeInterval repeats:YES async:YES];
}

- (void)updateAnalyticsData
{
    if (self.dataArray.count == 0) return;
    [YYAnalyticsApi requestUploadAnalyticsData:self.dataArray result:^(BOOL success) {
        if (success) {
            [self clearAnalyticsData];
        }
    }];
}

- (void)saveAnalyticsData
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (YYAnalyticsModel *model in self.dataArray) {
        [tempArray addObject:[model modelToDict]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)getAnalyticsData
{
    NSArray *saveArray = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in saveArray) {
        [tempArray addObject:[YYAnalyticsModel modelWithDict:dict]];
    }
    return tempArray;
}

- (void)addAnalyticsEvent:(YYAnalyticsEventType)eventType pageName:(NSString *)pageName clickName:(NSString *)clickName
{
    YYAnalyticsModel *model = [[YYAnalyticsModel alloc] init];
    model.eventType = eventType;
    model.pageName = pageName;
    model.clickName = clickName;
    [self addAnalyticsModel:model];
}

- (void)addAnalyticsModel:(YYAnalyticsModel *)model
{
    [self.dataArray addObject:model];
    [self saveAnalyticsData];
    if (self.dataArray.count > MaxCount - 1) {
        [self updateAnalyticsData];
    }
}

- (void)clearAnalyticsData
{
    [self.dataArray removeAllObjects];
    [self saveAnalyticsData];
}

@end
