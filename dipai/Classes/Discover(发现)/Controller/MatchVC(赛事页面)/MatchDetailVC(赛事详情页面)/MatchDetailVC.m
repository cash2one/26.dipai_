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
// 直播信息模型
#import "LiveModel.h"


//  直播单元格
#import "LiveCell.h"

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

@property (nonatomic, strong) MatchingHeader * headerView;
/**
 *  赛事模型
 */
@property (nonatomic, strong) MatchingModel * matchingModel;

/**
 *  当前赛事
 */
@property (nonatomic, strong) UILabel * dayLbl;
/**
 *  当前赛事按钮
 */
@property (nonatomic, strong) UIButton * dayBtn;
/**
 *  赛事菜单
 */
@property (nonatomic, strong) UIView * menuView;

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
//    NSLog(@"flag:%d", self.flag);
    
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
//    NSLog(@"%@", _matchingModel.match_state);
    headerView.stateLbl.text = [NSString stringWithFormat:@"比赛状态:%@", _matchingModel.match_state];
    headerView.blindNum.text = _matchingModel.blind;
    headerView.score.text = _matchingModel.score;
    headerView.players.text = _matchingModel.player;
    [self.view addSubview:headerView];
    _headerView = headerView;
    
    //
    UIView * dayView = [[UIView alloc] init];
    dayView.layer.masksToBounds = YES;
    dayView.layer.cornerRadius = 2;
    dayView.layer.borderWidth = 0.5;
    dayView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [headerView addSubview:dayView];
    [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(36 * IPHONE6_W_SCALE);
        make.top.equalTo(headerView.mas_top).offset(12 * IPHONE6_W_SCALE);
        make.width.equalTo(@(148*0.5*IPHONE6_W_SCALE));
        make.height.equalTo(@(21*IPHONE6_H_SCALE));
    }];
    
    // 赛事day
    UILabel * dayLbl = [[UILabel alloc] init];
    dayLbl.font = Font13;
    dayLbl.textColor = [UIColor whiteColor];
    [dayView addSubview:dayLbl];
    [dayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dayView.mas_left).offset(12.5 * IPHONE6_W_SCALE);
        make.top.equalTo(dayView.mas_top);
        make.bottom.equalTo(dayView.mas_bottom);
        make.right.equalTo(dayView.mas_right);
    }];
    
    UIImageView * picView = [[UIImageView alloc] init];
//    picView.userInteractionEnabled = YES;
    picView.image = [UIImage imageNamed:@"icon_xialasanjiao"];
    [dayView addSubview:picView];
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dayView.mas_right).offset(-7*IPHONE6_W_SCALE);
        make.top.equalTo(dayView.mas_top).offset(8.5*IPHONE6_W_SCALE);
        make.width.equalTo(@(6 * IPHONE6_W_SCALE));
        make.height.equalTo(@(4 * IPHONE6_W_SCALE));
    }];
    
    UIButton * dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dayView addSubview:dayBtn];
    [dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dayView.mas_left);
        make.right.equalTo(dayView.mas_right);
        make.top.equalTo(dayView.mas_top);
        make.bottom.equalTo(dayView.mas_bottom);
    }];
//    dayBtn.backgroundColor = [UIColor redColor];
    [dayBtn addTarget:self action:@selector(clickDayBtn) forControlEvents:UIControlEventTouchUpInside];
    _dayBtn = dayBtn;
    
    NSArray * appArr = _matchingModel.app_live;
    LiveModel * liveModel = appArr[0];
    dayLbl.text = liveModel.name;
    
    
    
}
#pragma mark --- 添加下拉菜单
- (void)addMenuWithNum:(NSInteger)count{
    
}

#pragma mark ---  clickDayBtn
- (void)clickDayBtn{
    
    // 这样是很消耗内存的，需要优化一下
    
    NSLog(@".....");
    UIView * menuView = [[UIView alloc] init];
    // 添加下拉菜单
    [_headerView addSubview:menuView];
    _menuView = menuView;
    NSInteger count = _matchingModel.app_live.count;    // 直播数量
//    NSInteger count = 3;
    CGFloat menuH = (52+62*(count-1))*0.5;
    menuView.frame = CGRectMake(36*IPHONE6_W_SCALE, 12*IPHONE6_H_SCALE, 148*0.5*IPHONE6_W_SCALE, menuH);
    
    menuView.layer.masksToBounds = YES;
    menuView.layer.cornerRadius = 2;
    menuView.layer.borderWidth = 0.5;
    menuView.layer.borderColor = [[UIColor whiteColor] CGColor];
    menuView.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.9];
    
    UIImageView * picView = [[UIImageView alloc] init];
    [menuView addSubview:picView];
    picView.image = [UIImage imageNamed:@"icon_xialasanjiao"];
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(menuView.mas_right).offset(-7*IPHONE6_W_SCALE);
        make.top.equalTo(menuView.mas_top).offset(17*0.5*IPHONE6_H_SCALE);
        make.width.equalTo(@(6*IPHONE6_W_SCALE));
        make.height.equalTo(@(4*IPHONE6_W_SCALE));
    }];
    
    // 分割线
    for (int i = 0; i < count-1; i ++) {
        UIView * separateView = [[UIView alloc] init];
        [menuView addSubview:separateView];
        CGFloat y = 26*IPHONE6_H_SCALE;
        separateView.frame = CGRectMake(0, y + i*(31+0.5), 148*0.5*IPHONE6_W_SCALE, 0.5);
        separateView.backgroundColor = [UIColor colorWithRed:58 / 255.f green:58 / 255.f blue:58 / 255.f alpha:1];
    }
    for (int i = 0; i < count; i ++) {
        UILabel * dayLbl = [[UILabel alloc] init];
        dayLbl.font = Font13;
        dayLbl.textColor = [UIColor whiteColor];
//        dayLbl.backgroundColor = [UIColor redColor];
        [menuView addSubview:dayLbl];
        CGFloat dayLblX = 12.5*IPHONE6_W_SCALE;
        CGFloat dayLblW = (148-25)*0.5*IPHONE6_W_SCALE;
        dayLbl.frame = CGRectMake(dayLblX, 7+i*(18+13), dayLblW, 13);
        LiveModel * model = _matchingModel.app_live[i];
        dayLbl.text = model.name;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuView addSubview:btn];
//        btn.backgroundColor = [UIColor redColor];
        btn.tag = i;
        btn.frame = CGRectMake(0, 0 + i*(26*IPHONE6_H_SCALE), 148*0.5*IPHONE6_W_SCALE, 26*IPHONE6_H_SCALE);
        [btn addTarget:self action:@selector(changeDay:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
// 点击按钮观看不同的比赛
- (void)changeDay:(UIButton *)btn{
//    NSLog(@"%lu", btn.tag);
    NSInteger index = btn.tag;
    [_menuView removeFromSuperview];
    LiveModel * model = _matchingModel.app_live[index];
    _dayLbl.text = model.name;
    
    
    
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
    
    LiveModel * liveModel = _matchingModel.app_live[0];
    [DataTool getLiveDataWithStr:liveModel.wapurl parameters:nil success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        [_tableView1.header endRefreshing];
    } failure:^(NSError * error) {
        
        NSLog(@"获取直播信息出错：%@", error);
        [_tableView1.header endRefreshing];
    }];
    
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
// 单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        return 2;
    }else if (tableView == _tableView2){
        return 2;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView1) {
        LiveCell * cell = [LiveCell cellWithTableView:tableView];
        return cell;
    } else if (tableView == _tableView2){
        LiveCell * cell = [LiveCell cellWithTableView:tableView];
        return cell;
    } else{
        LiveCell * cell = [LiveCell cellWithTableView:tableView];
        return cell;
    }
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) {
        
        return 100;
    } else if (tableView == _tableView2){
        return 100;
    } else{
        return 100;
    }
}


/***********请求网路数据******************/
- (void)getData{
//    NSLog(@"%@", self.wapurl);
    [DataTool getMatchDataInDetailWithStr:self.wapurl parameters:nil success:^(id responseObject) {
        
//        NSLog(@"%@", responseObject);
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
