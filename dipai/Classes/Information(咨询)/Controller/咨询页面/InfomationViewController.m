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
// 扑克名人堂页面
#import "PokerVC.h"
// 名人堂列表
#import "MorePokersVC.h"
// 视频专辑页面
#import "AlbumVC.h"
// 俱乐部详情页
#import "ClubDetailViewController.h"
// 专题列表
#import "SpecialViewController.h"
// 专题详情页
#import "SpecialDetailVC.h"
// 全部视频专辑
#import "MoreVideosVC.h"
// 名人主页
#import "StarVC.h"
// 普通用户主页
#import "AnyBodyVC.h"
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

// 发现页面
#import "DiscoverController.h"

// 活动控制器
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "HttpTool.h"
@interface InfomationViewController ()<UIScrollViewDelegate ,UITableViewDataSource, UITableViewDelegate, AdvertisementViewDelegate, AppDelegate>

typedef NS_ENUM(NSUInteger, LSType) {
    /** 资讯 */
    LSTypeInfo = 2,
    /** 图集 */
    LSTypePictures = 4,
    /** 赛事 */
    LSTypeMatch = 5,
    /** 赛事 详情页*/
    LSTypeMatchDetail = 51,
    /** 直播 */
    LSTypeLive = 6,
    /** 视频 */
    LSTypeVideo = 11,
    /** 帖子详情 */
    LSTypePostDetail = 172,
    
     /** 视频专辑 */
    LSTypeVideoList = 101,
    /** 全部视频专辑 */
    LSTypeAllVideo = 10,
    /** 帖子列表 */
    LSTypePostList = 171,
    /** 名人堂*/
    LSTypePokerStar = 151,
    /** 名人主页*/
    LSTypeStar = 153,
    /** 名人堂列表 */
    LSTypePokerStarList = 152,
    /** 俱乐部详细页面 */
    LSTypeClubDetail = 81,
    /** 专题 */
    LSTypeSpecial = 9,
    /** 专题列表 */
    LSTypeSpecialList = 18
};

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

- (void)dismissWithStr:(NSString *)str{
    NSLog(@"dismisswithstr...");
}

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
    
//    [MobClick beginLogPageView:@"InfomationViewController"];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_beijingditu"] forBarMetrics:UIBarMetricsDefault];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
//    [MobClick endLogPageView:@"InfomationViewController"];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.delegate = self;
    
    // 搭建UI
    [self createUI];
    // 添加下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏状态
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.hidden = YES;
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
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    // 设置footer
    self.tableView.footer = footer;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * first = [defaults objectForKey:appStart];
    if (first.length > 0) {
        NSLog(@"App启动");
    }
    [defaults removeObjectForKey:appStart];
    
//    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(errorWithRefresh) userInfo:nil repeats:NO];
}
#pragma mark --- 有通知的时候进行跳转
- (void)pushToViewControllerWithURL:(NSString *)url{
    
    NSLog(@"%@", url);
    [HttpTool GET:url parameters:nil success:^(id responseObject) {
        
        NSString * type = responseObject[@"type"];
        NSInteger num = [type integerValue];
        if (num == LSTypeInfo || num == LSTypePictures) {
            // 跳转到资讯页面或图集页面
            DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
            detailVC.url = url;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        } else if (num == LSTypeVideo){ // 如果是视频
            // 跳转到视频专辑页
            VideoViewController * videoVC = [[VideoViewController alloc] init];
            videoVC.url = url;
            videoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:videoVC animated:YES];
        } else if (num == LSTypeMatchDetail){  // 如果是赛事详情页
            MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
            detailVC.wapurl = url;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (num == LSTypePostDetail){ // 如果是帖子详情页
            PostDetailVC * postDetail =[[PostDetailVC alloc] init];
            postDetail.wapurl = url;
            postDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:postDetail animated:YES];
        }else if (num == LSTypePokerStar){  // 扑克名人堂页面
            PokerVC * pokerVC = [[PokerVC alloc] init];
            pokerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pokerVC animated:YES];
        }else if (num == LSTypePokerStarList){  // 扑克名人堂列表
            MorePokersVC * morePokers = [[MorePokersVC alloc] init];
            morePokers.wapurl = MorePokersURL;
            morePokers.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:morePokers animated:YES];
        }else if (num == LSTypePostList){   // 帖子列表
            
        }else if (num == LSTypeVideoList){  // 视频专辑
            AlbumVC * albumVC = [[AlbumVC alloc] init];
            albumVC.hidesBottomBarWhenPushed = YES;
            albumVC.wapurl = url;
            [self.navigationController pushViewController:albumVC animated:YES];
        }else if (num == LSTypeClubDetail){ // 俱乐部详情页
            NSString * title = responseObject[@"data"][@"title"];
            ClubDetailViewController * clubDetaiVC = [[ClubDetailViewController alloc] init];
            clubDetaiVC.wapurl = url;
            clubDetaiVC.title = title;
            clubDetaiVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:clubDetaiVC animated:YES];
        }else if (num == LSTypeSpecial){    // 专题
            SpecialViewController * specialVC = [[SpecialViewController alloc] init];
            specialVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:specialVC animated:YES];
        }else if (num == LSTypeSpecialList){    // 专题列表
            SpecialDetailVC * specialVC = [[SpecialDetailVC alloc] init];
            specialVC.wapurl = url;
            specialVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:specialVC animated:YES];
        }else if (num == LSTypeAllVideo){   // 全部视频专辑
            MoreVideosVC * moreVideoVC = [[MoreVideosVC alloc] init];
            moreVideoVC.moreURL = url;
            moreVideoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreVideoVC animated:YES];
        }else if (num == LSTypeStar){   // 名人主页
            if ([responseObject[@"data"][@"certified"] isKindOfClass:[NSNull class]]) {
                AnyBodyVC * anyBodyVC = [[AnyBodyVC alloc] init];
                anyBodyVC.userURL = url;
                anyBodyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:anyBodyVC animated:YES];
            }else{
                StarVC * starVC = [[StarVC alloc] init];
                starVC.userURL = url;
                starVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:starVC animated:YES];
            }
            
        }else{
            
            NSLog(@"%@", url);
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
        NSLog(@"出错：%@",error);
    }];
    
//    if ([url rangeOfString:@"art/view/11"].location != NSNotFound) {
//        // 跳转到视频专辑页
//        VideoViewController * videoVC = [[VideoViewController alloc] init];
//        videoVC.url = url;
//        videoVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:videoVC animated:YES];
//    }else if ([url rangeOfString:@"art/view/2"].location != NSNotFound || [url rangeOfString:@"art/view/4"].location != NSNotFound){
//        // 跳转到资讯页面
//        
//        DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
//        detailVC.url = url;
//        detailVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:detailVC animated:YES];
//        
//    } else if ([url rangeOfString:@"forum/view"].location != NSNotFound){    // 跳转到帖子详情页
//        
//        PostDetailVC * postDetail =[[PostDetailVC alloc] init];
//        postDetail.wapurl = url;
//        postDetail.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:postDetail animated:YES];
//        
//    }else if ([url rangeOfString:@"club/view/5"].location != NSNotFound){ // 跳转到赛事详情页页面
//        
//        // 赛事详情页分为两种情况：1.有直播  2.没有直播
//        MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
//        detailVC.wapurl = url;
//        detailVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:detailVC animated:YES];
//        
//    }else if ([url isEqualToString:@"https://itunes.apple.com/cn/app/di-pai/id1000553183?mt=8"]){   // 跳转到AppStore中
//        
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/di-pai/id1000553183?mt=8"]];
//    }
//    else
//    {
//        NSLog(@"%@", url);
//    }
}

#pragma mark ------ 下拉刷新，加载新的数据
- (void)loadNewData
{
    if (self.tableView.footer.state == MJRefreshStateRefreshing) return;    // 如果正在加载就不刷新
    // 如果网络有问题结束刷新状态
    [NSTimer scheduledTimerWithTimeInterval:6.5 target:self selector:@selector(errorWithRefresh) userInfo:nil repeats:NO];
    
    [DataTool getNewDataWithStr:InformationURL parameters:nil success:^(NSArray * arr) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSArray * bannerModelArr = [arr objectAtIndex:0];
        NSArray * tournamentModelArr = [arr objectAtIndex:1];
        NSArray * listModelArr = [arr objectAtIndex:2];
        // 轮播页的数组
        [self.bannerArr removeAllObjects];
        [self.bannerArr addObjectsFromArray:bannerModelArr];
        
        // 赛事页的数组
        if (tournamentModelArr.count > 1) {
            NSLog(@"没有赛事");
            [self.tournamentArr removeAllObjects];
//            [self.tournamentArr addObjectsFromArray:tournamentModelArr];
        }else{  // 有赛事
            NSLog(@"有赛事");
            [self.tournamentArr removeAllObjects];
            [self.tournamentArr addObjectsFromArray:tournamentModelArr];
        }
        
        // 表格的数组
        [self.newslistArr removeAllObjects];
        [self.newslistArr addObjectsFromArray:listModelArr];
        // 添加轮播页
        [self addBannerView];
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
         NSLog(@"获取首页错误信息%@", error);
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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49 * IPHONE6_H_SCALE)];
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
    
    if (self.tableView.header.state == MJRefreshStateRefreshing){
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }   // 如果正在刷新就不加载
    if (self.tableView.header.state == MJRefreshStateRefreshing) return;
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

#pragma mark --- 刷新失败
- (void)errorWithRefresh{
    if (!self.bannerArr.count) {
        // 结束刷新
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络不通畅"];
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
    
    if (tournaments > 0) {  // 如果有赛事
        if (indexPath.row == 0) {   // 赛事单元格
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

    } else  // 没有赛事
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
    if (self.tournamentArr.count > 0) { // 如果有推荐赛事
        
        if (indexPath.row == 0) {   // 如果点击的是推荐赛事
            TournamentModel * model = self.tournamentArr[0];
            
            
            if ([model.lurl rangeOfString:@"club/view/5"].location != NSNotFound) {
                // 赛事详情页分为两种情况：1.有直播  2.没有直播
                MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
                detailVC.wapurl = model.lurl;
                detailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailVC animated:YES];
            }else{
                NSLog(@"%@", model.lurl);
                NSLog(@"没有赛事");
            }

        } else  // 如果点击的不是推荐赛事
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
        
    } else  // 如果没有推荐赛事
    {
        NSLog(@"没有推荐赛事..");
        NewsListModel * model = self.newslistArr[indexPath.row];
//        [self turnPageToDetailView:model.url withNewsListModel:model];
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
    
    // 详情页：1:资讯页 2:图集页  3:视频页 4:赛事页  5:
//    [SVProgressHUD show];
    // 视频
//    url = @"http://dipaiapp.replays.net/app/art/view/11/7914";
//    // 帖子
//    url = @"http://dipaiapp.replays.net/app/forum/view/6";
//   
//    // http://dpapp.replays.net/app/poker/list  名人堂列表
//    url = @"http://dpapp.replays.net/app/poker/list";
//    // http://dpapp.replays.net/app/user/poker 扑克名人堂
//    url = @"http://dpapp.replays.net/app/user/poker";
//    // 帖子列表
//    url = @"http://dpapp.replays.net/app/forum/list/2";
//    // 视频专辑
//    url = @"http://dpapp.replays.net/app/album/list/7913";
//    // 俱乐部详情页
//    url = @"http://dpapp.replays.net/app/club/view/8/1981";
//    // 专题列表
//    url = @"http://dpapp.replays.net/app/special/9";
//    // 专题详细列表
//    url = @"http://dpapp.replays.net/article/special_list/10098330";
//    // 赛事
//    url = @"http://dpapp.replays.net/app/club/view/5/8576";
//    // 全部视频专辑
//    url = @"http://dpapp.replays.net/app/hot/album/list/1";
//    // 名人主页
//    url = @"http://dpapp.replays.net/app/user_space/259";
//    // 普通用户主页
//    url = @"http://dpapp.replays.net/app/user_space/856";
    
    NSLog(@"%@", url);
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"没有网络");
            [SVProgressHUD showErrorWithStatus:@"无网络连接"];
        }else{
        }
    }];
    [manager startMonitoring];
    [HttpTool GET:url parameters:nil success:^(id responseObject) {
        
        NSString * type = responseObject[@"type"];
        NSInteger num = [type integerValue];
        if (num == LSTypeInfo || num == LSTypePictures) {
            // 跳转到资讯页面或图集页面
            DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
            detailVC.url = url;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        } else if (num == LSTypeVideo){ // 如果是视频
            // 跳转到视频专辑页
            VideoViewController * videoVC = [[VideoViewController alloc] init];
            videoVC.url = url;
            videoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:videoVC animated:YES];
        } else if (num == LSTypeMatchDetail){  // 如果是赛事详情页
            MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
            detailVC.wapurl = url;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (num == LSTypePostDetail){ // 如果是帖子详情页
            PostDetailVC * postDetail =[[PostDetailVC alloc] init];
            postDetail.wapurl = url;
            postDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:postDetail animated:YES];
        }else if (num == LSTypePokerStar){  // 扑克名人堂页面
            PokerVC * pokerVC = [[PokerVC alloc] init];
            pokerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pokerVC animated:YES];
        }else if (num == LSTypePokerStarList){  // 扑克名人堂列表
            MorePokersVC * morePokers = [[MorePokersVC alloc] init];
            morePokers.wapurl = MorePokersURL;
            morePokers.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:morePokers animated:YES];
        }else if (num == LSTypePostList){   // 帖子列表
            
        }else if (num == LSTypeVideoList){  // 视频专辑
            AlbumVC * albumVC = [[AlbumVC alloc] init];
            albumVC.hidesBottomBarWhenPushed = YES;
            albumVC.wapurl = url;
            [self.navigationController pushViewController:albumVC animated:YES];
        }else if (num == LSTypeClubDetail){ // 俱乐部详情页
            NSString * title = responseObject[@"data"][@"title"];
            ClubDetailViewController * clubDetaiVC = [[ClubDetailViewController alloc] init];
            clubDetaiVC.wapurl = url;
            clubDetaiVC.title = title;
            clubDetaiVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:clubDetaiVC animated:YES];
        }else if (num == LSTypeSpecial){    // 专题
            SpecialViewController * specialVC = [[SpecialViewController alloc] init];
            specialVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:specialVC animated:YES];
        }else if (num == LSTypeSpecialList){    // 专题列表
            SpecialDetailVC * specialVC = [[SpecialDetailVC alloc] init];
            specialVC.wapurl = url;
            specialVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:specialVC animated:YES];
        }else if (num == LSTypeAllVideo){   // 全部视频专辑
            MoreVideosVC * moreVideoVC = [[MoreVideosVC alloc] init];
            moreVideoVC.moreURL = url;
            moreVideoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreVideoVC animated:YES];
        }else if (num == LSTypeStar){   // 名人主页
            if ([responseObject[@"data"][@"certified"] isKindOfClass:[NSNull class]]) {
                AnyBodyVC * anyBodyVC = [[AnyBodyVC alloc] init];
                anyBodyVC.userURL = url;
                anyBodyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:anyBodyVC animated:YES];
            }else{
                StarVC * starVC = [[StarVC alloc] init];
                starVC.userURL = url;
                starVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:starVC animated:YES];
            }
           
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
        NSLog(@"出错：%@",error);
    }];
    
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
    
    return UIStatusBarStyleLightContent;
}

@end


