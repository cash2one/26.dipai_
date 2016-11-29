//
//  SpecialDetailVC.m
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "SpecialDetailVC.h"

// 专辑详情页单元格和模型
#import "SpecialDetailCell.h"
#import "SpecialDetailModel.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 网页详情页
#import "DetailWebViewController.h"

#import "DataTool.h"
#import "SVProgressHUD.h"
@interface SpecialDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation SpecialDetailVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"%@", self.specialModel);
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏内容
    [self setUpNavigationBar];
    
    [self addTableView];
}
#pragma mark --- 设置导航栏内容
- (void)setUpNavigationBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.specialModel.title;
    self.navigationItem.titleView = titleLabel;
    
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT  - 64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    NSLog(@"表格的高度：%f", self.tableView.frame.size.height);
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 添加下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏状态
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 设置header
    self.tableView.header = header;
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 添加上拉加载控件
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置文字
    //加载更多
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    //没有更多数据
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    // 设置footer
    self.tableView.footer = footer;
}

- (void)loadNewData{
    
    NSLog(@"%@", self.specialModel.url);
    NSString * url = self.specialModel.url;
    if (self.wapurl.length>0) {
        url = self.wapurl;
    }
    [DataTool getSpecialDetailDataWithStr:url parameters:nil success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        self.dataSource = responseObject;
        [self.tableView reloadData];
//        NSLog(@"%@", responseObject);
    } failure:^(NSError * error) {
       
        NSLog(@"获取详情页数据出错：%@", error);
    }];
}

- (void)loadMoreData{
    
    SpecialDetailModel * model = [self.dataSource lastObject];
    NSString * wapurl = self.specialModel.url;
    if (self.wapurl.length > 0) {
        wapurl = self.wapurl;
    }
    NSString * url = [wapurl stringByAppendingString:[NSString stringWithFormat:@"/%@", model.iD]];
    [DataTool getSpecialDetailDataWithStr:url parameters:nil success:^(id responseObject) {
        
        [self.tableView.footer endRefreshing];
        if (!responseObject) {
//            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了"];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }
        [self.dataSource addObjectsFromArray:responseObject];
        [self.tableView reloadData];
//        NSLog(@"%@", responseObject);
    } failure:^(NSError * error) {
        
        NSLog(@"获取详情页数据出错：%@", error);
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SpecialDetailCell * cell = [SpecialDetailCell cellWithTableView:tableView];
    cell.speDeModel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  Margin196 * IPHONE6_H_SCALE;
}
#pragma mark ---单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
    SpecialDetailModel * detailModel = self.dataSource[indexPath.row];
    detailVC.url = detailModel.url;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
