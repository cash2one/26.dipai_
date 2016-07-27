//
//  SectionVC.m
//  dipai
//
//  Created by 梁森 on 16/6/22.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "SectionVC.h"

#import "SVProgressHUD.h"
// 发布页面
#import "SendVC.h"
// 帖子详情页
#import "PostDetailVC.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 版块模型
#import "SectionModel.h"
// 帖子模型 
#import "PostsModel.h"
// 加了type的帖子模型
#import "TypePostModel.h"

// 帖子frame模型
#import "PostFrameModel.h"

// 帖子单元格
#import "PostCell.h"

#import "LSAlertView.h"
// 登录页面
#import "LoginViewController.h"
// 名人主页
#import "StarVC.h"
// 普通用户主页
#import "AnyBodyVC.h"
#import "SBModel.h"

#import "DataTool.h"
@interface SectionVC ()<UITableViewDataSource, UITableViewDelegate, LSAlertViewDeleagte, PostCellDelegate>
/**
 *  表格
 */
@property (nonatomic, strong) UITableView * tableView;
/**
 * 数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIView * alertBackView;

@property (nonatomic, strong) LSAlertView * alertView;

@property (nonatomic, strong) SBModel * sbModel;

@end

@implementation SectionVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
//    self.navigationItem.title = self.titleStr;
    [self setUpNavigationBar];
    
    NSLog(@"%@", self.wapurl);
    
    // 添加表格
    [self addTableView];
}
#pragma mark --- 设置导航栏
- (void)setUpNavigationBar{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui_baise"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"bianji"] target:self action:@selector(writeAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---编辑事件
- (void)writeAction{
    
    // 先判断是否登录
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if (cookieName || wxData) {
        SendVC * sendVC = [[SendVC alloc] init];
        sendVC.sectionModel = self.sectionModel;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:sendVC];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [self addAlertView];
    }
}

#pragma mark --- 添加登录的alertView
- (void)addAlertView{
    LSAlertView * alertView = [[LSAlertView alloc] init];
    alertView.delegate = self;
    CGFloat x = Margin105 * IPHONE6_W_SCALE;
    CGFloat y = Margin574 * IPHONE6_H_SCALE;
    CGFloat w = Margin540 * IPHONE6_W_SCALE;
    CGFloat h = Margin208 * IPHONE6_H_SCALE;
    alertView.frame = CGRectMake(x, y, w, h);
    UIView * alertBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    alertBackView.backgroundColor = ColorBlack30;
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加到灰色的背景图
    [window addSubview:alertBackView];
    [window addSubview:alertView];
    _alertBackView = alertBackView;
    _alertView = alertView;
}
#pragma mark -- LSAlertViewDeleagte
/**
 *  取消按钮的点击事件
 
 */
- (void)lsAlertView:(LSAlertView *)alertView cancel:(NSString * )cancel{
    [self removeAlerView];
}

- (void)removeAlerView
{
    // 移除提示框的背景图
    [_alertBackView removeFromSuperview];
    // 移除提示框
    [_alertView removeFromSuperview];
}
/**
 *  确定按钮的点击事件

 */
- (void)lsAlertView:(LSAlertView *)alertView sure:(NSString *)sure{
    // 移除提示框
    [self removeAlerView];
    
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNav animated:YES completion:nil];
}
#pragma mark --- 添加表格
- (void)addTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 0 , WIDTH , HEIGHT -64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //  添加刷新和加载
    [self addRefreshing];
}

- (void)addRefreshing{
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

#pragma mark --- 加载和刷新
- (void)loadNewData{
    
    [DataTool getPostsDataWithStr:self.sectionModel.wapurl parameters:nil success:^(id responseObject) {
        
        NSLog(@"获取帖子列表的网址：%@", self.sectionModel.wapurl);
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        TypePostModel * typePostModel = responseObject;   // 帖子模型数组
        
        NSMutableArray * frameArr = [NSMutableArray array]; // 用来装frame模型
        
        NSArray * postsModelArr = typePostModel.data;
        self.navigationItem.title = typePostModel.forum_section;
        
        for (PostsModel * postsModel in postsModelArr) {
            PostFrameModel * frameModel = [[PostFrameModel alloc] init];
            
            
            frameModel.postsModel = postsModel;
            
            
            [frameArr addObject:frameModel];
        }
        
        self.navigationItem.title = typePostModel.forum_section;
        
        self.dataSource = frameArr;
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取评论列表出错：%@", error);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [SVProgressHUD showWithStatus:@"网络有问题"];
    }];
}
- (void)loadMoreData{
    
    PostFrameModel * frameModel = [self.dataSource lastObject];
    NSString * iD = frameModel.postsModel.iD;
    NSString * url = [self.sectionModel.wapurl stringByAppendingString:[NSString stringWithFormat:@"/%@", iD]];
    
    NSLog(@"%@", url);
    
    [DataTool getPostsDataWithStr:url parameters:nil success:^(id responseObject) {
        [self.tableView.footer endRefreshing];
        
        TypePostModel * typePostModel = responseObject;   // 帖子模型数组
        
        if (!typePostModel.data) {
            NSLog(@"空");
//            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了"];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        } else{
            
            NSLog(@"不为空");
            NSMutableArray * frameArr = [NSMutableArray array]; // 用来装frame模型
            for (PostsModel * postsModel in typePostModel.data) {
                PostFrameModel * frameModel = [[PostFrameModel alloc] init];
                frameModel.postsModel = postsModel;
                [frameArr addObject:frameModel];
            }
            
            [self.dataSource addObjectsFromArray:frameArr];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取评论列表出错：%@", error);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络有问题"];
    }];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%lu", self.dataSource.count);
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostCell * cell = [PostCell cellWithTableView:tableView];
    cell.delegate = self;
    PostFrameModel * frameModel = self.dataSource[indexPath.row];
    cell.frameModel = frameModel;
    return cell;
}

#pragma mark --- PostCellDelegate
// 点击头像的点击事件
- (void)tableViewCell:(PostCell *)cell didClickFaceWith:(PostsModel *)model{
    
    // 可能跳到名人主页，也可能跳到普通用户主页
    StarVC * starVC = [[StarVC alloc] init];
    starVC.userURL = model.userurl;
    AnyBodyVC * anyVC = [[AnyBodyVC alloc] init];
    anyVC.userURL = model.userurl;
    
    [DataTool getSBDataWithStr:model.userurl parameters:nil success:^(id responseObject) {
        
        SBModel * sbModel = [[SBModel alloc] init];
        sbModel = responseObject;
        _sbModel = sbModel;
        if ([_sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {   // 如果认证为空，就是普通人主页
            [self.navigationController pushViewController:anyVC animated:YES];
        }else{
            [self.navigationController pushViewController:starVC animated:YES];
        }
    } failure:^(NSError * error) {
        NSLog(@"获取个人数据出错：%@", error);
    }];
    
}

#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostFrameModel * model = self.dataSource[indexPath.row];
    return  model.cellHeight;
//    return 200;
}

#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%lu", indexPath.row);
    PostDetailVC * postDetailVC = [[PostDetailVC alloc] init];
    PostFrameModel * model = self.dataSource[indexPath.row];
    postDetailVC.wapurl = model.postsModel.wapurl;
    [self.navigationController pushViewController:postDetailVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
