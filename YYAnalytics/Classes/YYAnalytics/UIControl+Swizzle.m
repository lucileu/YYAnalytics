//
//  UIControl+Swizzle.m
//  Analytics
//
//  Created by jiyw on 2022/4/15.
//

#import "UIControl+Swizzle.h"
#import "NSObject+Swizzle.h"
#import "JYSystemTool.h"
#import "YYEvent.h"

@implementation UIControl (Swizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self yy_swizzleInstanceMethodSEL:@selector(sendAction:to:forEvent:) withSEL:@selector(yy_sendAction:to:forEvent:)];
    });
}

- (void)yy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    NSLog(@"之前 --- %@ --- %@ --- %@", NSStringFromSelector(action), target, event);
    
    [self yy_sendAction:action to:target forEvent:event];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"埋点" message:@"请输入埋点名称" preferredStyle:UIAlertControllerStyleAlert];

        __weak __typeof(alertVC) weakAlertVC = alertVC;
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull alertAction){
            UITextField *firstTextField = weakAlertVC.textFields[0];
            UITextField *secondTextField = weakAlertVC.textFields[1];
            NSLog(@"%@ -- %@", firstTextField.text, secondTextField.text);
//            NSLog(@"之后 --- %@ --- %@ --- %@", NSStringFromSelector(action), target, event);
            if ([target isKindOfClass:[UIViewController class]]) {
                NSString *key = NSStringFromClass([target class]);
                if (![YYEvent shareInstance].eventDict[key]) {
                    [YYEvent shareInstance].eventDict[key] = [NSMutableDictionary dictionary];
                }
                [YYEvent shareInstance].eventDict[key][YYEvent.pageName] = firstTextField.text;
                NSArray *array = [YYEvent shareInstance].eventDict[key][YYEvent.buttonEvent];
                if (array.count == 0) {
                    array = [NSMutableArray array];
                }
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
                NSMutableDictionary *clickDict = [NSMutableDictionary dictionary];
                clickDict[YYEvent.methodName] = NSStringFromSelector(action);
                clickDict[YYEvent.clickName] = secondTextField.text;
                [tempArray addObject:clickDict];
                [YYEvent shareInstance].eventDict[key][YYEvent.buttonEvent] = tempArray;
                [YYEvent saveEvent];
            }
            
        }]];

        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];

        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入页面名称";
        }];
        
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入埋点名称";
        }];

        [[JYSystemTool currentViewController] presentViewController:alertVC animated:YES completion:nil];
    });
    
}

@end
