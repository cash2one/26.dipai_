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
//#import "TestViewController.h"
// 轮播页（广告页）
#import "AdvertisementView.h"
// 详情页网页
#import "DetailWebViewController.h"
// 视频详情页
#import "VideoViewController.h"
//  赛事详情页
#import "MatchDetailVC.h"
//
#import "PostDetailVC.h"
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

// 活动控制器
#import "SVProgressHUD.h"
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
    
    
    
    
//    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(errorWithRefresh) userInfo:nil repeats:NO];
}
#pragma mark ------ 下拉刷新，加载新的数据
- (void)loadNewData
{
    // 如果网络有问题结束刷新状态
    [NSTimer scheduledTimerWithTimeInterval:6.5 target:self selector:@selector(errorWithRefresh) userInfo:nil repeats:NO];
    
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
    
    // 添加一个表格的脚视图
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
}

#pragma mark --- 添加表格
- (void)createUI
{
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 49 - 64) style:UITableViewStylePlain];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT  - 64) style:UITableViewStylePlain];
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
//    TestViewController * testVC = [[TestViewController alloc] init];
//    testVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:testVC animated:YES];
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
            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了"];
            
        } else
        {
            [self.newslistArr addObjectsFromArray:array[1]];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"加载时的错误数据%@", error);
    }];
    
}

#pragma mark --- 刷新失败
- (void)errorWithRefresh{
    if (!self.bannerArr.count) {
        // 结束刷新
        [self.tableView.header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络有问题"];
    }
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
#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"点击行数%lu", indexPath.row);
    if (self.tournamentArr.count > 0) {
        if (indexPath.row == 0) {   // 如果有赛事
            TournamentModel * model = self.tournamentArr[0];
            NSLog(@"跳转到赛事。。。");
//            MatchDetailVC * detaiVC = [[MatchDetailVC alloc] init];
//            detaiVC.wapurl = model.lurl;
//            detaiVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:detaiVC animated:YES];
//            [self turnPageToDetailView:@"http://192.168.1.102:8080/app/art/view/11/5096"];
        } else
        {
            NewsListModel * model = self.newslistArr[indexPath.row -1];
            if ([model.type isEqualToString:@"11"]) {
                // 跳转到视频详情页
                VideoViewController * videoVC = [[VideoViewController alloc] init];
                videoVC.url = model.url;
                videoVC.des = model.descriptioN;
                videoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:videoVC animated:YES];
            } else{
                [self turnPageToDetailView:model.url withNewsListModel:model];
            }
            
        }
        
    } else  // 如果没有赛事
    {
        NewsListModel * model = self.newslistArr[indexPath.row];
        [self turnPageToDetailView:model.url withNewsListModel:model];
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
    // 详情页：1:资讯页 2:图集页  3:视频页 4:赛事页  5:
    if ([url rangeOfString:@"art/view/11"].location != NSNotFound) {
        
        // 跳转到视频专辑页
        VideoViewController * videoVC = [[VideoViewController alloc] init];
        videoVC.url = url;
        videoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:videoVC animated:YES];
    }else if ([url rangeOfString:@"art/view/2"].location != NSNotFound || [url rangeOfString:@"art/view/4"].location != NSNotFound){
        // 跳转到资讯页面
        
        DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
        detailVC.url = url;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } else if ([url rangeOfString:@"forum/view"].location != NSNotFound){    // 跳转到帖子详情页
        
        PostDetailVC * postDetail =[[PostDetailVC alloc] init];
        postDetail.wapurl = url;
        postDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postDetail animated:YES];
        
    }else if ([url rangeOfString:@"club/view/5"].location != NSNotFound){ // 跳转到赛事详情页页面
        
        // 赛事详情页分为两种情况：1.有直播  2.没有直播
        MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
        detailVC.wapurl = url;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    else
    {
        NSLog(@"%@", url);
    }

}

- (void)turnPageToDetailView:(NSString *)url withNewsListModel:(NewsListModel *)newsListModel
{
    DetailWebViewController * detaiVC = [[DetailWebViewController alloc] init];
    detaiVC.url = url;
    detaiVC.newsModel = newsListModel;
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


