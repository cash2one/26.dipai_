//
//  PokerVC.m
//  dipai
//
//  Created by 梁森 on 16/6/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "PokerVC.h"
// 名人单元格
#import "PokerCell.h"

#import "DataTool.h"
#import "PokerListModel.h"
// 扑克名人堂列表
#import "MorePokersVC.h"

// 名人页面
#import "StarVC.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

#import "Masonry.h"
#import "SVProgressHUD.h"

@interface PokerVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView * starView;
/**
 *  表格
 */
@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation PokerVC
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
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
    
    [self getData];
}
/******************************搭建界面*************************/
#pragma mark --- 设置导航栏
- (void)setUpNavigationBar
{
    // 头视图
    UIImageView * topView = [[UIImageView alloc] init];
    [self.view addSubview:topView];
    topView.image = [UIImage imageNamed:@"mingrentang_beijing"];
    topView.frame = CGRectMake(0, 0, WIDTH, 250 * IPHONE6_H_SCALE);
    
    // 分割线
    UIView * separateView = [[UIView alloc] init];
    [self.view addSubview:separateView];
    CGFloat separateY = CGRectGetMaxY(topView.frame);
    separateView.frame = CGRectMake(0, separateY, WIDTH, 20 * IPHONE6_H_SCALE);
    separateView.backgroundColor = SeparateColor;
    
    // 明星推荐
    UIView * starView = [[UIView alloc] init];
    starView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:starView];
    CGFloat starViewY = CGRectGetMaxY(separateView.frame);
    starView.frame = CGRectMake(0, starViewY, WIDTH, 83 * 0.5 * IPHONE6_H_SCALE);
    _starView = starView;
    // 标签
    UILabel * starLbl = [[UILabel alloc] init];
    starLbl.font = Font16;
    starLbl.text = @"明星推荐";
    [starView addSubview:starLbl];
    starLbl.frame = CGRectMake(Margin30 * IPHONE6_W_SCALE, 0, WIDTH, 83 * 0.5 * IPHONE6_H_SCALE);
    
    UIImageView * popView = [[UIImageView alloc] init];
    [self.view addSubview:popView];
    popView.frame = CGRectMake(15, 30, 10 * IPHONE6_W_SCALE, 19 * IPHONE6_W_SCALE);
    popView.image = [UIImage imageNamed:@"houtui_baise"];
    
    UIButton * popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:popBtn];
    popBtn.frame = CGRectMake(0, 20, 50, 44);
    popBtn.backgroundColor =[UIColor clearColor];
    [popBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加表格
    [self addTableView];
    [self addRefreshing];
}
#pragma mark --- 返回上一个视图控制器
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 添加下拉刷新和上拉加载
- (void)addRefreshing{
    // 添加下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏状态
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 设置header
    self.tableView.header = header;
    // 马上进入刷新状态
    [header beginRefreshing];
    
    
    //往上拉加载数据.
//    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    // 设置文字
//    //加载更多
//    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
//    //没有更多数据
//    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
//    // 设置footer
//    self.tableView.footer = footer;
}

- (void)loadNewData{
    [DataTool getPokerListDataWithStr:PokerListURL parameters:nil success:^(id responseObject) {
        [self.tableView.header endRefreshing];
        NSLog(@"获取扑克名人堂首页数据：%@", responseObject);
        if ([responseObject isKindOfClass:[NSString class]]) {
            
            NSLog(@"扑克名人堂没有数据...");
            [SVProgressHUD showErrorWithStatus:@"暂时没有数据"];
        }else{
            NSLog(@"扑克名人堂有数据...");
            self.dataSource = responseObject;
            [self.tableView reloadData];
        }
        
    } failure:^(NSError * error) {
        NSLog(@"获取扑克名人堂首页出错：%@", error);
    }];
}

#pragma mark --- 添加表格
- (void)addTableView{
    CGFloat y = CGRectGetMaxY(_starView.frame);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0 , y , WIDTH , HEIGHT - y) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    UIView * footerView = [[UIView alloc] init];
//    footerView.backgroundColor = [UIColor redColor];
    footerView.frame = CGRectMake(0, 0, WIDTH, 53 * IPHONE6_H_SCALE);
    self.tableView.tableFooterView = footerView;
    
    
    UILabel * checkLbl = [[UILabel alloc] init];
//    checkLbl.backgroundColor = [UIColor redColor];
    checkLbl.text = @"查看全部";
    checkLbl.font = Font13;
    checkLbl.textColor = [UIColor colorWithRed:95 / 255.f green:95 / 255.f blue:95 / 255.f alpha:1];
    [footerView addSubview:checkLbl];
    [checkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView.mas_centerX);
        make.centerY.equalTo(footerView.mas_centerY);
        make.height.equalTo(@(13 * IPHONE6_H_SCALE));
        make.width.equalTo(@(53*IPHONE6_W_SCALE));
    }];
    UIImageView * nextView = [[UIImageView alloc] init];
    [footerView addSubview:nextView];
    nextView.image = [UIImage imageNamed:@"chakanquanbu"];
    [nextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkLbl.mas_right).offset(7 * IPHONE6_W_SCALE);
        make.centerY.equalTo(footerView.mas_centerY);
        make.width.equalTo(@(6 * IPHONE6_W_SCALE));
        make.height.equalTo(@(11 * IPHONE6_W_SCALE));
    }];
    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkLbl.mas_left);
        make.right.equalTo(nextView.mas_right);
        make.top.equalTo(footerView.mas_top).offset(10 * IPHONE6_H_SCALE);
        make.bottom.equalTo(footerView.mas_bottom).offset(-10* IPHONE6_H_SCALE);
    }];
    [nextBtn addTarget:self action:@selector(checkMore) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark --- checkMore查看更多的点击事件
- (void)checkMore{
    MorePokersVC * pokersVC = [[MorePokersVC alloc] init];
    pokersVC.wapurl = MorePokersURL;
    
    NSLog(@"%@", pokersVC.wapurl);
    
    [self.navigationController pushViewController:pokersVC animated:YES];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    NSLog(@"--%@", self.dataSource);
    if (self.dataSource.count > 0) {
        return self.dataSource.count;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PokerCell * cell = [PokerCell cellWithTableView:tableView];
    if (self.dataSource.count > 0) {
        PokerListModel * model = self.dataSource[indexPath.row];
        cell.pokerModel = model;
    }
    
    return cell;
}
#pragma mark --- 单元格的高度 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 129 * IPHONE6_H_SCALE;
}

#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PokerListModel * model = self.dataSource[indexPath.row];
    
    StarVC * starVC = [[StarVC alloc] init];
    starVC.userURL = model.userurl;
    [self.navigationController pushViewController:starVC animated:YES];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    NSLog(@"%lu", indexPath.row);
//    if (indexPath.row == [self.dataSource count]-1) {
//        
//        // 表格的脚视图
//        UIView * footerView = [[UIView alloc] init];
//        footerView.backgroundColor = [UIColor redColor];
//        footerView.frame = CGRectMake(0, 0, WIDTH, 53 * IPHONE6_H_SCALE);
//        self.tableView.tableFooterView = footerView;
//        
//        
//        UILabel * checkLbl = [[UILabel alloc] init];
//        checkLbl.backgroundColor = [UIColor redColor];
//        checkLbl.text = @"查看全部";
//        checkLbl.font = Font13;
//        checkLbl.textColor = [UIColor colorWithRed:95 / 255.f green:95 / 255.f blue:95 / 255.f alpha:1];
//        [footerView addSubview:checkLbl];
//        [checkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(footerView.mas_centerX);
//            make.centerY.equalTo(footerView.mas_centerY);
//            make.height.equalTo(@(13 * IPHONE6_H_SCALE));
//            make.width.equalTo(@(53*IPHONE6_W_SCALE));
//        }];
//        
//            
//        }else{
//            self.tableView.tableFooterView = nil;
//            
//        }
//        
//        
//    
//}
/*************************数据请求*********************/
- (void)getData{
    
//    [DataTool getPokerListDataWithStr:PokerListURL parameters:nil success:^(id responseObject) {
//        
//        NSLog(@"获取扑克名人堂首页数据：%@", responseObject);
////        NSMutableArray * dataArr = [NSMutableArray array];
////        [dataArr addObjectsFromArray:responseObject];
////        [dataArr addObjectsFromArray:responseObject];
////        [dataArr addObjectsFromArray:responseObject];
//        self.dataSource = responseObject;
//        [self.tableView reloadData];
//    } failure:^(NSError * error) {
//        NSLog(@"获取扑克名人堂首页出错：%@", error);
//    }];
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
