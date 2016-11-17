//
//  BenifitsArticleVC.m
//  dipai
//
//  Created by 梁森 on 16/11/11.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "BenifitsArticleVC.h"

@interface BenifitsArticleVC ()

@end

@implementation BenifitsArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationBar];
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"礼遇条款";
    self.naviBar.leftStr = @"取消";
    [self.naviBar.popBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}
- (void)dismiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
