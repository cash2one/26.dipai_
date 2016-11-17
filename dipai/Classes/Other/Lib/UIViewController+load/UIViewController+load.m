//
//  UIViewController+load.m
//  UIViewController分类
//
//  Created by 梁森 on 16/9/18.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "UIViewController+load.h"
#import <objc/objc.h>
#import <objc/runtime.h>
@implementation UIViewController (load)

+ (void)load
{
    
    Method m1;
    Method m2;
    
    // 运行时替换方法
    m1 = class_getInstanceMethod(self, @selector(statisticsViewWillAppear:));
    m2 = class_getInstanceMethod(self, @selector(viewWillAppear:));
    
    method_exchangeImplementations(m1, m2);
    
    
    m1 = class_getInstanceMethod(self, @selector(statisticsViewWillDisappear:));
    m2 = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    
    method_exchangeImplementations(m1, m2);
}


- (void) statisticsViewWillAppear:(BOOL)animated
{
    [self statisticsViewWillAppear:animated];
    
//    NSLog(@"%s", __func__);
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

-(void) statisticsViewWillDisappear:(BOOL)animated
{
    [self statisticsViewWillDisappear:animated];
    
//    NSLog(@"%s", __func__);
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
