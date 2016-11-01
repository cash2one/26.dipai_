//
//  MyOrderVC.m
//  dipai
//
//  Created by 梁森 on 16/10/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyOrderVC.h"
// 客服页面
#import "ServerVC.h"
// 订单模型
#import "OrderModel.h"
// 订单单元格
#import "OrderCell.h"
// 刷新控件
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

#import "DataTool.h"
#import "SVProgressHUD.h"
@interface MyOrderVC ()<UITableViewDelegate, UITableViewDataSource, OrderCellDelegate>
// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation MyOrderVC

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    
    [self setUpUI];
    [self getData];
}

- (void)getData{
    
    [DataTool getMyOrdersWithStr:MyOrderURL parameters:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSString class]]) {
            [SVProgressHUD showErrorWithStatus:@"暂无订单"];
        }else{
            
            self.dataSource = responseObject;
        }
        
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取数据出错：%@", error);
    }];
}
- (void)loadMoreData{
    
    OrderModel * model = [self.dataSource lastObject];
    
    NSString * url = [MyOrderURL stringByAppendingString:[NSString stringWithFormat:@"/%@",model.order_id]];
    [DataTool getMyOrdersWithStr:url parameters:nil success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSString class]]) {
            NSLog(@"空。。。");
            [self.tableView.footer endRefreshing];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }else{
            [self.dataSource addObjectsFromArray:responseObject];
            [self.tableView.footer endRefreshing];
        }
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取数据出错：%@", error);
    }];
}

- (void)setNavigationBar{
    
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    self.naviBar.titleStr = @"我的订单";
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

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderCell * cell = [OrderCell cellWithTableView:tableView];
    OrderModel * model = [self.dataSource objectAtIndex:indexPath.row];
    cell.orderModel = model;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 310 * 0.5 * IPHONE6_H_SCALE;
}

- (void)tableViewCell:(OrderCell *)cell didClickWithId:(NSString *)iD{
    
    ServerVC * serverV = [[ServerVC alloc] init];
    [self.navigationController pushViewController:serverV animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
