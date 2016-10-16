//
//  SelectAddressVC.m
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "SelectAddressVC.h"

#import "Masonry.h"
// 添加收货地址
#import "AddAddressVC.h"
@interface SelectAddressVC ()

@end

@implementation SelectAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
}

- (void)setNavigationBar{
    
    self.naviBar.titleLbl.hidden = YES;
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLbl = [[UILabel alloc] init];
    [self.view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@(44));
        make.width.equalTo(@(160 * IPHONE6_W_SCALE));
    }];
    titleLbl.text = @"选择收货地址";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment =  NSTextAlignmentCenter;
    
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:addBtn];
    addBtn.frame = CGRectMake(0, HEIGHT - 64 - 30, WIDTH, 30);
    [addBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addAddressAction) forControlEvents:UIControlEventTouchUpInside];
}


// 添加收货地址
- (void)addAddressAction{
    
    AddAddressVC * addAddressVC = [[AddAddressVC alloc] init];
    [self presentViewController:addAddressVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
