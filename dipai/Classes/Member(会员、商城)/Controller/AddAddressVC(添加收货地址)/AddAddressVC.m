//
//  AddAddressVC.m
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AddAddressVC.h"

#import "Masonry.h"
@interface AddAddressVC ()

@end

@implementation AddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor  = [UIColor whiteColor];
    
      [self setNavigationBar];
}


- (void)setNavigationBar{
    
    self.naviBar.titleLbl.hidden = YES;
    self.naviBar.popV.hidden = NO;
    self.naviBar.leftStr = @"取消";
    [self.naviBar.popBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLbl = [[UILabel alloc] init];
    [self.view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@(44));
        make.width.equalTo(@(160 * IPHONE6_W_SCALE));
    }];
    titleLbl.text = @"新增收货地址";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment =  NSTextAlignmentCenter;
}

- (void)dismissAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
