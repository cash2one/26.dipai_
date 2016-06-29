//
//  StarVC.m
//  dipai
//
//  Created by 梁森 on 16/6/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "StarVC.h"

#import "Masonry.h"
@interface StarVC ()

/**
 *  名人头像
 */
@property (nonatomic, strong) UIImageView * faceView;
/**
 *  关注按钮
 */
@property (nonatomic, strong) UIButton * attentionBtn;
/**
 *  姓名
 */
@property (nonatomic, strong) UILabel * nameLbl;
/**
 *  关注数
 */
@property (nonatomic, strong) UILabel * attentionLbl;
/**
 *  粉丝数
 */
@property (nonatomic, strong) UILabel * fansLbl;
/**
 *  底牌认证
 */
@property (nonatomic, strong) UILabel * certificateLbl;
@end

@implementation StarVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
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
    // 设置导航栏
    [self setUpNavigationBar];
    
    NSLog(@"%@", self.userURL);
}

#pragma mark --- 设置导航栏
- (void)setUpNavigationBar
{
    // 头视图
    UIImageView * topView = [[UIImageView alloc] init];
    [self.view addSubview:topView];
    topView.image = [UIImage imageNamed:@"mingrenzhuye_beijing"];
    topView.frame = CGRectMake(0, 0, WIDTH, 226 * IPHONE6_H_SCALE);

    // 返回按钮
    UIImageView * popView = [[UIImageView alloc] init];
    [self.view addSubview:popView];
    popView.frame = CGRectMake(15, 30, 10 * IPHONE6_W_SCALE, 19 * IPHONE6_W_SCALE);
    popView.image = [UIImage imageNamed:@"houtui_baise"];
    
    UIButton * popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:popBtn];
    popBtn.frame = CGRectMake(0, 20, 50, 44);
    popBtn.backgroundColor =[UIColor clearColor];
    [popBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    // 头像
    UIImageView * faceView = [[UIImageView alloc] init];
    faceView.layer.masksToBounds = YES;
    [topView addSubview:faceView];
    [faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(topView.mas_top).offset(64 * IPHONE6_H_SCALE);
        make.width.equalTo(@(78 * IPHONE6_W_SCALE));
        make.height.equalTo(@(78 * IPHONE6_W_SCALE));
    }];
    faceView.layer.cornerRadius = 78 * 0.5 * IPHONE6_W_SCALE;
    faceView.layer.borderWidth = 2;
    faceView.layer.borderColor = [[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.5] CGColor];
    _faceView = faceView;
    
    // 关注按钮
    UIButton * attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
#warning 修改
    [attentionBtn setImage:[UIImage imageNamed:@"jiaguangzhu"] forState:UIControlStateNormal];
    [topView addSubview:attentionBtn];
    [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(64 * IPHONE6_H_SCALE);
        make.right.equalTo(topView.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.width.equalTo(@(61*IPHONE6_W_SCALE));
        make.height.equalTo(@(22 * IPHONE6_W_SCALE));
    }];
    
    // 姓名
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.textAlignment = NSTextAlignmentCenter;
    nameLbl.font = Font17;
    nameLbl.textColor = [UIColor whiteColor];
#warning 可变内容
    nameLbl.text = @"阿福空间啊啦放假啦";
    [topView addSubview:nameLbl];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(faceView.mas_bottom).offset(5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(17*IPHONE6_W_SCALE));
    }];
    _nameLbl = nameLbl;
    
    // 分割线竖线
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:separateView];
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(nameLbl.mas_bottom).offset(12.5*IPHONE6_H_SCALE);
        make.width.equalTo(@(0.5));
        make.height.equalTo(@(15));
    }];
    
    // 关注数
    UILabel * attentionLbl = [[UILabel alloc] init];
    attentionLbl.textAlignment = NSTextAlignmentRight;
#warning 可变
    attentionLbl.text = @"关注 10";
    attentionLbl.textColor = [UIColor whiteColor];
    attentionLbl.font = Font13;
    [topView addSubview:attentionLbl];
    [attentionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(separateView.mas_left).offset(-14 * IPHONE6_W_SCALE);
        make.top.equalTo(nameLbl.mas_bottom).offset(13 * IPHONE6_H_SCALE);
        make.left.equalTo(topView.mas_left);
        make.height.equalTo(@(13*IPHONE6_W_SCALE));
    }];
    _attentionLbl = attentionLbl;
    // 粉丝数
    UILabel * fansLbl = [[UILabel alloc] init];
    fansLbl.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:fansLbl];
    fansLbl.text = @"被关注 10";
    fansLbl.textColor = [UIColor whiteColor];
    fansLbl.font = Font13;
    [fansLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(separateView.mas_right).offset(14 * IPHONE6_W_SCALE);
        make.top.equalTo(nameLbl.mas_bottom).offset(13 * IPHONE6_H_SCALE);
        make.right.equalTo(topView.mas_right);
        make.height.equalTo(@(13 * IPHONE6_W_SCALE));
    }];
    _fansLbl = fansLbl;
    
    // 底牌认证
    UILabel * certificateLbl = [[UILabel alloc] init];
    certificateLbl.font = Font12;
    certificateLbl.textAlignment = NSTextAlignmentCenter;
    certificateLbl.text = @"底牌认证";
    certificateLbl.textColor = [UIColor whiteColor];
    [topView addSubview:certificateLbl];
    _certificateLbl = certificateLbl;
    [certificateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(separateView.mas_bottom).offset(7 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(12 * IPHONE6_W_SCALE));
    }];
    
}
#pragma mark --- 返回上一个视图控制器
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置状态栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
