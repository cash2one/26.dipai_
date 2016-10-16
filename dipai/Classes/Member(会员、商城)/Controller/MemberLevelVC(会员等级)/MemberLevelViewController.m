//
//  MemberLevelViewController.m
//  dipai
//
//  Created by 梁森 on 16/10/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MemberLevelViewController.h"

#import "NumberDetailVC.h"
// 更多礼遇页面
#import "MoreBenifitsVC.h"
@interface MemberLevelViewController ()

@end

@implementation MemberLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    
    [self setUpUI];
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"会员等级";
    self.naviBar.rightStr = @"积分明细";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar.rightBtn addTarget:self action:@selector(seeNumDetail) forControlEvents:UIControlEventTouchUpInside];
}

// 跳转到积分详情页面
- (void)seeNumDetail{
    
    NumberDetailVC * numDetailVC = [[NumberDetailVC alloc] init];
    [self.navigationController pushViewController:numDetailVC animated:YES];
}

- (void)setUpUI{
    
    // 更多礼遇按钮
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:moreBtn];
    moreBtn.frame = CGRectMake(WIDTH - 100, 200, 100, 30);
    moreBtn.backgroundColor = [UIColor redColor];
    [moreBtn addTarget:self action:@selector(seeMoreBenifits) forControlEvents:UIControlEventTouchUpInside];
}
// 跳转到更多礼遇页面
- (void)seeMoreBenifits{
    
    MoreBenifitsVC * moreVC = [[MoreBenifitsVC alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
