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

#import "LSAlertView.h"

// 名人主页
#import "StarVC.h"
// 普通用户
#import "AnyBodyVC.h"
#import "SBModel.h"
// 登录页面
#import "LoginViewController.h"

#import "SVProgressHUD.h"
#import "DataTool.h"
@interface MorePokersVC ()<UITableViewDataSource, UITableViewDelegate, MorePokersCellDelegate, LSAlertViewDeleagte>

@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) SBModel * sbModel;

@property (nonatomic, strong) LSAlertView * alertView;
@property (nonatomic, strong) UIView * alertBackView;
@end

@implementation MorePokersVC

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
    /*
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = Font17;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"名人堂成员";
    self.navigationItem.titleView = titleLabel;
    
    if (self.titleStr) {
        titleLabel.text = self.titleStr;
    }
    */
    self.naviBar.titleStr = @"名人堂成员";
    if (self.titleStr) {
        self.naviBar.titleStr = self.titleStr;
    }
    self.naviBar.titleLbl.textColor = [UIColor blackColor];
    self.naviBar.backgroundColor = [UIColor whiteColor];
    self.naviBar.bottomLine.hidden = NO;
    self.naviBar.popV.hidden = NO;
    self.naviBar.popImage = [UIImage imageNamed:@"houtui"];
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --- 添加表格
- (void)addTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 64 , WIDTH , HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    
    // 判断用户是否登录（登录：显示关注状态   未登录：不显示任何关注状态）
    NSLog(@"%@", pokersModel.relation);
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if (cookieName || wxData) { // 已登录
        if ([pokersModel.relation isEqualToString:@"0"] || [pokersModel.relation isEqualToString:@"2"]) {   // 未关注
            [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_jiaguanzhu"] forState:UIControlStateNormal];
        } else if ([pokersModel.relation isEqualToString:@"1"]){    // 已关注
            [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_yiguanzhu"] forState:UIControlStateNormal];
        } else if([pokersModel.relation isEqualToString:@"3"]){ // 互相关注
            [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_huxiangguanzhu"] forState:UIControlStateNormal];
        } else{
            cell.attentionBtn.hidden = YES;
        }
    }else{  // 未登录
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
#pragma mark --- 点击关注相关按钮
- (void)tableViewCell:(MorePokersCell *)cell didClickedWithModel:(MorePokersModel *)model{
    
    NSLog(@"relation:%@", model.relation);
    NSLog(@"userid:%@", model.userid);
    // 首先要判断是否登录
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if (cookieName || wxData) {
        
        // model.relation   （0:未关注 1：关注  2：粉丝  3：互相   9：自己)
        
        if ([model.relation isEqualToString:@"0"] || [model.relation isEqualToString:@"2"]) {    // 未关注
            
            if ([model.relation isEqualToString:@"0"]) {
                [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_yiguanzhu"] forState:UIControlStateNormal];
            }else{
                [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_huxiangguanzhu"] forState:UIControlStateNormal];
            }
            
            // 进行关注的操作（两种情况 1:未关注的人也没关注我<点击关注后变成已关注>  2:未关注的人关注了我<点击以后变成互相关注>）
            NSString * url = [PayAttentionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", model.userid]];
            [DataTool PayAttentionOrCancleWithStr:url parameters:nil success:^(id responseObject) {
                
                NSLog(@"进行关注获取到的数据%@", responseObject);
                NSLog(@"content:%@", responseObject[@"content"]);
                if ([responseObject[@"data"] isEqualToString:@"1"]) {
                    // 设置为已关注
                    [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_yiguanzhu"] forState:UIControlStateNormal];
                }else if([responseObject[@"data"] isEqualToString:@"0"]){
                    // 设置为未关注  要取消关注了
                    
                    [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_jiaguanzhu"] forState:UIControlStateNormal];
                    
                }else
                {
                    [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_huxiangguanzhu"] forState:UIControlStateNormal];
                }
            } failure:^(NSError * error) {
                NSLog(@"进行关注操作时出错%@", error);
            }];
            
//            [self loadNewData];
            [self.tableView.header beginRefreshing];
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            
        } else if ([model.relation isEqualToString:@"1"]){  // 已关注
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定不再关注此人" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
            
            UIAlertAction * OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 进行取消关注的操作
                NSString * url = [PayAttentionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", model.userid]];
                [DataTool PayAttentionOrCancleWithStr:url parameters:nil success:^(id responseObject) {
                    
                    NSLog(@"进行取消关注获取到的数据%@", responseObject);
                    NSLog(@"content:%@", responseObject[@"content"]);
//                    if ([responseObject[@"data"] isEqualToString:@"1"]) {
//                        // 设置为已关注
//                        [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_yiguanzhu"] forState:UIControlStateNormal];
//                    }else if([responseObject[@"data"] isEqualToString:@"0"]){
//                        // 设置为未关注
//                        [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_jiaguanzhu"] forState:UIControlStateNormal];
//                        
//                    }else
//                    {
//                        [cell.attentionBtn setImage:[UIImage imageNamed:@"icon_huxiangguanzhu"] forState:UIControlStateNormal];
//                    }
                } failure:^(NSError * error) {
                    NSLog(@"进行取消关注操作时出错%@", error);
                }];

                [self.tableView.header beginRefreshing];
                // 对数据的刷新还有影响
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            }];
            
            [alert addAction:cancle];
            [alert addAction:OK];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }else if([model.relation isEqualToString:@"3"])
        {  // 互相关注
            // 进行取消关注的操作
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定不再关注此人" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
            
            UIAlertAction * OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 进行取消关注的操作
                NSString * url = [PayAttentionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", model.userid]];
                NSLog(@"取消关注URL：%@",url);
                [DataTool PayAttentionOrCancleWithStr:url parameters:nil success:^(id responseObject) {
                    
                    NSLog(@"进行取消关注获取到的数据%@", responseObject);
                    NSLog(@"content:%@", responseObject[@"content"]);
                } failure:^(NSError * error) {
                    NSLog(@"进行取消关注操作时出错%@", error);
                }];
                
                [self.tableView.header beginRefreshing];
                // 对数据的刷新还有影响
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            }];
            
            [alert addAction:cancle];
            [alert addAction:OK];
            [self presentViewController:alert animated:YES completion:nil];
        }else{  // 9：自己
            NSLog(@"自己 。。。");
        }

    }else{
        [self addAlertViewWithMessage:@"请在登录后进行操作"];
    }
}
#pragma mark --- 添加登录的alertView
- (void)addAlertViewWithMessage:(NSString *)message{
    LSAlertView * alertView = [[LSAlertView alloc] init];
    alertView.delegate = self;
    
    // 提示框上的提示信息
    alertView.messageLbl.text = message;
    
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
#pragma mark --- LSAlertViewDeleagte
// 取消按钮
- (void)lsAlertView:(LSAlertView *)alertView cancel:(NSString *)cancel
{
    [self removeAlerView];
}

- (void)removeAlerView
{
    // 移除提示框的背景图
    [_alertBackView removeFromSuperview];
    // 移除提示框
    [_alertView removeFromSuperview];
}
// 登录按钮
- (void)lsAlertView:(LSAlertView *)alertView sure:(NSString *)sure
{
    // 移除提示框
    [self removeAlerView];
    
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNav animated:YES completion:nil];
}

- (void)tableViewCell:(MorePokersCell *)cell didClickFaceWith:(MorePokersModel *)model{
    NSLog(@"........");
    // 名人主页
    StarVC * starVC = [[StarVC alloc] init];
    starVC.userURL = model.userurl;
    //  普通用户主页
    AnyBodyVC * anyVC = [[AnyBodyVC alloc] init];
    anyVC.userURL = model.userurl;
    
    [DataTool getSBDataWithStr:model.userurl parameters:nil success:^(id responseObject) {
        
        SBModel * sbModel = [[SBModel alloc] init];
        sbModel = responseObject;
        _sbModel = sbModel;
        if ([_sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {   // 如果认证为空，就是普通人主页
            anyVC.userURL = model.userurl;
            [self.navigationController pushViewController:anyVC animated:YES];
        }else{
            starVC.userURL = model.userurl;
            [self.navigationController pushViewController:starVC animated:YES];
        }
    } failure:^(NSError * error) {
        NSLog(@"获取个人数据出错：%@", error);
    }];
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
    
//    NSLog(@"--wapurl--%@", self.wapurl);
    [DataTool getMorePokerDataWithStr:self.wapurl parameters:nil success:^(id responseObject) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        self.dataSource = responseObject;
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取更多扑克人列表出错：%@", error);
    }];
    
}
- (void)loadMoreData{
    
    MorePokersModel * pokersModel = [self.dataSource lastObject];
//    NSLog(@"%@", pokersModel.userid);
//    NSString * URL = [self.wapurl stringByReplacingOccurrencesOfString:@"?" withString:[NSString stringWithFormat:@"/%@?", pokersModel.userid]];
    // 拼接在list1之后
    NSLog(@"%@", self.wapurl);
    NSString * URL = nil;
    // http://dpapp.replays.net/app/follow/list?userid=259
    // http://dpapp.replays.net/app/follow/list/1?userid=250
    if ([self.wapurl containsString:@"userid"]) {
        if ([self.wapurl containsString:@"list/1"]) {  // 关注列表
            URL = [self.wapurl stringByReplacingOccurrencesOfString:@"list/1" withString:[NSString stringWithFormat:@"list/1%@", pokersModel.userid]];
        }else{  // 被关注列表
            URL = [self.wapurl stringByReplacingOccurrencesOfString:@"list" withString:[NSString stringWithFormat:@"list/0/%@", pokersModel.userid]];
        }
       
        NSLog(@"%@", URL);
    }else{
        URL  = [NSString stringWithFormat:@"%@/%@", self.wapurl, pokersModel.userid];
    }
    NSLog(@"%@", URL);
    [DataTool getMorePokerDataWithStr:URL parameters:nil success:^(id responseObject) {
        [self.tableView.footer endRefreshing];
        NSLog(@"%@", responseObject);
        if (!responseObject) {
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }else{
            [self.dataSource addObjectsFromArray:responseObject];
        }
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"%@", error);
        [self.tableView.footer endRefreshing];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
