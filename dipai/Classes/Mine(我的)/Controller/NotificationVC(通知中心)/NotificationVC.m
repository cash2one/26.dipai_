//
//  NotificationVC.m
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NotificationVC.h"

#import "NotifationCell.h"

// 刷新控件
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

#import "DataTool.h"
@interface NotificationVC ()<UITableViewDelegate, UITableViewDataSource>

// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation NotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    
    [self setUpUI];
    
    [self getData];
}

- (void)getData{
    
   
}

- (void)setNavigationBar{
    
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    self.naviBar.titleStr = @"通知中心";
}

- (void)setUpUI{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SeparateColor;
    [self.view addSubview:self.tableView];
    
    
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.tableView.footer = footer;
}

- (void)loadMoreData{
    
    [self.tableView.footer endRefreshing];
    self.tableView.footer.state = MJRefreshStateNoMoreData;
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
//    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotifationCell  * cell = [NotifationCell cellWithTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 310 * 0.5 * IPHONE6_H_SCALE;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
