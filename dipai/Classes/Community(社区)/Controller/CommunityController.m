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
}
@end

@implementation CommunityController

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
    
    NSLog(@"%f", HEIGHT);
    
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
    [self addRefreshWith:_tableView1];
    [self addRefreshWith:_tableView2];
    
    _tableView1.scrollsToTop = NO;
//    _tableView2.scrollsToTop = NO;
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
    NSLog(@"%lu", rows);
    CGFloat headerH = (74+18+24) * 0.5 * rows + (28+38+20+83) * 0.5 + (rows-1) * 10;
    HeaderViewInTalking * headerView = [[HeaderViewInTalking alloc] initWithFrame:CGRectMake(0, 0, WIDTH, headerH) WithModel:_forumModel];
    headerView.delegate = self;
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView1.tableHeaderView = headerView;
}
#pragma mark--- 加载和刷新
- (void)loadNewData{
    
    [DataTool getCommunityDataWithStr:CommunityURL parameters:nil success:^(id responseObject) {
        [_tableView1.header endRefreshing];
        
        _forumModel = responseObject;
        
        NSLog(@"%@", _forumModel.section[0]);
        
        [self addTableViewHeader];
        [_tableView1 reloadData];
    } failure:^(NSError * error) {
       
        NSLog(@"获取论坛首页数据出错:%@", error);
        [self addTableViewHeader];
    }];
    
    
    [_tableView2.header endRefreshing];
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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"tournamentCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        //        NSLog(@"...");
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row];;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
