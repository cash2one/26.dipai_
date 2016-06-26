//
//  MineController.m
//  dipai
//
//  Created by 梁森 on 16/4/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MineController.h"
// 我的收藏
#import "MyCollectionViewController.h"
// 我的帖子
#import "MyPostsViewController.h"
// 我收到的评论
#import "MyReceiveCommentsViewController.h"
// 登录界面
#import "LoginViewController.h"
// 设置页面
#import "SettingViewController.h"
// 账户页面
#import "AccountViewController.h"


#import "ClickView.h"

#import "DataTool.h"
// 自定义alertView
#import "LSAlertView.h"
#import "BackgroundView.h"

#import "Masonry.h"
// 用户模型
#import "UserModel.h"

@interface MineController ()<LSAlertViewDeleagte>
{
    NSArray *_cookies;
    NSString * _name;
    UIView * _alertBackView;
    LSAlertView * _alertView;
}
/**
 *  表格
 */
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UILabel * loginLbl;
/**
 *  竖线
 */
@property (nonatomic, strong) UIView * line;
/**
 *  被关注标签
 */
@property (nonatomic, strong) UILabel * fansLbl;
/**
 *  被关注数标签
 */
@property (nonatomic, strong) UILabel * fansNum;
/**
 *  关注标签
 */
@property (nonatomic, strong) UILabel * attention;
/**
 *  关注数标签
 */
@property (nonatomic, strong) UILabel * attentionNum;
/**
 *  查看账户按钮
 */
@property (nonatomic, strong) UIButton * picBtn;
@end

@implementation MineController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1]];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_beijingditu"] forBarMetrics:UIBarMetricsDefault];
    
    // 每次出现的时候都要重新获取数据
    [self getData];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.title = @"";
    
    // 设置导航栏上按钮
    [self setUpNavigationBarItem];
    
}

#pragma mark --- 获取数据
- (void)getData{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * name = [defaults objectForKey:Cookie];
    NSDictionary * dataDic = [defaults objectForKey:User];
    // 字典转模型
    UserModel * userModel = [UserModel objectWithKeyValues:dataDic];
    _name = name;
    if (name) {
        NSLog(@"已登录");
        _loginLbl.text = userModel.username;
        [_loginLbl sizeToFit];
        _loginLbl.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
        _line.hidden = NO;
        _fansNum.hidden = NO;
        _fansLbl.hidden = NO;
        _attentionNum.hidden = NO;
        _attention.hidden = NO;
        _picBtn.hidden = NO;
        _fansNum.text = userModel.count_follow; // 关注数
        _attentionNum.text = userModel.count_followed;  // 粉丝数
    } else{
        NSLog(@"没有登录");
        _line.hidden = YES;
        _fansNum.hidden = YES;
        _fansLbl.hidden = YES;
        _attentionNum.hidden = YES;
        _attention.hidden = YES;
        _loginLbl.text = @"点击登录";
        _loginLbl.textColor = Color178;
        _picBtn.hidden = YES;
    }
}

#pragma mark ---设置导航栏上按钮
- (void)setUpNavigationBarItem{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self createUI];
}
#pragma mark ---创建界面
- (void)createUI{
    CGFloat headerX = 0;
    CGFloat headerY = 0;
    CGFloat headerW = WIDTH;
    CGFloat headerH = Margin430;
    UIImageView * headerView = [[UIImageView alloc] initWithFrame:CGRectMake(headerX, headerY, headerW, headerH)];
    headerView.image = [UIImage imageNamed:@"weidenglu_beijing"];
    
    // 设置按钮
    UIButton * settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnX = WIDTH - 15 - 21;
    CGFloat btnY = (40 + 23) / 2;
    CGFloat btnW = 21;
    CGFloat btnH = 21;
    settingBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [settingBtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
    headerView.userInteractionEnabled = YES;
    [headerView addSubview:settingBtn];
    
    // 登录头像
    UIButton * iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconBtn setImage:[UIImage imageNamed:@"touxiang_moren"] forState:UIControlStateNormal];
    iconBtn.center = CGPointMake(self.view.center.x, (128 + 78)/2);
    iconBtn.bounds = CGRectMake(0, 0, Margin156 * IPHONE6_W_SCALE, Margin156 * IPHONE6_W_SCALE);
    [iconBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:iconBtn];
    // 登录后的头像
    UIButton * picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    picBtn.frame = iconBtn.frame;
    picBtn.layer.masksToBounds = YES;
    picBtn.layer.cornerRadius = picBtn.frame.size.width / 2;
    picBtn.layer.borderWidth = 2 * IPHONE6_W_SCALE;
    picBtn.layer.borderColor = [[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.5] CGColor];
    picBtn.backgroundColor = [UIColor lightGrayColor];
    [picBtn addTarget:self action:@selector(CheckAccount) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:picBtn];
    _picBtn = picBtn;
    
    
    
    [self.view addSubview:headerView];
    // 登录状态的label
    UILabel * loginLbl = [[UILabel alloc] init];
//    loginLbl.backgroundColor = [UIColor redColor];
    [headerView addSubview:loginLbl];
    loginLbl.textColor = Color178;
    loginLbl.font = [UIFont systemFontOfSize:17];
    loginLbl.textAlignment = NSTextAlignmentCenter;
    //    CGFloat lblX = Margin306 * IPHONE6_W_SCALE;
    //    CGFloat lblY = CGRectGetMaxY(iconBtn.frame) + 5*IPHONE6_H_SCALE;
    //    CGFloat lblW = WIDTH - 2 * lblX;
    //    CGFloat lblH = 17;
    [loginLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(iconBtn.mas_bottom).offset(5*IPHONE6_H_SCALE);
        make.width.equalTo(@(100));
        make.height.equalTo(@(18));
    }];
    loginLbl.text = @"点击登录";
    //    [loginLbl sizeToFit];
    
    _loginLbl = loginLbl;
    
    // 竖线
    UIView * line = [[UIView alloc] init];
    [headerView addSubview:line];
    line.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
    //    CGFloat lineX = WIDTH / 2 - 0.25;
    //    CGFloat lineY = CGRectGetMaxY(loginLbl.frame) + 25 / 2 * IPHONE6_H_SCALE;
    //    CGFloat lineW = 0.5;
    //    CGFloat lineH = 14 * IPHONE6_H_SCALE;
    //    line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(loginLbl.mas_bottom).offset(25 * 0.5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(0.5));
        make.height.equalTo(@(14*IPHONE6_H_SCALE));
    }];
    _line = line;
    
    
    // 被关注
    UILabel * fansLbl = [[UILabel alloc] init];
    [headerView addSubview:fansLbl];
    fansLbl.text = @"被关注";
    fansLbl.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
    fansLbl.font = Font13;
    //    CGFloat fansX = CGRectGetMaxX(line.frame) + 28 / 2 * IPHONE6_W_SCALE;
    //    CGFloat fansY = CGRectGetMaxY(loginLbl.frame) + 23 / 2 * IPHONE6_H_SCALE;
    //    NSMutableDictionary * fansDic = [NSMutableDictionary dictionary];
    //    fansDic[NSFontAttributeName] = Font13;
    //    CGSize fansSize = [fansLbl.text sizeWithAttributes:fansDic];
    //    fansLbl.frame = (CGRect){{fansX, fansY}, fansSize};
    [fansLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(14 * IPHONE6_W_SCALE);
        make.top.equalTo(loginLbl.mas_bottom).offset(23*0.5*IPHONE6_H_SCALE);
        make.width.equalTo(@40);
        make.height.equalTo(@13);
    }];
    [fansLbl sizeToFit];
    _fansLbl = fansLbl;
    // 被关注数
    UILabel * fansNum = [[UILabel alloc] init];
    [headerView addSubview:fansNum];
    fansNum.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
    fansNum.text = @"11";
    fansNum.font = Font13;
    //    CGFloat fansNumX = CGRectGetMaxX(fansLbl.frame) + 18 / 2 * IPHONE6_W_SCALE;
    //    CGFloat fansNumY = fansY;
    //    NSMutableDictionary * fansNumDic = [NSMutableDictionary dictionary];
    //    fansNumDic[NSFontAttributeName] = Font13;
    //    CGSize fansNumSize = [fansNum.text sizeWithAttributes:fansNumDic];
    //    fansNum.frame = (CGRect){{fansNumX, fansNumY}, fansNumSize};
    [fansNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fansLbl.mas_right).offset(9 * IPHONE6_W_SCALE);
        make.top.equalTo(fansLbl.mas_top);
        make.width.equalTo(@40);
        make.height.equalTo(@13);
    }];
    _fansNum = fansNum;
    
    UILabel * attention = [[UILabel alloc] init];
    attention.font = Font13;
    //    attention.backgroundColor = [UIColor redColor];
    attention.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
    attention.text = @"关注";
    [headerView addSubview:attention];
    _attention = attention;
    
    // 关注数
    UILabel * attentionNum = [[UILabel alloc] init];
    //    attentionNum.backgroundColor = [UIColor redColor];
    attentionNum.font = Font13;
    attentionNum.text = @"10";
    attentionNum.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
    [headerView addSubview:attentionNum];
    _attentionNum = attentionNum;
    [attentionNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(line.mas_left).offset(-28 / 2 * IPHONE6_W_SCALE);
        make.top.equalTo(loginLbl.mas_bottom).offset(26 / 2 * IPHONE6_H_SCALE);
        make.left.equalTo(attention.mas_right).offset(18 / 2 * IPHONE6_W_SCALE);
        make.height.equalTo(@(26 / 2 * IPHONE6_H_SCALE));
    }];
    // 关注
    [attention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(52 / 2 * IPHONE6_W_SCALE));
        make.height.equalTo(@(26 / 2 * IPHONE6_H_SCALE));
        make.top.equalTo(attentionNum.mas_top);
    }];
    
    // 分隔条
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    CGFloat separateX = 0;
    CGFloat separateY = CGRectGetMaxY(headerView.frame);
    CGFloat separateW = WIDTH;
    CGFloat sepatateH = 40 / 2 * IPHONE6_H_SCALE;
    separateView.frame = CGRectMake(separateX, separateY, separateW, sepatateH);
    [self.view addSubview:separateView];
    
    // 收藏
    ClickView * collectionView = [[ClickView alloc] init];
    collectionView.commentNum.hidden = YES;
    // 设置图片
    collectionView.picName = @"shoucang_moren";
    collectionView.message = @"我的收藏";
    [collectionView.btn addTarget:self action:@selector(turePageToCollection) forControlEvents:UIControlEventTouchUpInside];
    collectionView.btn.tag = 1;
    CGFloat collectX = 0;
    CGFloat collectY = CGRectGetMaxY(separateView.frame);
    CGFloat collectW = WIDTH;
    CGFloat collectH = 98 / 2 * IPHONE6_H_SCALE;
    collectionView.frame = CGRectMake(collectX, collectY, collectW, collectH);
    [self.view addSubview:collectionView];
//    // 帖子
    ClickView * postView = [[ClickView alloc] init];
    postView.commentNum.hidden = YES;
    postView.picName = @"wodetiezi";
    postView.message = @"我的帖子";
    [postView.btn addTarget:self action:@selector(turePageToPosts) forControlEvents:UIControlEventTouchUpInside];
    CGFloat postX = collectX;
    CGFloat postY = CGRectGetMaxY(collectionView.frame);
    CGFloat postW = collectW;
    CGFloat postH = collectH;
    postView.frame = CGRectMake(postX, postY, postW, postH);
    [self.view addSubview:postView];
    
    // 收到的评论
    ClickView * commentsView = [[ClickView alloc] init];
    commentsView.commentNum.text = @"11";
    commentsView.picName = @"woshoudaodepinglun";
    commentsView.message = @"我收到的评论";
    [commentsView.btn addTarget:self action:@selector(turePageToComments) forControlEvents:UIControlEventTouchUpInside];
    CGFloat commentsX = postX;
    CGFloat commentsY = CGRectGetMaxY(postView.frame);
    CGFloat commentsW = postW;
    CGFloat commentsH = postH;
    commentsView.frame = CGRectMake(commentsX, commentsY, commentsW, commentsH);
    [self.view addSubview:commentsView];
}

#pragma mark --- 查看账户
- (void)CheckAccount{
    AccountViewController * accountVC = [[AccountViewController alloc] init];
    accountVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:accountVC animated:YES];
}

#pragma mark --- 按钮的点击事件
// 跳转到收藏页
- (void)turePageToCollection{
    if (_name) {
        MyCollectionViewController * myCollectionVC = [[MyCollectionViewController alloc] init];
        myCollectionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myCollectionVC animated:YES];
    }else{
        [self addLSAlertView];
    }
    
}
// 跳转到帖子页
- (void)turePageToPosts{
    if (_name) {
        MyPostsViewController * myPostsVC = [[MyPostsViewController alloc] init];
        myPostsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myPostsVC animated:YES];
    }else{
        [self addLSAlertView];
    }
    
}
// 跳转到收到的评论页
- (void)turePageToComments{
    if (_name) {
        MyReceiveCommentsViewController * myReceiveCommentsVC = [[MyReceiveCommentsViewController alloc] init];
        myReceiveCommentsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myReceiveCommentsVC animated:YES];
    }else{
        [self addLSAlertView];
    }
    
}

- (void)addLSAlertView{
    LSAlertView * alertView = [[LSAlertView alloc] init];
    alertView.delegate = self;
    CGFloat x = Margin105 * IPHONE6_W_SCALE;
    CGFloat y = Margin574 * IPHONE6_H_SCALE;
    CGFloat w = Margin540 * IPHONE6_W_SCALE;
    CGFloat h = Margin208 * IPHONE6_H_SCALE;
    alertView.frame = CGRectMake(x, y, w, h);
    UIView * alertBackView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    alertBackView.backgroundColor = ColorBlack30;
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加到灰色的背景图
    [window addSubview:alertBackView];
    [window addSubview:alertView];
    
    _alertBackView = alertBackView;
    _alertView = alertView;
}

#pragma mark ---- LSAlertViewDeleagte
- (void)lsAlertView:(LSAlertView *)alertView cancel:(NSString * )cancel{
    [self removeAlerView];
}
- (void)lsAlertView:(LSAlertView *)alertView sure:(NSString *)sure{
    [self removeAlerView];
}

- (void)removeAlerView
{
    // 移除提示框的背景图
    [_alertBackView removeFromSuperview];
    // 移除提示框
    [_alertView removeFromSuperview];
}

#pragma mark --- 跳转到设置页面 
- (void)settings
{
    SettingViewController * settingVC = [[SettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark --- 登录事件
- (void)loginAction{
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
