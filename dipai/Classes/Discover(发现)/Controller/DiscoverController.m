//
//  DiscoverController.m
//  dipai
//
//  Created by 梁森 on 16/4/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "DiscoverController.h"
// 轮播页
#import "AdvertisementView.h"

// 李明杰的刷新
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 请求网络数据
#import "DataTool.h"

#import "SVProgressHUD.h"

// 发现页模型
#import "FindModel.h"
// 发现页轮播页模型
//#import "FindBannerModel.h"
#import "bannerModel.h"
// 模块模型
#import "NavigationModel.h"
// 热门专辑模型
#import "HotVideoModel.h"
// 类似WSOP视频专辑的模型
#import "WSOPModel.h"


// 模块单元格
#import "NavigationCell.h"
// 热门专辑单元格
#import "HotVideoCell.h"
// 第三个单元格（头）
#import "WSOPTableViewCell.h"
// 更多视频单元格
#import "MoreVideosCell.h"
// 有两个图片按钮的单元格
#import "TwoBtnCell.h"


// 俱乐部页面
#import "ClubViewController.h"
// 视频详情页面
#import "VideoViewController.h"
// 更多内容页面
#import "MoreVideosVC.h"
// 专辑页面
#import "AlbumVC.h"
// 赛事页面
#import "MatchVC.h"
// 扑克名人堂页面
#import "PokerVC.h"
// 专辑页面
#import "SpecialViewController.h"

@interface DiscoverController ()<UIScrollViewDelegate ,UITableViewDataSource, UITableViewDelegate, AdvertisementViewDelegate, HotVideoCellDelegate,TwoBtnCellDelegate, WSOPTableViewCellDelegate>
/**
 *  用来装热门视频中的视频模型
 */
@property (nonatomic, strong) NSMutableArray * hotVideoModelArr;
/**
 *  用来装WSOP中的视频模型
 */
@property (nonatomic, strong) NSMutableArray * videoModelArr;

/**
 *  轮播页
 */
@property (nonatomic, strong) AdvertisementView * advertiseView;

/**
 *  用来装轮播页模型
 */
@property (nonatomic, strong) NSMutableArray * bannerArr;

/**
 *  模块中的数据
 */
@property (nonatomic, strong) NavigationModel * navigationModel;
/**
 *  更多内容跳转接口
 */
@property (nonatomic, copy) NSString * moreVideoURL;
/**
 *  第三个单元格的标题
 */
@property (nonatomic, copy) NSString * titleText;

@property (nonatomic, strong) UICollectionView *collection;

@property (nonatomic, strong) UITableView * tableView;

/**
 *  <#Description#>
 */
@property (nonatomic, strong) WSOPTableViewCell * cell;

@end

@implementation DiscoverController

- (NSMutableArray *)bannerArr
{
    if (_bannerArr == nil) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}
- (NSMutableArray *)hotVideoModelArr{
    if (_hotVideoModelArr == nil) {
        _hotVideoModelArr = [NSMutableArray array];
    }
    return _hotVideoModelArr;
}

- (NSMutableArray *)videoModelArr{
    if (_videoModelArr == nil) {
        _videoModelArr = [NSMutableArray array];
    }
    return _videoModelArr;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

//    self.navigationController.navigationBarHidden = NO;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_beijingditu"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    //    [MobClick endLogPageView:@"DiscoverController"];
    
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"发现";
    self.naviBar.popV.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];

}
- (void)setUpUI{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    //    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    NSLog(@"表格的高度：%f", self.tableView.frame.size.height);
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 添加轮播页
    [self addBannerView];
    UIView *footerV = [[UIView alloc] init];
    footerV.frame = CGRectMake(0, 0, WIDTH, 49);
    //    footerV.backgroundColor = [UIColor redColor];
    self.tableView.tableFooterView = footerV;
    // 添加CollectionView
    //    [self addCollectionView];
    
    // 添加下拉刷新和上拉加载
    [self addRefresh];
}

#pragma mark --- 添加下拉刷新和上拉加载
- (void)addRefresh{
    // 添加下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏状态
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.hidden = YES;
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

#pragma mark --- 添加轮播页
- (void)addBannerView
{
    // 添加轮播页
    AdvertisementView * advertiseView = [[AdvertisementView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HeaderViewHeight * IPHONE6_H_SCALE)];
    //    advertiseView.backgroundColor = [UIColor redColor];
    advertiseView.delegate = self;
    _advertiseView = advertiseView;
    self.tableView.tableHeaderView = advertiseView;
    
}

#pragma mark --- AdvertisementViewDelegate
- (void)turnPageToDetailView:(NSString *)url
{
    //  直接跳转到视频详情页
    VideoViewController * videoVC = [[VideoViewController alloc] init];
    videoVC.url = url;
    videoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
}
// 加载新的数据
- (void)loadNewData{
    // 如果网络有问题结束刷新状态
    [NSTimer scheduledTimerWithTimeInterval:6.5 target:self selector:@selector(errorWithRefresh) userInfo:nil repeats:NO];
    
    [DataTool getFindPageDataWithStr:FindURL parameters:nil success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        FindModel * findModel = [[FindModel alloc] init];
        findModel = responseObject;
        
        //  轮播页中的数据
        NSMutableArray * arr = [NSMutableArray array];
        for (bannerModel * model in findModel.banner) {
            // 将banner模型装到数组中
            [arr addObject:model];
        }
        self.bannerArr = arr;
        
        // 模块中的数据
        NSDictionary * navigation = findModel.navigation;
        // 字典转模型
        NavigationModel * navigationModel = [NavigationModel objectWithKeyValues:navigation];
        _navigationModel = navigationModel;
        
        // 热门视频中的数据
        NSDictionary * album =findModel.Album;
        _moreVideoURL = album[@"more"];
        NSArray * dataArr = album[@"data"];
        
        NSMutableArray * hotArr = [NSMutableArray array];
        for (NSDictionary * dataDic in dataArr) {
            // 字典转模型
            HotVideoModel * hotVideoModel = [HotVideoModel objectWithKeyValues:dataDic];
            // 将热门专辑中的视频添加到数组中
            [hotArr addObject:hotVideoModel];
            
        }
        self.hotVideoModelArr = hotArr;
        
        // WSOP视频中的数据
        NSArray * videoArr = findModel.videoArr;
        self.videoModelArr = (NSMutableArray *)videoArr;
        
        // 设置数据
        [self setData];
        
        [self.tableView reloadData];
        NSLog(@"发现首页获取到的数据%@", findModel);
    } failure:^(NSError * error) {
        
        NSLog(@"获取发现首页的错误信息:%@", error);
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

#pragma mark --- 设置数据
- (void)setData{
    //     确定滚动视图的contentSize
    
//    NSLog(@"%lu", self.bannerArr.count);
    
    NSUInteger count = self.bannerArr.count;
    NSNumber * num = [NSNumber numberWithUnsignedInteger:count];
    int counts = [num intValue];
    
//    NSLog(@"%d", counts);
    [_advertiseView setScrollWithCount:counts andArray:self.bannerArr];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
#pragma mark --- 单元格的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    NSLog(@"WSOP视频专辑个数：%lu", self.videoModelArr.count);
    
    return 2 + self.videoModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {   // 俱乐部、赛事、名人堂、专题
        NavigationCell * cell = [NavigationCell cellWithTableView:tableView];
        [cell.clubBtn addTarget:self action:@selector(turnPageToSomePage:) forControlEvents:UIControlEventTouchUpInside];
        cell.clubBtn.tag = 1;
        [cell.matchBtn addTarget:self action:@selector(turnPageToSomePage:) forControlEvents:UIControlEventTouchUpInside];
        cell.matchBtn.tag = 2;
        [cell.pokerBtn addTarget:self action:@selector(turnPageToSomePage:) forControlEvents:UIControlEventTouchUpInside];
        cell.pokerBtn.tag = 3;
        [cell.specialBtn addTarget:self action:@selector(turnPageToSomePage:) forControlEvents:UIControlEventTouchUpInside];
        cell.specialBtn.tag = 4;
        return cell;
    } else if (indexPath.row == 1){ // 视频专辑
        HotVideoCell * cell = [HotVideoCell cellWithTableView:tableView];
        cell.delegate = self;
        // 为更多内容按钮添加点击事件
        [cell.moreBtn addTarget:self action:@selector(turePageToMoreVideo) forControlEvents:UIControlEventTouchUpInside];
//        NSLog(@"-----%@", self.hotVideoModelArr);
        cell.videoModelArr = self.hotVideoModelArr;
        return cell;
        
    } else{ // 热门视频
        WSOPTableViewCell * cell = [WSOPTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        WSOPModel * wsopModel = self.videoModelArr[indexPath.row - 2];
        cell.wsopModel = wsopModel;
        return cell;
    }
}

#pragma mark --- TwoBtnCellDelegate
- (void)tableViewCell:(TwoBtnCell *)cell DidClickWithURL:(NSString *)url{
    VideoViewController * videoVC = [[VideoViewController alloc] init];
    videoVC.url = url;
    videoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
}

#pragma mark ---  点击模块上的按钮跳到某一页
- (void)turnPageToSomePage:(UIButton *)btn{
    ClubViewController * clubVC = [[ClubViewController alloc] init];    // 俱乐部页面
     MatchVC * matchVC = [[MatchVC alloc] init];    // 赛事页面
    PokerVC * pokerVC = [[PokerVC alloc] init]; // 扑克名人堂页面
    SpecialViewController * specialVC = [[SpecialViewController alloc] init];
    switch (btn.tag) {
        case 1: // 跳转到俱乐部页面
            clubVC.clubURL = _navigationModel.club;
            clubVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:clubVC animated:YES];
            break;
        case 2:            // 跳转到赛事页面
            matchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:matchVC animated:YES];
            break;
        case 3: // 跳转到扑克名人堂页面
            pokerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pokerVC animated:YES];
            break;
        case 4: // 跳转到专辑页面
            specialVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:specialVC animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark --- 点击更多内容按钮
- (void)turePageToMoreVideo{
//    NSLog(@"更多内容....");
    MoreVideosVC * moreVideoVC = [[MoreVideosVC alloc] init];
    moreVideoVC.moreURL = _moreVideoURL;
    moreVideoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreVideoVC animated:YES];

}

#pragma mark --- HotVideoCellDelegate
- (void)turePageToVideoVCWithTag:(NSInteger)tag andWapURL:(NSString *)wapurl{
    
    AlbumVC * albumVC = [[AlbumVC alloc] init];
    albumVC.hidesBottomBarWhenPushed = YES;
    albumVC.wapurl = wapurl;
    [self.navigationController pushViewController:albumVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%lu", indexPath.row);
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.videoModelArr.count > 0) {
        if (indexPath.row == 0) {   // navigation单元格
            return 90 * IPHONE6_H_SCALE;
        } else if (indexPath.row == 1){ // 视频专辑单元格
            return 680 * 0.5 * IPHONE6_H_SCALE;
        } else{ // 热门视频
//            NSLog(@"%lu", self.videoModelArr.count);
            WSOPModel * wsopModel = self.videoModelArr[indexPath.row - 2];
            NSInteger videoNum = wsopModel.data.count;
            // 获取data数组中的个数即专辑个数即能获得此单元格的高
            NSInteger i = videoNum % 2;
            NSInteger j;
            if (i == 0) {
                j = videoNum / 2;
            } else{
                j = videoNum / 2 + 1;
            }
//            NSLog(@"专辑中视频个数：%lu", j);
            return (30 + 291 * 0.5 * j)*IPHONE6_H_SCALE;
        }
    } else{
        if (indexPath.row == 0) {   // navigation单元格
            return 180 * 0.5 * IPHONE6_H_SCALE;
        } else if (indexPath.row == 1){ // 视频专辑单元格
            return 680 * 0.5 * IPHONE6_H_SCALE;
        } else{
            return 100;
        }
    }
}

#pragma WSOPTableViewCellDelegate
- (void)turnPageToVideoDetailWith:(NSString *)wapurl{
//    NSLog(@"%@", wapurl);
    VideoViewController * videoVC = [[VideoViewController alloc] init];
    videoVC.url = wapurl;
    videoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
}

@end
