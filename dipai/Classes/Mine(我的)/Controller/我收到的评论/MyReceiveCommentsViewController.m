//
//  MyReceiveCommentsViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/30.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyReceiveCommentsViewController.h"

// 我收到的评论的单元格
#import "MyReceiveCell.h"
#import "MyReceiveModel.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 帖子详情页
#import "PostDetailVC.h"
// 资讯或图集详情页
#import "DetailWebViewController.h"
//  视频详情页
#import "VideoViewController.h"
// 赛事详情页
#import "MatchDetailVC.h"

#import "StarVC.h"
#import "AnyBodyVC.h"
#import "SBModel.h"

#import "DataTool.h"
#import "SVProgressHUD.h"
@interface MyReceiveCommentsViewController ()<UITableViewDataSource, UITableViewDelegate, MyReceiveCellDelegate>
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;


@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) SBModel * sbModel;

@end

@implementation MyReceiveCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    // 设置导航栏
    [self setNavigationBar];
    
    //
    [self addTabelView];
    
    // 我收到的评论接口
    // http://dipaiapp.replays.net/app/my/comment
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
    titleLabel.text = @"我收到的评论";
    self.navigationItem.titleView = titleLabel;
    
}
#pragma mark --- 返回
- (void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTabelView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 8 * IPHONE6_H_SCALE , WIDTH , HEIGHT-64-8 *IPHONE6_H_SCALE) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.viewIfLoaded addSubview:self.tableView];
    
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
    [header beginRefreshing];
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.tableView.footer = footer;
}

- (void)loadNewData{
    
    [DataTool getMyReceiveDataWithStr:MyReceiveURL parameters:nil success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        
        self.dataSource = responseObject;
        [self.tableView reloadData];
//        NSLog(@"%@", responseObject);
    } failure:^(NSError * error) {
       
        NSLog(@"获取我收到的评论出错：%@", error);
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreData{
    
    MyReceiveModel * model = [self.dataSource lastObject];
    
//    NSLog(@"%@", model.iD);
    
    NSString * url = [MyReceiveURL stringByAppendingString:[NSString stringWithFormat:@"/%@", model.iD]];
    [DataTool getMyReceiveDataWithStr:url parameters:nil success:^(id responseObject) {
        
        [self.tableView.footer endRefreshing];
        if (!responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了"];
        }
        [self.dataSource addObjectsFromArray:responseObject]; 
        [self.tableView reloadData];
        //        NSLog(@"%@", responseObject);
    } failure:^(NSError * error) {
        
        NSLog(@"获取我收到的评论出错：%@", error);
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyReceiveCell * cell = [MyReceiveCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.receiveModel = self.dataSource[indexPath.row];
    return cell;
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94 * IPHONE6_H_SCALE;
}

#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyReceiveModel * receiveModel = self.dataSource[indexPath.row];
   
    // 现在收到的评论只是帖子中的回复？？？ 对评论详情页中的评论进行回复不能收到
    if ([receiveModel.wapurl rangeOfString:@"art/view/11"].location != NSNotFound) {
        
        // 跳转到视频专辑页
        VideoViewController * videoVC = [[VideoViewController alloc] init];
        videoVC.url = receiveModel.wapurl;
        [self.navigationController pushViewController:videoVC animated:YES];
    }else if ([receiveModel.wapurl rangeOfString:@"art/view/2"].location != NSNotFound || [receiveModel.wapurl rangeOfString:@"art/view/4"].location != NSNotFound){
        // 跳转到资讯页面
        
        DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
        detailVC.url = receiveModel.wapurl;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } else if ([receiveModel.wapurl rangeOfString:@"forum/view"].location != NSNotFound){    // 跳转到帖子详情页
        
        PostDetailVC * postDetail =[[PostDetailVC alloc] init];
        postDetail.wapurl = receiveModel.wapurl;
        [self.navigationController pushViewController:postDetail animated:YES];
        
    }else if ([receiveModel.wapurl rangeOfString:@"club/view/5"].location != NSNotFound){ // 跳转到赛事详情页页面
        
        // 赛事详情页分为两种情况：1.有直播  2.没有直播
        MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
        detailVC.wapurl = receiveModel.wapurl;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    else
    {
        NSLog(@"%@", receiveModel.wapurl);
        NSLog(@"%lu", indexPath.row);
    }
    
}

#pragma mark --- MyReceiveCellDelegate
- (void)tableViewCell:(MyReceiveCell *)cell didClickNameWithModel:(MyReceiveModel *)model{
    
    StarVC * starVC = [[StarVC alloc] init];
    AnyBodyVC * anyVC = [[AnyBodyVC alloc] init];
    [DataTool getSBDataWithStr:model.userurl parameters:nil success:^(id responseObject) {
        
        SBModel * sbModel = [[SBModel alloc] init];
        sbModel = responseObject;
        _sbModel = sbModel;
        if ([_sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {   // 如果认证为空，就是普通人主页
            anyVC.userURL = model.userurl;
            anyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:anyVC animated:YES];
        }else{
            starVC.userURL = model.userurl;
            starVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:starVC animated:YES];
        }
    } failure:^(NSError * error) {
        NSLog(@"获取个人数据出错：%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
