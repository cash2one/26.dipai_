//
//  RootNavigationController.m
//  dipai
//
//  Created by 梁森 on 16/4/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) id popDelegate;

@end

@implementation RootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    // 设置navigationBar
    [self setNavigationBar];
    
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

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0] ) {   // 如果显示的是根视图控制器
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
    } else
    {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
