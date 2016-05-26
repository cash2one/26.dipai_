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
// 登录界面
#import "LoginViewController.h"
@interface MineController ()<UITableViewDataSource, UITableViewDelegate>

/**
 *  表格
 */
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation MineController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_beijingditu"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.title = @"";
    // 设置导航栏上按钮
    [self setUpNavigationBarItem];
    
    [self createUI];
    
    // 添加HeaderView
    [self addHeaderView];
}

#pragma mark ---设置导航栏上按钮
- (void)setUpNavigationBarItem{
//    UIView * blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
//    [self.view addSubview:blackView];
//    blackView.backgroundColor = [UIColor blackColor];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"shezhi"] target:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --- 添加表格
- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 49) style:UITableViewStylePlain];
    //    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    NSLog(@"表格的高度：%f", self.tableView.frame.size.height);
    [self.view addSubview:self.tableView];
    
}
#pragma mark --- 添加HeaderView
- (void)addHeaderView{
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
    // 登录状态的label
    UILabel * loginLbl = [[UILabel alloc] init];
    loginLbl.textColor = Color178;
    loginLbl.font = [UIFont systemFontOfSize:17];
    loginLbl.textAlignment = NSTextAlignmentCenter;
    loginLbl.text = @"点击登录";
    CGFloat lblX = Margin306 * IPHONE6_W_SCALE;
    CGFloat lblY = CGRectGetMaxY(iconBtn.frame) + 5*IPHONE6_H_SCALE;
    CGFloat lblW = WIDTH - 2 * lblX;
    CGFloat lblH = 17;
    loginLbl.frame = CGRectMake(lblX, lblY, lblW, lblH);
    [loginLbl sizeToFit];
    [headerView addSubview:loginLbl];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark --- 跳转到设置页面 
- (void)settings
{
    NSLog(@"设置。。。");
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

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewController * myCollection = [[MyCollectionViewController alloc] init];
    myCollection.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myCollection animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
