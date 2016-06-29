//
//  MyPostsViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/30.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyPostsViewController.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"
#import "Masonry.h"
@interface MyPostsViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    // 滚动视图
    
    // 对应分段控件的三个tableView
    UITableView *_tableView1;
    UITableView *_tableView2;
    UITableView *_tableView3;
}
/**
 *  发帖标签
 */
@property (nonatomic, strong) UILabel * postsLbl;
/**
 *  发帖按钮
 */
@property (nonatomic, strong) UIButton * postBtn;

/**
 *  回复按钮
 */
@property (nonatomic, strong) UIButton * replyBtn;
/**
 *  回复标签
 */
@property (nonatomic, strong) UILabel * replyLbl;

/**
 *  红色的下划线
 */
@property (nonatomic, strong) UIView * redView;

@property (nonatomic, strong) UIScrollView *sc;

@end

@implementation MyPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setNavigationBar];
    
    [self addScrollView];
    // 设置UI
    [self setUpUI];
}

#pragma mark --- 设置导航条
- (void)setNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
    
    // 左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui"] target:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:38/2];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的帖子";
    self.navigationItem.titleView = titleLabel;
    
}
#pragma mark --- 返回
- (void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 设置UI
- (void)setUpUI{
    
    // 添加分割条
    UIView * separateView = [[UIView alloc] init];
    [self.view addSubview:separateView];
    separateView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    separateView.frame = CGRectMake(0, 81 * 0.5 * IPHONE6_H_SCALE, WIDTH, 20 * IPHONE6_H_SCALE);
    
    
    UIView * topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.frame = CGRectMake(0, 0, WIDTH, 81 * 0.5 * IPHONE6_H_SCALE);
    [self.view addSubview:topView];
    
    // 添加我的发帖和我的回复两个标题
    UILabel * postsLbl = [[UILabel alloc] init];
//    postsLbl.backgroundColor = [UIColor redColor];
    postsLbl.font = Font15;
    postsLbl.text = @"我的发帖";
    postsLbl.textColor = Color102;
    [topView addSubview:postsLbl];
    postsLbl.frame = CGRectMake(102 * IPHONE6_W_SCALE, 0, 61 * IPHONE6_W_SCALE, 81 * 0.5 * IPHONE6_H_SCALE);
    _postsLbl = postsLbl;
    
    // 获取发帖按钮
    UIButton * postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:postBtn];
    postBtn.frame = CGRectMake(102 * IPHONE6_W_SCALE, 0, 61 * IPHONE6_W_SCALE, 81 * 0.5 * IPHONE6_H_SCALE);
    [postBtn addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventTouchUpInside];
    postBtn.selected = YES;
    postsLbl.textColor = [UIColor redColor];
    
    UILabel * replyLbl = [[UILabel alloc] init];
    replyLbl.font = Font15;
    replyLbl.text = @"我的回复";
    replyLbl.textColor = Color102;
    [topView addSubview:replyLbl];
    CGFloat replyX = CGRectGetMaxX(postsLbl.frame) + 49 * IPHONE6_W_SCALE;
    replyLbl.frame = CGRectMake(replyX, 0, 61 * IPHONE6_W_SCALE, 81 * 0.5 * IPHONE6_W_SCALE);
    _replyLbl = replyLbl;
    
    // 获取回复按钮
    UIButton * replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    replyBtn.backgroundColor = [UIColor greenColor];
    replyBtn.userInteractionEnabled = YES;
    [topView addSubview:replyBtn];
    replyBtn.frame = CGRectMake(replyX, 0, 61 * IPHONE6_W_SCALE, 81 * IPHONE6_W_SCALE);
    [replyBtn addTarget:self action:@selector(getReplys) forControlEvents:UIControlEventTouchUpInside];
    
    // 红色的下划线
    UIView * redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [topView addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(postsLbl.mas_centerX);
        make.top.equalTo(postsLbl.mas_bottom).offset(-2*IPHONE6_H_SCALE);
        make.width.equalTo(@(158*0.5*IPHONE6_W_SCALE));
        make.height.equalTo(@(2* IPHONE6_H_SCALE));
    }];
    _redView = redView;
    
}

#pragma mark --- 获取我的帖子的点击事件
- (void)getPosts{
    NSLog(@"发帖");
    // 滚动视图的偏移量
    
    [UIView animateWithDuration:0.25 animations:^{
        self.sc.contentOffset = CGPointMake(0, 0);
    } completion:nil];
    // 获取发帖
    [self postAction];
}

- (void)postAction{
    _replyBtn.selected = NO;
    _postsLbl.textColor = [UIColor redColor];
    _replyLbl.textColor = Color102;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGFloat x = CGRectGetMinX(_postsLbl.frame) - 9 * IPHONE6_W_SCALE;
        CGFloat y = CGRectGetMaxY(_postsLbl.frame) - 2*IPHONE6_H_SCALE;
        CGFloat w = 158 * 0.5 * IPHONE6_W_SCALE;
        CGFloat h = 2 * IPHONE6_H_SCALE;
        _redView.frame = CGRectMake(x, y, w, h);
        
    } completion:nil];
}
#pragma mark --- 获取我的回复的点击事件
- (void)getReplys{
    NSLog(@"回复");
    // 加个动画就可以实现滑动了？  这是什么情况？
    [UIView animateWithDuration:0.25 animations:^{
        self.sc.contentOffset = CGPointMake(WIDTH, 0);
    } completion:nil];
    [self replyAction];
}
// 获取回复
- (void)replyAction{
    _postBtn.selected = NO;
    _postsLbl.textColor = Color102;
    _replyLbl.textColor = [UIColor redColor];
    [UIView animateWithDuration:0.25 animations:^{
        
        CGFloat x = CGRectGetMinX(_replyLbl.frame) - 9 * IPHONE6_W_SCALE;
        CGFloat y = CGRectGetMaxY(_replyLbl.frame) - 2*IPHONE6_H_SCALE;
        CGFloat w = 158 * 0.5 * IPHONE6_W_SCALE;
        CGFloat h = 2 * IPHONE6_H_SCALE;
        _redView.frame = CGRectMake(x, y, w, h);
    } completion:nil];
}

#pragma mark --- 添加滚动视图
- (void)addScrollView {
    
    CGFloat scY = 121 * 0.5 * IPHONE6_H_SCALE;
    self.sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, scY, WIDTH , HEIGHT - 64- scY)];
    self.sc.contentSize=CGSizeMake(WIDTH * 2 , HEIGHT - 64-scY);
    self.sc.delegate=self;
    self.sc.bounces=NO;
    self.sc.showsHorizontalScrollIndicator = YES;
    self.sc.showsVerticalScrollIndicator = YES;
    self.sc.pagingEnabled=YES;
    self.sc.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.sc];
    
    // 在滚动视图上添加tableView
    [self addTableView];
}
#pragma mark --- 添加tableView
- (void)addTableView{
    CGFloat scY = 121 * 0.5 * IPHONE6_H_SCALE;
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 0 , WIDTH , HEIGHT - 64 - scY) style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.showsVerticalScrollIndicator = NO;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_sc addSubview:_tableView1];
    
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH , HEIGHT - 64 - scY) style:UITableViewStylePlain];
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    _tableView2.showsVerticalScrollIndicator=NO;
    _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    [self.sc addSubview:_tableView2];

    
    // 添加刷新和加载
    [self addRefreshWith:_tableView1];
    [self addRefreshWith:_tableView2];
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
    
}
// 加载
- (void)loadMoreData{
    [_tableView1.footer endRefreshing];
    [_tableView2.footer endRefreshing];
    
}

#pragma mark --- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row];
    return cell;
}

#pragma mark ---  滚动视图结束滚动后
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.sc.contentOffset.x == 0) {
        [self postAction];
    }else {
        [self replyAction];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
