//
//  MatchVC.m
//  dipai
//
//  Created by 梁森 on 16/6/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MatchVC.h"

//刷新和加载
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 赛事模型
#import "MatchModel.h"
// 结束赛事模型
#import "EndMatchModel.h"

// 赛事单元格
#import "MatchCell.h"

// 赛事详情页面
#import "MatchDetailVC.h"

#import "SVProgressHUD.h"
#import "DataTool.h"
@interface MatchVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    // 分段控件，显示：进行中、即将开始、已结束
    UISegmentedControl *_segmented;
    // 滚动视图
    UIScrollView *_sc;
    // 对应分段控件的三个tableView
    UITableView *_tableView1;
    UITableView *_tableView2;
    UITableView *_tableView3;
}

// 三个表格
@property (nonatomic, strong) UITableView * tableView1;
@property (nonatomic, strong) UITableView * tableView2;
@property (nonatomic, strong) UITableView * tableView3;
// 三个tableView的数据源
@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)NSMutableArray *dataArray2;
@property(nonatomic,strong)NSMutableArray *dataArray3;

@end

@implementation MatchVC

- (NSMutableArray *)dataArray1{
    if (_dataArray1 == nil) {
        _dataArray1 = [NSMutableArray array];
    }
    return _dataArray1;
}
- (NSMutableArray *)dataArray2{
    if (_dataArray2 == nil) {
        _dataArray2 = [NSMutableArray array];
    }
    return _dataArray2;
}

- (NSMutableArray *)dataArray3{
    if (_dataArray3 == nil) {
        _dataArray3 = [NSMutableArray array];
    }
    return _dataArray3;
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_beijingditu"] forBarMetrics:UIBarMetricsDefault];
//    
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏
    [self setUpNavigationBar];
    
    // 添加滚动视图
    [self addScrollView];
    
}
/******************************搭建界面*************************/
#pragma mark --- 设置导航栏
- (void)setUpNavigationBar
{
//    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui_baise"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSegmentControl];
    
}
#pragma mark --- 添加分段控件
- (void)addSegmentControl{
    // 分段控件
    _segmented = [[UISegmentedControl alloc]initWithItems:@[@"进行中",@"即将开始",@"已结束"]];
    _segmented.selectedSegmentIndex = 0;
    // 被选中时的背景色
    _segmented.tintColor = [UIColor blackColor];
//     _segmented.tintColor = [UIColor colorWithRed:51 / 255.f green:51 / 255.f blue:51 / 255.f alpha:1];
//    _segmented.layer.masksToBounds = YES;
//    _segmented.layer.cornerRadius = 0.3;
    // 未被选中的背景色
    _segmented.backgroundColor = [UIColor blackColor];
    
    // 被选中时的字体的颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateSelected];
    // 正常情况下的字体颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
    _segmented.frame=CGRectMake( 0 , 0, 250 * IPHONE6_W_SCALE , 44 );
    // 为分段控件添加点事件
    [_segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmented;
}
// 分段控件的点击事件
-(void)segmentedClick:(UISegmentedControl*)seg{
    
    // 根据情况改变滚动视图的偏移
    if (seg.selectedSegmentIndex == 0) {
        _sc.contentOffset=CGPointMake(0, 0);
    }else if (seg.selectedSegmentIndex == 1){
        _sc.contentOffset=CGPointMake( WIDTH , 0);
    }else{
        _sc.contentOffset=CGPointMake( WIDTH * 2, 0);
    }
}
#pragma mark --- 返回上一个视图控制器
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 添加滚动视图
- (void)addScrollView {
    _sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH , HEIGHT - 64)];
    _sc.contentSize=CGSizeMake(WIDTH * 3 , HEIGHT - 64);
    _sc.delegate=self;
    _sc.bounces=NO;
    _sc.pagingEnabled=YES;
    _sc.backgroundColor = [UIColor redColor];
    [self.view addSubview:_sc];
    
    // 在滚动视图上添加tableView
    [self addTableView];
}
#pragma mark --- UIScrollViewDelegate

#pragma mark --- 添加tableView
- (void)addTableView{
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 0 , WIDTH , HEIGHT - 64) style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.showsVerticalScrollIndicator = NO;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_sc addSubview:_tableView1];
    
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH , HEIGHT - 64) style:UITableViewStylePlain];
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    _tableView2.showsVerticalScrollIndicator=NO;
    _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    [_sc addSubview:_tableView2];
    
    _tableView3=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH * 2, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    _tableView3.delegate=self;
    _tableView3.dataSource=self;
    _tableView3.showsVerticalScrollIndicator=NO;
    _tableView3.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_sc addSubview:_tableView3];
    
    // 添加刷新和加载
    [self addRefreshWith:_tableView1];
    [self addRefreshWith:_tableView2];
    [self addRefreshWith:_tableView3];
}
#pragma mark --- 添加刷新和加载
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

#pragma mark --- 加载和刷新
// 刷新
- (void)loadNewData{
    
    NSString * url1 = [MatchURL stringByAppendingString:[NSString stringWithFormat:@"/0"]];
     NSString * url2 = [MatchURL stringByAppendingString:[NSString stringWithFormat:@"/1"]];
     NSString * url3 = [MatchURL stringByAppendingString:[NSString stringWithFormat:@"/2"]];
    // 获取第一个列表的数据
    [DataTool getMatchDataWithStr:url1 parameters:nil success:^(id responseObject) {
        [_tableView1.header endRefreshing];
        [_tableView1.footer endRefreshing];
//        NSLog(@"%@", responseObject);
        
        self.dataArray1 = responseObject;
        [_tableView1 reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取第一个表格中的数据出错%@", error);
    }];
    
    // 获取第二个列表的数据
    [DataTool getMatchDataWithStr:url2 parameters:nil success:^(id responseObject) {
        [_tableView2.header endRefreshing];
        [_tableView2.footer endRefreshing];
        self.dataArray2 = responseObject;
//        NSLog(@"%@", responseObject);
        [_tableView2 reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取第二个表格中的数据出错%@", error);
    }];
    
    // 获取第三个列表的数据
    [DataTool getEndMatchDataWithStr:url3 parameters:nil success:^(id responseObject) {
        [_tableView3.header endRefreshing];
        [_tableView3.footer endRefreshing];
        self.dataArray3 = responseObject;
//        NSLog(@"%@", responseObject);
        [_tableView3 reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取第三个表格中的数据出错%@", error);
    }];
    
}
// 加载
- (void)loadMoreData{
    // 加载更多数据
    
    EndMatchModel * matchModel = [self.dataArray3 lastObject];
    
    NSString * iD = matchModel.iD;
     NSString * url3 = [MatchURL stringByAppendingString:[NSString stringWithFormat:@"/2/%@", iD]];
    [DataTool getEndMatchDataWithStr:url3 parameters:nil success:^(id responseObject) {
        [_tableView3.footer endRefreshing];
                
        if (responseObject == nil) {
//            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了"];
            _tableView3.footer.state = MJRefreshStateNoMoreData;
        }
        [self.dataArray3 addObjectsFromArray:responseObject];
        [_tableView3 reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取更多数据出错%@", error);
    }];
    _tableView1.footer.state = MJRefreshStateNoMoreData;
    _tableView2.footer.state = MJRefreshStateNoMoreData;
    
}

#pragma mark ---  滚动视图结束滚动后
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_sc.contentOffset.x == 0) {
        _segmented.selectedSegmentIndex=0;
    }else if (_sc.contentOffset.x == WIDTH){
        _segmented.selectedSegmentIndex=1;
    }else{
        _segmented.selectedSegmentIndex=2;
    }
}

#pragma mark ---- 代理中方法
#pragma mark --- UITableViewDataSource
// 表格分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView1) {
        return self.dataArray1.count;
    } else if (tableView == _tableView2){
        return self.dataArray2.count;
    } else{
        return 1;   // 只有一个分区
    }
}
// 分区中的单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        MatchModel * matchModel = [self.dataArray1 objectAtIndex:section];
        return matchModel.rows.count;
    } else if (tableView == _tableView2){
        MatchModel * matchModel = [self.dataArray2 objectAtIndex:section];
        return matchModel.rows.count;
    } else{
        return self.dataArray3.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) {
        MatchCell * cell = [MatchCell cellWithTableView:tableView];
        MatchModel * matchModel = [self.dataArray1 objectAtIndex:indexPath.section];
        EndMatchModel * endModel = [matchModel.rows objectAtIndex:indexPath.row];
        cell.matchModel = endModel;
        return cell;
    } else if (tableView == _tableView2){
        MatchCell * cell = [MatchCell cellWithTableView:tableView];
        MatchModel * matchModel = [self.dataArray2 objectAtIndex:indexPath.section];
        EndMatchModel * endModel = [matchModel.rows objectAtIndex:indexPath.row];
        cell.matchModel = endModel;
        return cell;
    }else{
        MatchCell * cell = [MatchCell cellWithTableView:tableView];
        EndMatchModel * endModel = [self.dataArray3 objectAtIndex:indexPath.row];
        
        cell.matchModel = endModel;
        return cell;
    }
    
}

#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
    
    // 只有即将开始详情页是确定的
    if (tableView == _tableView1) { // 进行中
        MatchModel * matchModel = [self.dataArray1 objectAtIndex:indexPath.section];
        EndMatchModel * endModel = [matchModel.rows objectAtIndex:indexPath.row];
        detailVC.wapurl = endModel.wapurl;
    } else if (tableView == _tableView2){   // 即将开始
        MatchModel * matchModel = [self.dataArray2 objectAtIndex:indexPath.section];
        EndMatchModel * endModel = [matchModel.rows objectAtIndex:indexPath.row];
        detailVC.wapurl = endModel.wapurl;
    } else{ // 已结束
        EndMatchModel * endModel = [self.dataArray3 objectAtIndex:indexPath.row];
        
        NSLog(@"%@", endModel.wapurl);
        
        detailVC.wapurl = endModel.wapurl;
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark --- 分区的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40 * IPHONE6_H_SCALE)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel * monthLbl = [[UILabel alloc] initWithFrame:CGRectMake(15 * IPHONE6_W_SCALE, 0, 100, 40 * IPHONE6_H_SCALE)];
        MatchModel * matchModel = [self.dataArray1 objectAtIndex:section];
        monthLbl.text = [matchModel.name stringByAppendingString:@"月"];
        monthLbl.textColor = Color102;
        monthLbl.font = Font15;
        [headerView addSubview:monthLbl];
        return headerView;
    } else if (tableView == _tableView2){
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40 * IPHONE6_H_SCALE)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel * monthLbl = [[UILabel alloc] initWithFrame:CGRectMake(15 * IPHONE6_W_SCALE, 0, 100, 40 * IPHONE6_H_SCALE)];
        MatchModel * matchModel = [self.dataArray2 objectAtIndex:section];
        monthLbl.text = [matchModel.name stringByAppendingString:@"月"];;
        monthLbl.textColor = Color102;
        monthLbl.font = Font15;
        [headerView addSubview:monthLbl];
        return headerView;
    } else{
        return nil;
    }

}

#pragma mark --- 表格头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView3) {
        return 0;
    } else{
        return 40 * IPHONE6_H_SCALE;
    }
    
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 278 * IPHONE6_H_SCALE;
}

/******************************请求数据*************************/
//
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
