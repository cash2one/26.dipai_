//
//  ServerVC.m
//  dipai
//
//  Created by 梁森 on 16/10/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ServerVC.h"

@interface ServerVC ()

@end

@implementation ServerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SeparateColor;
    [self setNavigationBar];
}

- (void)setNavigationBar{
    
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    self.naviBar.titleStr = @"客服中心";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
