//
//  LoginViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "LoginViewController.h"
// 注册页面
#import "RegisterViewController.h"
// 手机号登录页面
#import "PhoneLoginViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 进行布局
    [self setUpUI];
}
#pragma mark --- 进行布局
- (void)setUpUI{
    UIView * blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    // 背景图
    UIImageView * backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT)];
    backView.image = [UIImage imageNamed:@"beijing"];
    [self.view addSubview:backView];
    
    // 取消按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置按钮上字体的大小
//    [cancelBtn setFont:[UIFont systemFontOfSize:15]];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn sizeToFit];
    cancelBtn.frame = CGRectMake(Margin30 * IPHONE6_W_SCALE, 34, 50, 15);
    // 按钮上的文字居左
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [cancelBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    
    // 手机号登录按钮
    UIButton * phoneLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneLogin.bounds = CGRectMake(0, 0, Margin460 * IPHONE6_W_SCALE, Margin90 * IPHONE6_H_SCALE);
    phoneLogin.center = CGPointMake(WIDTH / 2, 567 / 2 * IPHONE6_H_SCALE);
    [phoneLogin setImage:[UIImage imageNamed:@"shoujihaodenglu"] forState:UIControlStateNormal];
    [phoneLogin addTarget:self action:@selector(phoneLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneLogin];
    
    // 注册按钮
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.bounds = CGRectMake(0, 0, Margin460 * IPHONE6_W_SCALE, Margin90 * IPHONE6_H_SCALE);
    CGFloat registerY = CGRectGetMaxY(phoneLogin.frame) + (Margin70 + Margin90 / 2) * IPHONE6_H_SCALE;
    registerBtn.center = CGPointMake(WIDTH / 2, registerY);
    [registerBtn setImage:[UIImage imageNamed:@"lijizhuce"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

#pragma mark --- 手机号登录
- (void)phoneLoginAction{
    NSLog(@"手机号登录");
    PhoneLoginViewController * phoneLoginVC = [[PhoneLoginViewController alloc] init];
    [self.navigationController pushViewController:phoneLoginVC animated:YES];
}

#pragma mark --- 立即注册
- (void)registerAction{
    NSLog(@"立即注册");
    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)returnBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
