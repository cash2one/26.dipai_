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
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "HttpTool.h"
@interface NotificationVC ()<UITableViewDelegate, UITableViewDataSource>

// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableDictionary * cellHDic;

@end

@implementation NotificationVC
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    // 在页面将要消失的时候不再隐藏navigationBar
    self.navigationController.navigationBarHidden = NO;
}


- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableDictionary *)cellHDic{
    
    if (_cellHDic == nil) {
        _cellHDic = [NSMutableDictionary dictionary];
    }
    return _cellHDic;
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
    
//    [DataTool getMessageCenterWithStr:MessageCenterURL parameters:nil success:^(id responseObject) {
//        NSLog(@"responseObject:%@", responseObject);
//    } failure:^(NSError * error) {
//         NSLog(@"获取数据错误：%@", error);
//    }];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString * url = nil;
    if ([MessageCenterURL hasPrefix:@"http"]) {
        url = MessageCenterURL;
    }else{
        url = [NSString stringWithFormat:@"%@%@", DipaiBaseURL, MessageCenterURL];
    }
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"通知中心获取的数据：%@", responseObject);
//        NSMutableArray * arr = responseObject[@"data"];
//        self.dataSource = (NSMutableArray *) responseObject[@"data"];
//        [self.dataSource removeAllObjects];
//        self.dataSource = arr;
        [self.dataSource addObjectsFromArray:responseObject[@"data"]];
        if (self.dataSource.count  == 0) {
            [SVProgressHUD showErrorWithStatus:@"没有通知"];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"获取数据错误：%@", error);
    }];
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
    NSDictionary * dic = [self.dataSource lastObject];
    NSString * idStr = dic[@"messageid"];
    NSString * url = [NSString stringWithFormat:@"%@/%@", MessageCenterURL, idStr];
     [self.tableView.footer endRefreshing];
    [DataTool getMessageCenterWithStr:url parameters:nil success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSArray * arr = dic[@"data"];
        if (arr.count > 0) {
            [self.dataSource addObjectsFromArray:arr];
        }else{
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取数据错误：%@", error);
    }];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotifationCell  * cell = [NotifationCell cellWithTableView:tableView];
    cell.dic = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic = self.dataSource[indexPath.row];
    NSString * msgId = dic[@"messageid"];
    CGFloat cellHeight = [self.cellHDic[msgId] floatValue];
    if (cellHeight == 0.f) {    // 如果高度为零
        NSString * content = dic[@"content"];
        CGFloat contentW = 690 * 0.5 * IPHONE6_W_SCALE - 40 * IPHONE6_W_SCALE;
        NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
        contentDic[NSFontAttributeName] = Font14;
        CGRect rect = [content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil];
        cellHeight = rect.size.height + 43 * IPHONE6_H_SCALE + 94 * 0.5 * IPHONE6_H_SCALE;
        
        // 将高度进行存储
        [self.cellHDic setObject:@(cellHeight) forKey:msgId];
    }
  
    return cellHeight;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
