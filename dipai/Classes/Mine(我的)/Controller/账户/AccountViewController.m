//
//  AccountViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/31.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AccountViewController.h"
// 自定义单元格
#import "CustomTableViewCell.h"
#import "SVProgressHUD.h"
@interface AccountViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation AccountViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    
    [self setNavigationBar];
    
    [self createUI];
}

#pragma mark --- 设置导航条
- (void)setNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
    
    // 左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui"] target:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:38/2];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"帐号管理";
    self.navigationItem.titleView = titleLabel;
}
#pragma mark --- 返回
- (void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 搭建UI
- (void)createUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 110*4/2*IPHONE6_H_SCALE) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.tableView];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 28 / 2 * IPHONE6_H_SCALE)];
    headerView.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    
    self.tableView.tableHeaderView = headerView;
    
    NSArray * array = @[@"头像", @"昵称", @"修改密码", @"绑定手机"];
    self.dataSource = [NSMutableArray arrayWithArray:array];
    
    UIButton * outBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnX = Margin40 * IPHONE6_W_SCALE;
    CGFloat btnY = CGRectGetMaxY(self.tableView.frame) + Margin70 * IPHONE6_H_SCALE;
    CGFloat btnW = WIDTH - 2 * btnX;
    CGFloat btnH = Margin100 * IPHONE6_H_SCALE;
    outBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [outBtn setImage:[UIImage imageNamed:@"tuichudenglu"] forState:UIControlStateNormal];
    [outBtn addTarget:self action:@selector(outLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outBtn];
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
    [defaults removeObjectForKey:Cookie];
    [SVProgressHUD showSuccessWithStatus:@"退出成功"];
}

#pragma mark --- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellID";
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLbl.text = self.dataSource[indexPath.row];
    if (indexPath.row != 1) {
        cell.nameLbl.hidden = YES;
    } else{
        cell.nameLbl.text = @"网络昵称";
    }
    
    if (indexPath.row != 0) {
        cell.picView.hidden = YES;
    } else{
        // 网络头像
        cell.picView.image = [UIImage imageNamed:@"touxiang_moren"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 111 / 2 * IPHONE6_H_SCALE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
