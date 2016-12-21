//
//  NavigationHiddenVC.m
//  dipai
//
//  Created by 梁森 on 16/10/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NavigationHiddenVC.h"
@interface NavigationHiddenVC ()

@end

@implementation NavigationHiddenVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
     self.navigationController.navigationBarHidden = YES;

}
// 没有被异地登录的处理
- (void)noLoginInOtherPhone{
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    NavigationBarV * naviBar = [[NavigationBarV alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:naviBar];
    naviBar.backgroundColor = [UIColor blackColor];
    self.naviBar = naviBar;
}
- (void)popAction{
     [self.navigationController popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
