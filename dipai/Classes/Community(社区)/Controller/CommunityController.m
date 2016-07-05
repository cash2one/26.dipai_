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

// 圈子模型
#import "GroupModel.h"
// 圈子返回数据模型
#import "CircleModel.h"
// 圈子单元格
#import "GroupCell.h"

#import "GrpPostCell.h"
#import "GrpPostFrmModel.h"

#import "SVProgressHUD.h"

// VM
#import "GroupFrameModel.h"
@interface CommunityController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, HeaderViewInTalkingDelegate>
{
    UISegmentedControl *_segmented;
    // 滚动视图
    UIScrollView *_sc;
    // 对应分段控件的三个tableView
    UITableView *_tableView1;
    UITableView *_tableView2;
    UITableView *_tableView3;
    
    // 论坛模型
    ForumModel * _forumModel;
    
    // 圈子获取更多数据时发送的一个标识
    NSString * _page;
}

// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource2;
@end

@implementation CommunityController

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
    _segmented = [[UISegmentedControl alloc]initWithItems:@[@"论坛",@"圈子"]];
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
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 0 , WIDTH , HEIGHT -64) style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.showsVerticalScrollIndicator = NO;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView1.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
    
    [_sc addSubview:_tableView1];
    
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH , HEIGHT -64) style:UITableViewStylePlain];
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    _tableView2.showsVerticalScrollIndicator=NO;
    _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView2.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
    
    [_sc addSubview:_tableView2];
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
    [footer setTitle:@"没有更多赛事" forState:MJRefreshStateNoMoreData];
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
    [footer setTitle:@"没有更多赛事" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    tableView.footer = footer;
}

#pragma mark --- 添加表格的头视图
- (void)addTableViewHeader{
    
    NSInteger count = _forumModel.section.count;   // 版块的个数
    NSInteger rows =   count / 5 + 1;   // 版块的行数
//    NSLog(@"%lu", rows);
    CGFloat headerH = (74+18+24) * 0.5 * rows + (28+38+20+83) * 0.5 + (rows-1) * 10;
    HeaderViewInTalking * headerView = [[HeaderViewInTalking alloc] initWithFrame:CGRectMake(0, 0, WIDTH, headerH) WithModel:_forumModel];
    headerView.delegate = self;
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView1.tableHeaderView = headerView;
}
#pragma mark--- 加载和刷新
- (void)loadNewData{
    
    [DataTool getCommunityDataWithStr:ForumURL parameters:nil success:^(id responseObject) {
        [_tableView1.header endRefreshing];
        
        _forumModel = responseObject;
        
//        NSLog(@"%@", _forumModel.section[0]);
        
        [self addTableViewHeader];
        [_tableView1 reloadData];

    } failure:^(NSError * error) {
       
        NSLog(@"获取论坛首页数据出错:%@", error);
        [self addTableViewHeader];
    }];
    
    
    
}
#pragma mark --- 圈子获取数据
- (void)loadNewData2{
    
    [DataTool getGroupDataWithStr:GroupURL parameters:nil success:^(id responseObject) {
        [_tableView2.header endRefreshing];
        
//        NSLog(@"获取圈子页数据：%@", responseObject);
        
        NSMutableArray * frameArr = [NSMutableArray array];
        
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
        [_tableView2.footer endRefreshing];
        
        CircleModel * cirModel = responseObject;
        
        
        
        if ([cirModel.page isKindOfClass:[NSNull class]]) {
            _tableView2.footer.state = MJRefreshStateNoMoreData;
            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了"];
        }
        for (GroupModel * model in cirModel.modelArr) {
            [self.dataSource2 addObject:model];
            
        }
        _page = cirModel.page;
        [_tableView2 reloadData];
        
    } failure:^(NSError * error) {
        
        NSLog(@"获取圈子页数据出错：%@", error);
    }];
}

- (void)loadMoreData{
    [_tableView1.footer endRefreshing];
    [_tableView2.footer endRefreshing];
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
        return 20;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView2) { // 如果是圈子页面
        // 分两种情况  1:帖子  2:回复
        GroupModel * groupModel = self.dataSource2[indexPath.row];
        
        GrpPostCell * gpcell =(GrpPostCell *) [GrpPostCell cellWithTableView:tableView];
        
//        NSLog(@"%@", gpcell);
        if ([groupModel.type isEqualToString:@"0"]) {
            
            GrpPostFrmModel * frameModel = [[GrpPostFrmModel alloc] init];
            frameModel.groupModel = groupModel;
            GroupCell * cell = [GroupCell cellWithTableView:tableView];
            cell.postFrmModel = frameModel;;
            return cell;
            
        }else{
            GroupFrameModel * frameModel = [[GroupFrameModel alloc] init];
            frameModel.groupModel = groupModel;
            GroupCell * cell = [GroupCell cellWithTableView:tableView];
            cell.frameModel = frameModel;
            return cell;
        }
        
       
    }else{
        static NSString * cellID = @"tournamentCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            //        NSLog(@"...");
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row];;
        return cell;
    }
    
}

#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView2) {
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
        return 100;
    }
}

#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView2) {
        NSLog(@"...");
        // 跳转到帖子详细页面
        PostDetailVC * postDetailVC = [[PostDetailVC alloc] init];
        GroupModel * model = self.dataSource2[indexPath.row];
        postDetailVC.wapurl = model.wapurl;
        
        NSLog(@"type----%@", model.type);
        
        postDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postDetailVC animated:YES];
    }else{
        NSLog(@"...");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
