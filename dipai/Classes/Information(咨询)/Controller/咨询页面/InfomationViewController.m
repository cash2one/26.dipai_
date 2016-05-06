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
@interface InfomationViewController ()<UITableViewDataSource, UITableViewDelegate, AdvertisementViewDelegate>
/**
 *  表格
 */
@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * newslistArr;
/**
 *  用来装轮播页模型
 */
@property (nonatomic, strong) NSMutableArray * bannerArr;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // 搭建UI
    [self createUI];
    // 添加下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    // 自动下拉刷新
    [self.tableView headerBeginRefreshing];
}
#pragma mark ------ 下拉刷新，加载新的数据
- (void)loadNewData
{
//    http://192.168.1.111:8080/app/index/0/10/1?begain=0&perpage=10&version=0
    InfoPara * parameter = [[InfoPara alloc] init];
    parameter.begain = 0;
    parameter.perpage = 10;
    parameter.version = @"0";
    
    [DataTool getNewDataWithStr:InformationURL parameters:nil success:^(NSArray * arr) {
        [self.tableView headerEndRefreshing];
        NSArray * bannerModelArr = [arr objectAtIndex:0];
        NSArray * listModelArr = [arr objectAtIndex:1];
        // 轮播页的数组
        [self.bannerArr removeAllObjects];
        [self.bannerArr addObjectsFromArray:bannerModelArr];
        // 表格的数组
        [self.newslistArr removeAllObjects];
        [self.newslistArr addObjectsFromArray:listModelArr];
//        NSLog(@"%@", self.newslistArr);
        // 添加轮播页
        [self addBannerView];
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
         NSLog(@"错误信息%@", error);
    }];

}

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

- (void)createUI
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 49 - 64) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    NSLog(@"表格的高度：%f", self.tableView.frame.size.height);
    [self.view addSubview:self.tableView];
    
}

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
//    DataTool 
}


#pragma mark ------------  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"数据源中的个数%lu", self.newslistArr.count);
    return self.newslistArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsListModel * newslistModel = self.newslistArr[indexPath.row];
    // 需要判断是什么类型的单元格
    if (newslistModel.type == 2) {
        InformationCell * cell = [InformationCell cellWithTableView:tableView];
        cell.newslistModel = newslistModel;
        return cell;
    } else if (newslistModel.type == 4)
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"点击单元格...");
    NewsListModel * model = self.newslistArr[indexPath.row];
    [self turnPageToDetailView:model.url];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NewsListModel * newslistModel = self.newslistArr[indexPath.row];
    CGFloat cellHeight;
    if (newslistModel.type == 4) {
        cellHeight = Margin321 * IPHONE6_H_SCALE;
    } else
    {
        cellHeight = Margin196 * IPHONE6_H_SCALE;
    }
    
    return cellHeight;
    
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

@end


