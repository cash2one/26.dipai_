//
//  SpecialViewController.m
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "SpecialViewController.h"
// 专题的单元格
#import "SpecialCell.h"
// 专题的模型
#import "SpecialModel.h"

// 专辑详情页
#import "SpecialDetailVC.h"

#import "DataTool.h"
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"
#import "SVProgressHUD.h"
@interface SpecialViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation SpecialViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setUpNavigationBar];
    [self addTableView];
    [self getData];
}

- (void)setUpNavigationBar{
    /*
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui_baise"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
     */
    self.naviBar.titleStr = @"";
    self.naviBar.popV.hidden = NO;
    self.naviBar.popImage = [UIImage imageNamed:@"houtui_baise"];
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --- 添加表格
- (void)addTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT  - 64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    [DataTool getSpecialDataWithStr:SpecialURL parameters:nil success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        //        NSLog(@"%@", responseObject);
        self.dataSource = responseObject;
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取专辑页出错：%@", error);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

- (void)loadMoreData{
    
    SpecialModel * model = [self.dataSource lastObject];
    NSString * url = [SpecialURL stringByAppendingString:[NSString stringWithFormat:@"/%@", model.iD]];
    
    [DataTool getSpecialDataWithStr:url parameters:nil success:^(id responseObject) {
        
        [self.tableView.footer endRefreshing];
        //        NSLog(@"%@", responseObject);
        if (!responseObject) {
//            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了"];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }
        [self.dataSource addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取专辑页出错：%@", error);
        [self.tableView.footer endRefreshing];
    }];
}


#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SpecialCell * cell = [SpecialCell cellWithTableView:tableView];
    cell.specialModel = self.dataSource[indexPath.row];
    return cell;
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 287 * IPHONE6_H_SCALE;
}

#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SpecialDetailVC * specialVC = [[SpecialDetailVC alloc] init];
    specialVC.specialModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:specialVC animated:YES];
}

/*****************************获取网络数据**************************/
- (void)getData{
    
   
}

// 设置状态栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
