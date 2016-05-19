//
//  InfomationViewController.m
//  dipai
//
//  Created by 梁森 on 16/4/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "InfomationViewController.h"
// 导航栏上左右侧按钮的分类
#import "UIBarButtonItem+Item.h"
// 测试的控制器
#import "TestViewController.h"
// 轮播页（广告页）
#import "AdvertisementView.h"
// 详情页网页
#import "DetailWebViewController.h"
// 单元格
#import "tournamentCell.h"
#import "InformationCell.h"
#import "PicturesCell.h"
#import "VideoCell.h"


// 刷新第三方
#import "MJRefresh.h"
// 数据层
#import "DataTool.h"
// 首页上传参数模型
#import "InfoPara.h"
// 转模型第三方
#import "MJExtension.h"
#import "AFNetworking.h"
// 列表模型
#import "NewsListModel.h"
// 刷新
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"
@interface InfomationViewController ()<UIScrollViewDelegate ,UITableViewDataSource, UITableViewDelegate, AdvertisementViewDelegate>
/**
 *  表格
 */
@property (nonatomic, strong) UITableView * tableView;
/**
 *  表格文章数据源
 */
@property (nonatomic, strong) NSMutableArray * newslistArr;
/**
 *  用来装轮播页模型
 */
@property (nonatomic, strong) NSMutableArray * bannerArr;
/**
 *  赛事数据源
 */
@property (nonatomic, strong) NSMutableArray * tournamentArr;
@end

@implementation InfomationViewController

- (NSMutableArray *)newslistArr
{
    if (_newslistArr == nil) {
        _newslistArr = [NSMutableArray array];
    }
    return _newslistArr;
}

- (NSMutableArray *)bannerArr
{
    if (_bannerArr == nil) {
        _bannerArr = [NSMutableArray array];
    }
    
    return _bannerArr;
}

- (NSMutableArray *)tournamentArr
{
    if (_tournamentArr == nil) {
        _tournamentArr = [NSMutableArray array];
    }
    return _tournamentArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 搭建UI
    [self createUI];
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
    
    // 添加上拉加载控件
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置文字
    //加载更多
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    //没有更多数据
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    // 设置footer
    self.tableView.footer = footer;
}
#pragma mark ------ 下拉刷新，加载新的数据
- (void)loadNewData
{
    [DataTool getNewDataWithStr:InformationURL parameters:nil success:^(NSArray * arr) {
        [self.tableView.header endRefreshing];
        NSArray * bannerModelArr = [arr objectAtIndex:0];
        NSArray * tournamentModelArr = [arr objectAtIndex:1];
        NSArray * listModelArr = [arr objectAtIndex:2];
        // 轮播页的数组
        [self.bannerArr removeAllObjects];
        [self.bannerArr addObjectsFromArray:bannerModelArr];
        // 赛事页的数组
        [self.tournamentArr removeAllObjects];
        [self.tournamentArr addObjectsFromArray:tournamentModelArr];
        // 表格的数组
        [self.newslistArr removeAllObjects];
        [self.newslistArr addObjectsFromArray:listModelArr];
        // 添加轮播页
        [self addBannerView];
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
         NSLog(@"错误信息%@", error);
    }];

}
#pragma mark --- 添加轮播页
- (void)addBannerView
{
    
    // 添加轮播页
    AdvertisementView * advertiseView = [[AdvertisementView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HeaderViewHeight * IPHONE6_H_SCALE)];
    //    advertiseView.backgroundColor = [UIColor redColor];
    advertiseView.delegate = self;
    // 确定滚动视图的contentSize
    NSUInteger count = self.bannerArr.count;
    NSNumber * num = [NSNumber numberWithUnsignedInteger:count];
    int counts = [num intValue];
    [advertiseView setScrollWithCount:counts andArray:self.bannerArr];
    // 设置轮播页上的数据
    self.tableView.tableHeaderView = advertiseView;
}

#pragma mark --- 添加表格
- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 49 - 64) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    NSLog(@"表格的高度：%f", self.tableView.frame.size.height);
    [self.view addSubview:self.tableView];
    
}
#pragma mark --- 跳转页面的点击事件
- (void)Click
{
//    NSLog(@"跳转。。。");
    TestViewController * testVC = [[TestViewController alloc] init];
    testVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:testVC animated:YES];
}

#pragma mark --------- 上拉加载数据
- (void)loadMoreData
{
    NewsListModel * model = [self.newslistArr lastObject];
    NSString * replaceStr = [NSString stringWithFormat:@"index/%@", model.iD];
    // http://192.168.1.102:8080/app/index/0/0/0
    NSString * urlStr = [InformationURL stringByReplacingOccurrencesOfString:@"index/0" withString:replaceStr];
    [DataTool getMoreDataWithStr:urlStr parameters:nil success:^(NSArray * array) {
        
        [self.tableView.footer endRefreshing];
        id str = array[0];
        if ([str isEqualToString:@"0"]) {
            self.tableView.footer.state = MJRefreshStateNoMoreData;
            
        } else
        {
            [self.newslistArr addObjectsFromArray:array[1]];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"加载时的错误数据%@", error);
    }];
    
}


#pragma mark ------------  UITableViewDataSource
#pragma mark --- 单元格的总行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"数据源中的个数%lu", self.newslistArr.count);
    return self.newslistArr.count + self.tournamentArr.count;
}
#pragma mark --- 单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger tournaments = self.tournamentArr.count;
    
    if (tournaments > 0) {
        if (indexPath.row == 0) {
            tournamentCell * cell = [tournamentCell cellWithTableView:tableView];
            cell.tournamentModel = [self.tournamentArr objectAtIndex:0];
            return cell;
        }
        
        NewsListModel * newslistModel = self.newslistArr[indexPath.row - 1];
        // 需要判断是什么类型的单元格
        /*
         2.资讯
         4.图集
         11.视频
         */
        if ([newslistModel.type isEqualToString:@"2"]) {
            InformationCell * cell = [InformationCell cellWithTableView:tableView];
            cell.newslistModel = newslistModel;
            return cell;
        } else if ([newslistModel.type isEqualToString:@"4"])
        {
            PicturesCell * cell = [PicturesCell cellWithTableView:tableView];
            cell.newslistModel = newslistModel;
            return cell;
        } else
        {
            InformationCell * cell = [InformationCell cellWithTableView:tableView];
            cell.newslistModel = newslistModel;
            return cell;
        }

    } else
    {
        NewsListModel * newslistModel = self.newslistArr[indexPath.row];
        // 需要判断是什么类型的单元格
        /*
         2.资讯
         4.图集
         11.视频
         */
        if ([newslistModel.type isEqualToString:@"2"]) {
            InformationCell * cell = [InformationCell cellWithTableView:tableView];
            cell.newslistModel = newslistModel;
            return cell;
        } else if ([newslistModel.type isEqualToString:@"4"])
        {
            PicturesCell * cell = [PicturesCell cellWithTableView:tableView];
            cell.newslistModel = newslistModel;
            return cell;
        } else
        {
            InformationCell * cell = [InformationCell cellWithTableView:tableView];
            cell.newslistModel = newslistModel;
            return cell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击行数%lu", indexPath.row);
    if (self.tournamentArr.count > 0) {
        if (indexPath.row == 0) {
            TournamentModel * model = self.tournamentArr[0];
            [self turnPageToDetailView:model.lurl];
//            [self turnPageToDetailView:@"http://192.168.1.102:8080/app/art/view/11/5096"];
        } else
        {
            NewsListModel * model = self.newslistArr[indexPath.row -1];
            [self turnPageToDetailView:model.url];
        }
        
    } else
    {
        NewsListModel * model = self.newslistArr[indexPath.row];
        [self turnPageToDetailView:model.url];
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tournamentArr.count > 0) {
        if (indexPath.row == 0) {
            return Margin188 * IPHONE6_H_SCALE;
        }
        NewsListModel * newslistModel = self.newslistArr[indexPath.row -self.tournamentArr.count];
        CGFloat cellHeight;
        if ([newslistModel.type isEqualToString:@"4"]) {
            cellHeight = Margin321 * IPHONE6_H_SCALE;
        } else
        {
            cellHeight = Margin196 * IPHONE6_H_SCALE;
        }
        return cellHeight;
    } else
    {
        NewsListModel * newslistModel = self.newslistArr[indexPath.row];
        CGFloat cellHeight;
        if ([newslistModel.type isEqualToString:@"4"]) {
            cellHeight = Margin321 * IPHONE6_H_SCALE;
        } else
        {
            cellHeight = Margin196 * IPHONE6_H_SCALE;
        }
        return cellHeight;
    }
    
}

// 实现代理中的方法
#pragma mark ------- 跳转到详情页网页
- (void)turnPageToDetailView:(NSString *)url
{
    DetailWebViewController * detaiVC = [[DetailWebViewController alloc] init];
    detaiVC.url = url;
    detaiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detaiVC animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    NSLog(@"111");
    return UIStatusBarStyleLightContent;
    NSLog(@"222");
}

@end


