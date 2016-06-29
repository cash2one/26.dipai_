//
//  MorePokersVC.m
//  dipai
//
//  Created by 梁森 on 16/6/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MorePokersVC.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 更多名人中的单元格
#import "MorePokersCell.h"
// 单元格中的模型
#import "MorePokersModel.h"

#import "SVProgressHUD.h"
#import "DataTool.h"
@interface MorePokersVC ()<UITableViewDataSource, UITableViewDelegate, MorePokersCellDelegate>

@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation MorePokersVC

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
    
    // 设置导航栏
    [self setUpNavigationBar];
    
    // 添加表格
    [self addTableView];
    
    [self addRefreshing];
}
#pragma mark --- 设置导航栏
- (void)setUpNavigationBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = Font17;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"名人堂成员";
    self.navigationItem.titleView = titleLabel;
    
}
#pragma mark --- 返回上一个视图控制器
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 添加表格
- (void)addTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 0 , WIDTH , HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
}
#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MorePokersCell * cell = [MorePokersCell cellWithTableView:tableView];
    cell.delegate = self;
    MorePokersModel * pokersModel = self.dataSource[indexPath.row];
    
    // 0：无状态 /   1：已关注/   2：粉丝/    3：互相关注   9：自己
    
    if ([pokersModel.relation isEqualToString:@"0"] || [pokersModel.relation isEqualToString:@"2"]) {   // 未关注
        [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_jiaguanzhu"] forState:UIControlStateNormal];
    } else if ([pokersModel.relation isEqualToString:@"1"]){    // 已关注
        [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_yiguanzhu"] forState:UIControlStateNormal];
    } else if([pokersModel.relation isEqualToString:@"3"]){ // 互相关注
        [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_huxiangguanzhu"] forState:UIControlStateNormal];
    } else{
        cell.attentionBtn.hidden = YES;
    }
    cell.morePokersModel = self.dataSource[indexPath.row];
    return cell;
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74 * IPHONE6_H_SCALE + 0.5;
}

#pragma mark MorePokersCellDelegate
- (void)tableViewCell:(MorePokersCell *)cell didClickedWithModel:(MorePokersModel *)model{
    
    NSLog(@"relation:%@", model.relation);
    // 首先要判断是否登录
    
    if ([model.relation isEqualToString:@"0"] || [model.relation isEqualToString:@"2"]) {    // 未关注
        
        if ([model.relation isEqualToString:@"0"]) {
            [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_yiguanzhu"] forState:UIControlStateNormal];
        }
        if ([model.relation isEqualToString:@"2"]) {
            [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_huxiangguanzhu"] forState:UIControlStateNormal];
        }
        
        // 进行关注的操作（两种情况 1:未关注的人也没关注我<点击关注后变成已关注>  2:未关注的人关注了我<点击以后变成互相关注>）
        NSString * url = [PayAttentionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", model.userid]];
        [DataTool PayAttentionOrCancleWithStr:url parameters:nil success:^(id responseObject) {
            
            NSLog(@"进行关注获取到的数据%@", responseObject);
            NSLog(@"content:%@", responseObject[@"content"]);
        } failure:^(NSError * error) {
            NSLog(@"进行关注操作时出错%@", error);
        }];
        
        [self.tableView.header beginRefreshing];
        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
        
    
    } else if ([model.relation isEqualToString:@"1"]){  // 已关注
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定不再关注此人" message:nil preferredStyle:UIAlertControllerStyleAlert];

        
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        UIAlertAction * OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 进行取消关注的操作
            [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_jiaguanzhu"] forState:UIControlStateNormal];
            NSString * url = [PayAttentionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", model.userid]];
            [DataTool PayAttentionOrCancleWithStr:url parameters:nil success:^(id responseObject) {
                
                NSLog(@"进行取消关注获取到的数据%@", responseObject);
                NSLog(@"content:%@", responseObject[@"content"]);
            } failure:^(NSError * error) {
                NSLog(@"进行取消关注操作时出错%@", error);
            }];
            
            [self loadNewData];
            [self.tableView reloadData];
            // 对数据的刷新还有影响
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
        }];
        
        [alert addAction:cancle];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else{  // 互相关注
        // 进行取消关注的操作
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定不再关注此人" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        UIAlertAction * OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 进行取消关注的操作
            [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_jiaguanzhu"] forState:UIControlStateNormal];
            NSString * url = [PayAttentionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", model.userid]];
            [DataTool PayAttentionOrCancleWithStr:url parameters:nil success:^(id responseObject) {
                
                NSLog(@"进行取消关注获取到的数据%@", responseObject);
                NSLog(@"content:%@", responseObject[@"content"]);
            } failure:^(NSError * error) {
                NSLog(@"进行取消关注操作时出错%@", error);
            }];
            
            [self loadNewData];
            [self.tableView reloadData];
            // 对数据的刷新还有影响
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
        }];
        
        [alert addAction:cancle];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark --- 添加下拉刷新和上拉加载
- (void)addRefreshing{
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
    
    [DataTool getMorePokerDataWithStr:MorePokersURL parameters:nil success:^(id responseObject) {
        [self.tableView.header endRefreshing];
        
        self.dataSource = responseObject;
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取更多扑克人列表出错：%@", error);
    }];
    
}
- (void)loadMoreData{
    [self.tableView.footer endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
