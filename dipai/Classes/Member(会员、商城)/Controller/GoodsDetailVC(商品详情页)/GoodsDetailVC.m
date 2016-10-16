//
//  GoodsDetailVC.m
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "GoodsDetailVC.h"

// 订单详情页
#import "OrderDetailVC.h"
@interface GoodsDetailVC ()

@end

@implementation GoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationBar];
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"商品购买";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor = [UIColor redColor];
    [buyBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [self.view addSubview:buyBtn];
    buyBtn.frame = CGRectMake(0, 64, WIDTH, 30);
    [buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
}

// 跳转到购买页面
- (void)buyAction{
    
    OrderDetailVC * orderDetailVC = [[OrderDetailVC alloc] init];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
