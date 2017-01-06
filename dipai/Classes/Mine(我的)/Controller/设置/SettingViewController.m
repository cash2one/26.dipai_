//
//  SettingViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/30.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "SettingViewController.h"

//
#import "SettingCell.h"
// 关于底牌页面
#import "AbountDiPai.h"

#import "SVProgressHUD.h"
#import "UMessage.h"
@interface SettingViewController ()
// 退出按钮
@property (nonatomic, strong) UIButton * outBtn;

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self getDataOfLogin];
}

- (void)getDataOfLogin{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * name = [defaults objectForKey:Cookie];
//    NSDictionary * dataDic = [defaults objectForKey:User];
    NSDictionary * wxData = [defaults objectForKey:WXUser];
    if (name || wxData) {
        _outBtn.hidden = NO;
    }else{
        _outBtn.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    [self setNavigationBar];
    [self setUpUI];
}
#pragma mark --- 设置导航条
- (void)setNavigationBar {
    self.naviBar.titleStr = @"设置";
    self.naviBar.popV.hidden = NO;
    self.naviBar.backgroundColor = [UIColor whiteColor];
    self.naviBar.bottomLine.hidden = NO;
    self.naviBar.popImage = [UIImage imageNamed:@"houtui"];
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --- 搭建界面
- (void)setUpUI{
    // 关于底牌
    CGFloat abountX = 0;
    CGFloat abountY = 18 / 2 * IPHONE6_H_SCALE + 64;
    CGFloat abountW = WIDTH;
    CGFloat abountH = 99 / 2 * IPHONE6_H_SCALE;
    SettingCell * AbountCell = [[SettingCell alloc] initWithFrame:CGRectMake(abountX, abountY, abountW, abountH)];
    AbountCell.titleLbl.text = @"关于底牌";
    AbountCell.titleLbl.font = Font16;
    AbountCell.btn.tag = 1;
    [AbountCell.btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:AbountCell];
    
    // 评分
    SettingCell * AppStoreCell = [[SettingCell alloc] init];
    AppStoreCell.titleLbl.text = @"去AppStore评分";
    AppStoreCell.titleLbl.font = Font16;
    CGFloat appX = 0;
    CGFloat appY = CGRectGetMaxY(AbountCell.frame);
    CGFloat appW = WIDTH;
    CGFloat appH = abountH;
    AppStoreCell.frame = CGRectMake(appX, appY, appW, appH);
    AppStoreCell.btn.tag = 2;
    [AppStoreCell.btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:AppStoreCell];
    
    
    // 当前版本
    SettingCell * versionCell = [[SettingCell alloc] init];
    versionCell.titleLbl.text = @"当前版本";
    versionCell.titleLbl.font = Font16;
    versionCell.accessView.hidden = YES;
    versionCell.versionLbl.text = @"2.2.0";
    versionCell.versionLbl.font = Font14;
    CGFloat versionX = 0;
    CGFloat versionY = CGRectGetMaxY(AppStoreCell.frame);
    CGFloat versionW = WIDTH;
    CGFloat versionH = appH;
    versionCell.frame = CGRectMake(versionX, versionY, versionW, versionH);
    versionCell.btn.tag = 3;
    [versionCell.btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:versionCell];
    
    // 退出按钮
    UIButton * outBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnX = Margin40 * IPHONE6_W_SCALE;
    CGFloat btnY = CGRectGetMaxY(versionCell.frame) + Margin70 * IPHONE6_H_SCALE;
    CGFloat btnW = WIDTH - 2 * btnX;
    CGFloat btnH = Margin100 * IPHONE6_H_SCALE;
    outBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    //    [outBtn setImage:[UIImage imageNamed:@"tuichudenglu"] forState:UIControlStateNormal];
    //    [outBtn setBackgroundImage:[UIImage imageNamed:@"tuichudenglu"] forState:UIControlStateNormal];
    [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    outBtn.layer.masksToBounds = YES;
    outBtn.layer.cornerRadius = 4;
    outBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    outBtn.backgroundColor = RGBA(225, 10, 24, 1);
    [outBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    outBtn.titleLabel.font = Font17;
    [outBtn addTarget:self action:@selector(outLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outBtn];
    outBtn.hidden = YES;
    
    _outBtn = outBtn;
}

#pragma mark --- 退出的点击事件
- (void)outLogin{
    
    [self deleteCookie];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark --- 删除cookie
- (void)deleteCookie
{
    NSLog(@"============删除cookie===============");
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    //删除cookie
    for (NSHTTPCookie *tempCookie in cookies) {
        [cookieStorage deleteCookie:tempCookie];
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    // 删除别名
    NSDictionary * xcDic =  [defaults objectForKey:WXUser];
    NSString * userid1 = xcDic[@"userid"];
    NSDictionary * phoneDic = [defaults objectForKey:User];
    NSString * userid2 = phoneDic[@"userid"];

//    [UMessage removeAlias:userid1 type:@"ALIAS_TYPE.DIPAI" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//        NSLog(@"删除userid1成功:%@", responseObject);
//        NSLog(@"删除userid1失败:%@", responseObject);
//    }];
//    [UMessage removeAlias:userid2 type:@"ALIAS_TYPE.DIPAI" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//        NSLog(@"删除userid2成功:%@", responseObject);
//        NSLog(@"删除userid1失败:%@", responseObject);
//    }];
    
    [defaults removeObjectForKey:Cookie];
    [defaults removeObjectForKey:Phone];
    [defaults removeObjectForKey:User];
    [defaults removeObjectForKey:WXUser];
    [SVProgressHUD showSuccessWithStatus:@"退出成功"];
}

#pragma mark --- 按钮点击事件
- (void)clickAction:(UIButton *)btn{
    AbountDiPai * abountDP = [[AbountDiPai alloc] init];
    switch (btn.tag) {
            
        case 1:
            NSLog(@"关于底牌....");
            [self.navigationController pushViewController:abountDP animated:YES];
            break;
        case 2:
            NSLog(@"去评分....");
            // https://itunes.apple.com/cn/app/di-pai/id1000553183?mt=8
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1000553183&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
            break;
        case 3:
            NSLog(@"当前版本....");
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
