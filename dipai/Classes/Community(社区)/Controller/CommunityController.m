//
//  CommunityController.m
//  dipai
//
//  Created by 梁森 on 16/4/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CommunityController.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"
// 论坛模型
#import "ForumModel.h"
// 模块模型
#import "SectionModel.h"
// 论坛的头视图
#import "HeaderViewInTalking.h"

#import "DataTool.h"
// 模块视图
#import "SectionVC.h"
// 帖子的详细页面
#import "PostDetailVC.h"
#import "PostCell.h"
#import "PostFrameModel.h"
#import "PostsModel.h"


// 圈子模型
#import "GroupModel.h"
// 圈子返回数据模型
#import "CircleModel.h"
// 圈子单元格
#import "GroupCell.h"

//#import "GrpPostCell.h"
#import "GrpPostFrmModel.h"

#import "SVProgressHUD.h"

// 资讯页详情页
#import "DetailWebViewController.h"
// 视频详情页
#import "VideoViewController.h"
// 赛事详情页
#import "MatchDetailVC.h"

// 普通用户主页
#import "AnyBodyVC.h"
// 名人主页
#import "StarVC.h"
#import "SBModel.h"

// VM
#import "GroupFrameModel.h"
@interface CommunityController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, HeaderViewInTalkingDelegate, GroupCellDelegate, PostCellDelegate>
{
    UISegmentedControl *_segmented;
    // 滚动视图
    UIScrollView *_sc;
    // 对应分段控件的三个tableView
//    UITableView *_tableView1;
//    UITableView *_tableView2;
//    UITableView *_tableView3;
//    
    // 论坛模型
    ForumModel * _forumModel;
    
    // 圈子获取更多数据时发送的一个标识
    NSString * _page;
}
// 热门讨论数据源
@property (nonatomic, strong) NSMutableArray * dataSource1;
// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource2;

@property (nonatomic, strong) UITableView * tableView1;
@property (nonatomic, strong) UITableView * tableView2;

@property (nonatomic, strong) SBModel * sbModel;
@end

@implementation CommunityController

- (NSMutableArray *)dataSource1{
    if (_dataSource1 == nil) {
        _dataSource1 = [NSMutableArray array];
    }
    return _dataSource1;
}

- (NSMutableArray *)dataSource2{
    if (_dataSource2 == nil) {
        _dataSource2 = [NSMutableArray array];
    }
    return _dataSource2;
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
    
    self.view.backgroundColor = [UIColor blueColor];
    self.navigationItem.title = @"";
    // 添加分段控件
    [self addSegmentControl];
    
    // 添加滚动视图
    [self addScrollView];
    
}

- (void)addSegmentControl{
    // 分段控件
    _segmented = [[UISegmentedControl alloc]initWithItems:@[@"论坛",@"关注"]];
    _segmented.selectedSegmentIndex = 0;
    // 被选中时的背景色
    _segmented.tintColor = [UIColor blackColor];
    // 未被选中的背景色
    _segmented.backgroundColor = [UIColor blackColor];
    
    // 被选中时的字体的颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:Font18} forState:UIControlStateSelected];
    // 正常情况下的字体颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:Font18} forState:UIControlStateNormal];
    
    _segmented.frame=CGRectMake( 0 , 0, 160 * IPHONE6_W_SCALE , 44 );
//    _segmented.backgroundColor = [UIColor yellowColor];
    // 为分段控件添加点事件
    [_segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmented;
}
#pragma mark --- 分段控件的点击事件
-(void)segmentedClick:(UISegmentedControl*)seg{
    
    // 根据情况改变滚动视图的偏移
    if (seg.selectedSegmentIndex == 0) {
        _sc.contentOffset=CGPointMake(0, 0);
    }else{
        _sc.contentOffset=CGPointMake( WIDTH , 0);
    }
}

- (void)addScrollView {
    
//    NSLog(@"%f", HEIGHT);
    
    _sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH , HEIGHT-64)];
    _sc.contentSize=CGSizeMake(WIDTH * 2 , HEIGHT);
    _sc.scrollEnabled = NO; // 禁止活动
    _sc.scrollsToTop = NO;
    _sc.delegate=self;
    _sc.bounces=NO;
    _sc.pagingEnabled=YES;
    _sc.backgroundColor = [UIColor redColor];
    [self.view addSubview:_sc];
    
    // 在滚动视图上添加tableView
    [self addTableView];
}
#pragma mark --- UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_sc.contentOffset.x == 0) {
        _segmented.selectedSegmentIndex=0;
    }else{
        _segmented.selectedSegmentIndex=1;
    }
}
#pragma mark --- 添加tableView
- (void)addTableView{
    self.tableView1 = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 0 , WIDTH , HEIGHT -64) style:UITableViewStylePlain];
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
//    _tableView1.showsVerticalScrollIndicator = NO;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView1.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
    
    [_sc addSubview:self.tableView1];
    
    self.tableView2=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH , HEIGHT -64) style:UITableViewStylePlain];
    self.tableView2.delegate=self;
    self.tableView2.dataSource=self;
//    _tableView2.showsVerticalScrollIndicator=NO;
    self.tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView2.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
    
    [_sc addSubview:self.tableView2];
//    // 添加刷新和加载
    
    
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData2)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView2.header = header;
    [header beginRefreshing];
//    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData2)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    _tableView2.footer = footer;
    
    [self addRefreshWith:_tableView1];
    _tableView1.scrollsToTop = NO;
}
- (void)addRefreshWith:(UITableView *)tableView{
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    tableView.header = header;
    [header beginRefreshing];
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    tableView.footer = footer;
}

#pragma mark --- 添加表格的头视图
- (void)addTableViewHeader{
    
    NSInteger count = _forumModel.section.count;   // 版块的个数
    NSInteger rows =   count / 5 + 1;   // 版块的行数
//    NSLog(@"%lu", rows);
    CGFloat headerH = (74+18+24+24) * 0.5 * rows + (28+38+20+83) * 0.5 + (rows-1) * 10;
    HeaderViewInTalking * headerView = [[HeaderViewInTalking alloc] initWithFrame:CGRectMake(0, 0, WIDTH, headerH) WithModel:_forumModel];
    headerView.delegate = self;
    headerView.backgroundColor = [UIColor whiteColor];
//    headerView.backgroundColor = [UIColor redColor];
    _tableView1.tableHeaderView = headerView;
}
#pragma mark--- 加载和刷新
- (void)loadNewData{
    
    [DataTool getCommunityDataWithStr:ForumURL parameters:nil success:^(id responseObject) {
        [_tableView1.header endRefreshing];
        
        _forumModel = responseObject;
        
//        NSLog(@"%@", responseObject);
        ForumModel * forumModel = [[ForumModel alloc] init];
        forumModel = responseObject;
//        NSLog(@"%@", forumModel);
        NSArray * hotArr = forumModel.hot;
        
//        NSLog(@"%@", hotArr);
        // 字典数组转模型数组
        NSArray * hotModelArr = [PostsModel objectArrayWithKeyValuesArray:hotArr];
        NSMutableArray * arr = [NSMutableArray array];
        for (PostsModel * model in hotModelArr) {
            PostFrameModel * frameModel = [[PostFrameModel alloc] init];
            frameModel.postsModel = model;
            [arr addObject:frameModel];
        }
        self.dataSource1 = arr;
        
//        NSLog(@"%@", self.dataSource1);
        // 添加头视图
        [self addTableViewHeader];
        
        [self.tableView1 reloadData];

    } failure:^(NSError * error) {
       
        NSLog(@"获取论坛首页数据出错:%@", error);
        [self addTableViewHeader];
    }];
    
    
    
}
#pragma mark --- 圈子获取数据
- (void)loadNewData2{
    
    [DataTool getGroupDataWithStr:GroupURL parameters:nil success:^(id responseObject) {
        [self.tableView2.header endRefreshing];
        
//        NSLog(@"获取圈子页数据：%@", responseObject);
        CircleModel * cirModel = responseObject;
        
        _page = cirModel.page;
        
        self.dataSource2 = (NSMutableArray *)cirModel.modelArr;
        NSLog(@"%lu", self.dataSource2.count);
        [_tableView2 reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取圈子页数据出错：%@", error);
    }];
}
- (void)loadMoreData2{
    
    // http://dipaiapp.replays.net/app/circle/list
    NSString * url = [GroupURL stringByAppendingString:[NSString stringWithFormat:@"/%@", _page]];
    
//    NSLog(@"%@", url);
    
    [DataTool getGroupDataWithStr:url parameters:nil success:^(id responseObject) {
        [self.tableView2.footer endRefreshing];
        
//        NSLog(@"%@", responseObject);
        CircleModel * cirModel = responseObject;
        if ([cirModel.modelArr isKindOfClass:[NSNull class]]) {
            self.tableView2.footer.state = MJRefreshStateNoMoreData;
//            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了"];
        }else{
            for (GroupModel * model in cirModel.modelArr) {
                [self.dataSource2 addObject:model];
                
            }
            _page = cirModel.page;
        }
        
        [self.tableView2 reloadData];
        
    } failure:^(NSError * error) {
        
        NSLog(@"获取圈子页数据出错：%@", error);
        [_tableView2.footer endRefreshing];
    }];
}

- (void)loadMoreData{
    [_tableView1.footer endRefreshing];
    _tableView1.footer.state = MJRefreshStateNoMoreData;
}

#pragma mark --- HeaderViewInTalkingDelegate
- (void)turnPageToSomeSectionWithURL:(NSString *)url andSectionModel:(SectionModel *)model{
 
    SectionVC * sectionVC = [[SectionVC alloc] init];
    sectionVC.hidesBottomBarWhenPushed = YES;
    sectionVC.wapurl = url;
    sectionVC.titleStr = model.name;
    sectionVC.sectionModel = model;
    [self.navigationController pushViewController:sectionVC animated:YES];
}
#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView2) {
        return self.dataSource2.count;
    } else{
        return self.dataSource1.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView2) { // 如果是关注页面
        // 分两种情况  1:帖子  2:回复
        GroupModel * groupModel = self.dataSource2[indexPath.row];
        
//        NSLog(@"%@", groupModel.type);
        if ([groupModel.type isEqualToString:@"0"]) {   // 帖子
            
            GrpPostFrmModel * frameModel = [[GrpPostFrmModel alloc] init];
            frameModel.groupModel = groupModel;
            GroupCell * cell = [GroupCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.postFrmModel = frameModel;;
            return cell;
            
        }else{  // 回复
            GroupFrameModel * frameModel = [[GroupFrameModel alloc] init];
            frameModel.groupModel = groupModel;
            GroupCell * cell = [GroupCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.frameModel = frameModel;
            return cell;
        }
        
       
    }else{  // 热门讨论页面   单元格的内容和帖子是一样的
        PostCell * cell = [PostCell cellWithTableView:tableView];
        cell.delegate = self;
        
//        NSLog(@"%@", self.dataSource1);
        PostFrameModel * frameModel = self.dataSource1[indexPath.row];
        cell.frameModel = frameModel;
        return cell;
    }
    
}
#pragma mark --- PostCellDelegate 热门讨论
// 点击头像的点击事件
//- (void)tableViewCell:(PostCell *)cell didClickFaceWith:(PostsModel *)model{
//    NSLog(@"////");
//}


#pragma mark -- GroupCellDelegate 圈子
// 点击头像的点击事件
- (void)tableViewCell:(GroupCell *)cell didClickFaceWith:(GroupModel *)model{
    NSLog(@"跳转到个人主页...");

    StarVC * starVC = [[StarVC alloc] init];
    AnyBodyVC * anyVC = [[AnyBodyVC alloc] init];
    if ([cell isKindOfClass:[PostCell class]]) {    // 热门讨论页
        NSLog(@"postcell");
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
        
    }else{  // 圈子页
        NSLog(@"groupcell");
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
    
}


#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView2) { // 如果是圈子
        GroupModel * groupModel = self.dataSource2[indexPath.row];
        if ([groupModel.type isEqualToString:@"1"]) {
            GroupFrameModel * frameModel = [[GroupFrameModel alloc] init];
            frameModel.groupModel = groupModel;
            return frameModel.cellHeight;
        }
        else{
            GrpPostFrmModel * frameModel = [[GrpPostFrmModel alloc] init];
            frameModel.groupModel = groupModel;
            return frameModel.cellHeight;
        }
        
    }else{
        PostFrameModel * model = self.dataSource1[indexPath.row];
        return  model.cellHeight;
    }
}

#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
    if (tableView == _tableView2) { // 圈子页的点击事件
        NSLog(@"...");
        // 跳转到帖子详细页面
        PostDetailVC * postDetailVC = [[PostDetailVC alloc] init];
        GroupModel * model = self.dataSource2[indexPath.row];
                
        // 资讯页  视频页
        DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
        VideoViewController * videoVC = [[VideoViewController alloc] init];
        // 页面跳转有两种情况：1.跳转到帖子详情页   2.跳转到一个网页详情或视频详情
        // http://dipaiapp.replays.net/app/art/view/2/5099
//        NSLog(@"wapurl---%@", model.wapurl);
//        NSLog(@"type----%@", model.type);
        

        if ([model.wapurl rangeOfString:@"art/view/2"].location != NSNotFound || [model.wapurl rangeOfString:@"art/view/4"].location != NSNotFound) {   // 跳到网页详情页
            NSLog(@"资讯");
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.url = model.wapurl;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if ([model.wapurl rangeOfString:@"art/view/11"].location != NSNotFound){  // 跳到视频详情页
            NSLog(@"视频");
            videoVC.hidesBottomBarWhenPushed = YES;
            videoVC.url = model.wapurl;
            [self.navigationController pushViewController:videoVC animated:YES];
        } else if([model.wapurl rangeOfString:@"forum/view"].location != NSNotFound){    // 跳到帖子详情页
            postDetailVC.hidesBottomBarWhenPushed = YES;
            postDetailVC.wapurl = model.wapurl;
            [self.navigationController pushViewController:postDetailVC animated:YES];
        }else if ([model.wapurl rangeOfString:@"club/view/5"].location != NSNotFound){ // 跳转到赛事详情页页面
            
            // 赛事详情页分为两种情况：1.有直播  2.没有直播
            MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
            detailVC.wapurl = model.wapurl;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
        else{
            NSLog(@"%@", model.wapurl);
        }

    }else{  // 热门讨论的点击事件
        PostDetailVC * postDetailVC = [[PostDetailVC alloc] init];
        PostFrameModel * model = self.dataSource1[indexPath.row];
        postDetailVC.wapurl = model.postsModel.wapurl;
//        NSLog(@"%@", model.postsModel.wapurl);
        
        postDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postDetailVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
