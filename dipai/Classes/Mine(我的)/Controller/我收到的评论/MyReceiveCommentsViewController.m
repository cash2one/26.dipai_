//
//  MyReceiveCommentsViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/30.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyReceiveCommentsViewController.h"

// 我收到的评论的单元格
#import "MyReceiveCell.h"
#import "MyReceiveModel.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 帖子详情页
#import "PostDetailVC.h"
// 资讯或图集详情页
#import "DetailWebViewController.h"
//  视频详情页
#import "VideoViewController.h"
// 赛事详情页
#import "MatchDetailVC.h"

#import "StarVC.h"
#import "AnyBodyVC.h"
#import "SBModel.h"

#import "DataTool.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "HttpTool.h"

#import "Masonry.h"
@interface MyReceiveCommentsViewController ()<UITableViewDataSource, UITableViewDelegate, MyReceiveCellDelegate>

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
    LSTypeSpecialList = 18,
    
    // H5活动
    LSTypeH5 = 201
};
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;


@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) SBModel * sbModel;
// 没有评论的提示图
@property (nonatomic, strong) UIImageView * imageV;
@end

@implementation MyReceiveCommentsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    // 设置导航栏
    [self setNavigationBar];
    [self addTabelView];
}

#pragma mark --- 设置导航条
- (void)setNavigationBar {
    self.naviBar.titleStr = @"我收到的评论";
    self.naviBar.titleLbl.textColor = [UIColor blackColor];
    self.naviBar.backgroundColor = [UIColor whiteColor];
    self.naviBar.bottomLine.hidden = NO;
    self.naviBar.popV.hidden = NO;
    self.naviBar.popImage = [UIImage imageNamed:@"houtui"];
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTabelView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 8 * IPHONE6_H_SCALE+64 , WIDTH , HEIGHT-64-8 *IPHONE6_H_SCALE) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIImageView * imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"meiyoushoudaopinglun"];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(298 * 0.5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(242 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(187 * 0.5 * IPHONE6_W_SCALE));
    }];
    _imageV = imageV;
    _imageV.hidden = YES;
    
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
    [header beginRefreshing];
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.tableView.footer = footer;
}

- (void)loadNewData{
    
    [DataTool getMyReceiveDataWithStr:MyReceiveURL parameters:nil success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([responseObject isKindOfClass:[NSString class]]) {
            _imageV.hidden = NO;
        }else{
            _imageV.hidden = YES;
           self.dataSource = responseObject;
        }
        [self.tableView reloadData];
//        NSLog(@"%@", responseObject);
    } failure:^(NSError * error) {
       
        NSLog(@"获取我收到的评论出错：%@", error);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

- (void)loadMoreData{
    
    MyReceiveModel * model = [self.dataSource lastObject];
    
//    NSLog(@"%@", model.iD);
    
    NSString * url = [MyReceiveURL stringByAppendingString:[NSString stringWithFormat:@"/%@", model.iD]];
    [DataTool getMyReceiveDataWithStr:url parameters:nil success:^(id responseObject) {
        
        [self.tableView.footer endRefreshing];
        if ([responseObject isKindOfClass:[NSString class]]) {
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }else{
            [self.dataSource addObjectsFromArray:responseObject]; 
        }
        
        
        [self.tableView reloadData];
        //        NSLog(@"%@", responseObject);
    } failure:^(NSError * error) {
        
        NSLog(@"获取我收到的评论出错：%@", error);
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyReceiveCell * cell = [MyReceiveCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.receiveModel = self.dataSource[indexPath.row];
    return cell;
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94 * IPHONE6_H_SCALE;
}

#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyReceiveModel * receiveModel = self.dataSource[indexPath.row];
   
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
    
    NSString * url = receiveModel.wapurl;
    [HttpTool GET:url parameters:nil success:^(id responseObject) {
        
        NSString * type = responseObject[@"type"];
        NSInteger num = [type integerValue];
        NSLog(@"type:%lu", num);
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
            
        }else if (num == LSTypePokerStarList){  // 扑克名人堂列表
            
        }else if (num == LSTypePostList){   // 帖子列表
            
        }else if (num == LSTypeVideoList){  // 视频专辑
            
        }else if (num == LSTypeClubDetail){ // 俱乐部详情页
            
        }else if (num == LSTypeSpecial){    // 专题
            
        }else if (num == LSTypeSpecialList){    // 专题列表
            
        }else if (num == LSTypeAllVideo){   // 全部视频专辑
            
        }else if (num == LSTypeStar){   // 名人主页
            
        }
        else if(num == LSTypeH5){  // 如果是内部H5页面
            
        }
        else{   // 未识别type
            NSLog(@"---%@",url);
            
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
        NSLog(@"出错：%@",error);
    }];

    
}

#pragma mark --- MyReceiveCellDelegate
- (void)tableViewCell:(MyReceiveCell *)cell didClickNameWithModel:(MyReceiveModel *)model{
    
    StarVC * starVC = [[StarVC alloc] init];
    AnyBodyVC * anyVC = [[AnyBodyVC alloc] init];
    [DataTool getSBDataWithStr:model.userurl parameters:nil success:^(id responseObject) {
        
        SBModel * sbModel = [[SBModel alloc] init];
        sbModel = responseObject;
        _sbModel = sbModel;
        if ([_sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {   // 如果认证为空，就是普通人主页
            anyVC.userURL = model.userurl;
            anyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:anyVC animated:YES];
        }else{
            starVC.userURL = model.userurl;
            starVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:starVC animated:YES];
        }
    } failure:^(NSError * error) {
        NSLog(@"获取个人数据出错：%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
