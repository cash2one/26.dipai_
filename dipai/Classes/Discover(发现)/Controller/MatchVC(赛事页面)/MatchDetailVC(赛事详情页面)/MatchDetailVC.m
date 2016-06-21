//
//  MatchDetailVC.m
//  dipai
//
//  Created by 梁森 on 16/6/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MatchDetailVC.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 自定义头视图
#import "HeaderViewInMatch.h"
// 进行中赛事的头视图
#import "MatchingHeader.h"

// 比赛模型
#import "EndMatchModel.h"
// 赛事详情页模型(进行中的赛事)
#import "MatchingModel.h"

#import "DataTool.h"

#import "Masonry.h"
@interface MatchDetailVC ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    UISegmentedControl *_segmented;
    // 滚动视图
    UIScrollView *_sc;
}
// 三个表格
@property (nonatomic, strong) UITableView * tableView1;
@property (nonatomic, strong) UITableView * tableView2;
@property (nonatomic, strong) UITableView * tableView3;

/**
 *  自定义的头视图
 */
@property (nonatomic, strong) MatchingHeader * headerView1;
@property (nonatomic, strong) HeaderViewInMatch * headerView2;
/**
 *  赛事模型
 */
@property (nonatomic, strong) MatchingModel * matchingModel;
@end

@implementation MatchDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setUpNavigationBar];
    
    // 添加头视图
    [self addHeaderView];
    
    // 获取数据
    [self getData];
    
}
#pragma mark --- 设置导航栏
- (void)setUpNavigationBar{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui_baise"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 添加头视图
- (void)addHeaderView{
    
    // 每次进来都会调用此方法
    NSLog(@"flag:%d", self.flag);
    
    if (self.flag == 1) {   // 即将开始没有直播
        [self addHeaderView2];
        // 添加分段控件
        [self addSegmentWithHeight:290*0.5*IPHONE6_H_SCALE];
    } else{
        [DataTool getMatchDataInDetailWithStr:self.wapurl parameters:nil success:^(id responseObject) {
            
            _matchingModel = responseObject;
            if (_matchingModel.app_live.count > 0) {    // 有直播
                NSLog(@"有直播");
                [self addHeaderView1];
                [self addSegmentWithHeight:326*0.5*IPHONE6_H_SCALE];
            } else{ // 没有直播
                NSLog(@"没有直播");
                [self addHeaderView2];
                // 添加分段控件
                [self addSegmentWithHeight:290*0.5*IPHONE6_H_SCALE];
            }
        } failure:^(NSError * error) {
            
            NSLog(@"获取赛事详情数据出错%@", error);
        }];
    }
}
#pragma mark --- 添加头视图的子视图
- (void)addHeaderView1{
    
    // 进行中和已结束页面是不固定的，可能有直播也可能没有直播
    MatchingHeader * headerView = [[MatchingHeader alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 326 * 0.5 * IPHONE6_H_SCALE)];
    // 设置数据
    headerView.titleLbl.text = _matchingModel.title;
    NSLog(@"%@", _matchingModel.match_state);
    headerView.stateLbl.text = [NSString stringWithFormat:@"比赛状态:%@", _matchingModel.match_state];
    headerView.blindNum.text = _matchingModel.blind;
    headerView.score.text = _matchingModel.score;
    headerView.players.text = _matchingModel.player;
    [self.view addSubview:headerView];
}

- (void)addHeaderView2{
    
    // 只有即将开始的页面是固定的
    HeaderViewInMatch * headerView = [[HeaderViewInMatch alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 290 * 0.5 * IPHONE6_H_SCALE)];
    headerView.matchModel = self.matchModel;
    [self.view addSubview:headerView];
}



#pragma mark --- 添加分段控件 
- (void)addSegmentWithHeight:(CGFloat)height{
    
    // 分段控件
    _segmented = [[UISegmentedControl alloc]initWithItems:@[@"赛事直播",@"大家在说",@"赛事资讯"]];
//    _segmented.selectedSegmentIndex = 0;
    // 被选中时的背景色
    _segmented.tintColor = [UIColor colorWithRed:51 / 255.f green:51 / 255.f blue:51 / 255.f alpha:1];
    _segmented.backgroundColor = [UIColor blackColor];
    
    // 被选中时的字体的颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:Font13} forState:UIControlStateSelected];
    // 正常情况下的字体颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:Font13} forState:UIControlStateNormal];
    
    _segmented.frame=CGRectMake(0, height , WIDTH, 40 * IPHONE6_H_SCALE);
    
    if (height == 290*0.5*IPHONE6_H_SCALE) {    // 没有直播
        _segmented.selectedSegmentIndex = 2;
    } else{ // 有直播
        _segmented.selectedSegmentIndex = 0;
    }
    
    // 为分段控件添加点事件
    [_segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmented];
    
    
    // 添加滚动视图
    [self addScrollView];
}
#pragma mark - 分段控件的点击事件
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

#pragma mark --- 添加滚动视图
- (void)addScrollView {
    CGFloat scH = CGRectGetMaxY(_segmented.frame);
    _sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, scH, WIDTH , HEIGHT - 64 - scH)];
    _sc.contentSize=CGSizeMake(WIDTH * 3 , HEIGHT - 64 - scH);
    _sc.delegate=self;
    _sc.bounces=NO;
    _sc.pagingEnabled=YES;
    _sc.backgroundColor = [UIColor redColor];
    
    if (_segmented.selectedSegmentIndex == 0) {
        _sc.contentOffset = CGPointMake(0, 0);
    }
    if (_segmented.selectedSegmentIndex == 2) {
        _sc.contentOffset=CGPointMake( WIDTH * 2, 0);
    }
    
    // 添加滚动视图
    [self.view addSubview:_sc];
    
    // 在滚动视图上添加tableView
    [self addTableView];
}
#pragma mark --- 添加tableView
- (void)addTableView{
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 0 , WIDTH , HEIGHT - 64) style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.showsVerticalScrollIndicator = NO;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!_matchingModel.app_live.count > 0) {
        UIImageView * picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _sc.frame.size.height)];
        picView.image = [UIImage imageNamed:@"meiyouzhibo"];
        [_sc addSubview:picView];
    }else{
         [_sc addSubview:_tableView1];
    }
    
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
    [footer setTitle:@"没有更多赛事" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    tableView.footer = footer;
}

#pragma mark --- 加载和刷新
// 刷新
- (void)loadNewData{
    
    [_tableView1.header endRefreshing];
    [_tableView2.header endRefreshing];
    [_tableView3.header endRefreshing];
    
}
// 加载
- (void)loadMoreData{
    [_tableView1.footer endRefreshing];
    [_tableView2.footer endRefreshing];
    [_tableView3.footer endRefreshing];
    
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

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"tournamentCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        //        NSLog(@"...");
    }
    
    return cell;
}


/***********请求网路数据******************/
- (void)getData{
    NSLog(@"%@", self.wapurl);
    [DataTool getMatchDataInDetailWithStr:self.wapurl parameters:nil success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        _matchingModel = responseObject;
        // 设置数据
//        [self setData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取赛事详情数据出错%@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
