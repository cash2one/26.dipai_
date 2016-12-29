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

#import "UMSocial.h"

#import "WXApi.h"
#import "AppDelegate.h"

#import "DataTool.h"
#import "SVProgressHUD.h"
// 友盟推送
#import "UMessage.h"
@interface LoginViewController ()<PhoneLoginViewControllerDelegate, RegisterViewControllerDelegate, AppDelegate, WXApiDelegate>

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    
    [SVProgressHUD dismiss];
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
    
    // 使用微信登录分隔线
    UIImageView * separateLine = [[UIImageView alloc] init];
    CGFloat lineX = 68 / 2 * IPHONE6_W_SCALE;
    CGFloat lineY = CGRectGetMaxY(registerBtn.frame) + 226 / 2 * IPHONE6_W_SCALE;
    CGFloat lineW = WIDTH - 2 * lineX;
    CGFloat lineH = 13 * IPHONE6_H_SCALE;
    separateLine.frame = CGRectMake(lineX, lineY, lineW, lineH);
    separateLine.image = [UIImage imageNamed:@"shiyongweixindenglu"];
    [self.view addSubview:separateLine];
    
    // 微信登录按钮
    UIButton * weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat weixinX = 312 / 2 * IPHONE6_W_SCALE;
    CGFloat weixinY = CGRectGetMaxY(separateLine.frame) + Margin40 * IPHONE6_H_SCALE;
    CGFloat weixinW = 126 / 2 * IPHONE6_W_SCALE;
    CGFloat weixinH = weixinW;
    weixinBtn.frame = CGRectMake(weixinX, weixinY, weixinW, weixinH);
    [weixinBtn setImage:[UIImage imageNamed:@"icon_weixin"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
}

#pragma mark --- 手机号登录
- (void)phoneLoginAction{
    NSLog(@"手机号登录。。。");
    PhoneLoginViewController * phoneLoginVC = [[PhoneLoginViewController alloc] init];
    phoneLoginVC.delegate = self;
    [self.navigationController pushViewController:phoneLoginVC animated:YES];
}

#pragma mark --- 立即注册
- (void)registerAction{
    NSLog(@"立即注册");
    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
    registerVC.delegate = self;
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark --- 微信登录
- (void)weixinLogin{
    
    NSLog(@"微信登录...");
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    
    [WXApi sendAuthReq:req viewController:self delegate:self];
    
    // 成功利用了AppDelegate
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.delegate = self;
}
- (void)dismissWithStr:(NSString *)str{
    // 给服务器发送code
    
    NSLog(@"给自己的服务器发送code：%s", __func__);
    NSString * url = wxCodeURL;
//    NSString * url = @"http://dpapp.replays.net/Weixin/wx_code";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * deviceToken = [defaults objectForKey:DipaiDevice];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"code"] = str;
    dic[@"system"] = @"1";
    dic[@"device"] = deviceToken;
    url = [NSString stringWithFormat:@"%@?code=%@&system=1&device=%@", url,str,deviceToken];
    NSLog(@"url:%@", url);
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [DataTool sendCodeWithStr:url parameters:dic success:^(id responseObject) {
        
        NSLog(@"发送code成功%@,", responseObject);
        if ([responseObject[@"state"] isEqualToString:@"1"]) {
            NSLog(@"注册成功...");
        }
        NSDictionary * data = responseObject[@"data"];
        NSString * userid = data[@"userid"];
        // 推送不用userid了
//        [UMessage addAlias:userid type:@"ALIAS_TYPE.DIPAI" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//           
//        }];
        NSLog(@"---data---:%@", data);
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:data forKey:WXUser];
        [userDefaults synchronize];
        [SVProgressHUD dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError * error) {
        
        NSLog(@"发送code出错1：%@", error);
    }];
}



- (void)returnBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ---- PhoneLoginViewControllerDelegate
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---- RegisterViewControllerDelegate
- (void)dismissAfterRegister{
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


@end
