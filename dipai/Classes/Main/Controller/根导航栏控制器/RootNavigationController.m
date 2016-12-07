//
//  RootNavigationController.m
//  dipai
//
//  Created by 梁森 on 16/4/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) id popDelegate;

@end

@implementation RootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.delegate = self;
//    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    
    // 添加手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    // 系统自带手势失效
    self.interactivePopGestureRecognizer.enabled = NO;
    // 设置navigationBar
    [self setNavigationBar];
    
}
#pragma mark --- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    // 如果不是根视图控制器就让侧滑手势有效，否则失效
    if (self.childViewControllers.count > 1) {
        return YES;
    }else{
        
        return NO;
    }
}

- (void)setNavigationBar
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = NavigationBarTitleColor;
    dic[NSFontAttributeName] = NavigationBarTitleFont;
    [self.navigationBar setTitleTextAttributes:dic];

    // 设置导航栏背景色
//    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_beijingditu"] forBarMetrics:UIBarMetricsDefault];
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (viewController == self.viewControllers[0] ) {   // 如果显示的是根视图控制器
//        self.interactivePopGestureRecognizer.delegate = _popDelegate;
//    } else
//    {
//        self.interactivePopGestureRecognizer.delegate = nil;
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
