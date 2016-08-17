//
//  ClubNewsVC.m
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ClubNewsVC.h"

// 自定义单元格
#import "NewsCell.h"

// 新闻模型
#import "NewsModel.h"

// 刷新
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"


#import "DataTool.h"
#import "Masonry.h"
@interface ClubNewsVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UILabel *NoNews;
// 没有内容的图片提示
@property (nonatomic, strong) UIImageView * imageV;

@end

@implementation ClubNewsVC
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"---self.wapurl---%@", self.wapurl);
    
    // 搭建UI
    [self setUpUI];
    [self addRefreshing];
}

- (void)setUpUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _NoNews = [[UILabel alloc] initWithFrame:CGRectMake( 0 , SPWidth , WIDTH , 30)];
    _NoNews.text = @"编辑很懒,什么也没留下";
    _NoNews.textAlignment = NSTextAlignmentCenter;
    _NoNews.font = [UIFont systemFontOfSize:13];
    _NoNews.textColor = [UIColor lightGrayColor];
    _NoNews.backgroundColor = [UIColor clearColor];
    _NoNews.hidden = YES;
    [self.tableView addSubview:_NoNews];
    [self.view addSubview:_tableView];
    
    UIImageView * imageV = [[UIImageView alloc] init];
    [self.view addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"zanshimeiyouxiangguanneirong"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(298 * 0.5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(246 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(181 * 0.5 * IPHONE6_W_SCALE));
    }];
    _imageV = imageV;
    _imageV.hidden = YES;
}


#pragma mark --- 添加刷新和加载的效果图
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

#pragma mark --- 刷新新的数据
- (void)loadNewData{
    
    if (self.wapurl == nil) {
        return;
    } else{
        [DataTool getClubNewsDataWithStr:self.wapurl parameters:nil success:^(id responseObject) {
            
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            
            if ([responseObject isKindOfClass:[NSString class]]) {
                
                _imageV.hidden = NO;
            }else{
                _imageV.hidden = YES;
                self.dataSource = responseObject;
                if (_tableView.contentOffset.y != 0) {
                    
                    [_NoNews removeFromSuperview];
                }
                
                if (self.dataSource.count == 0) {
                    // 没有新闻的时候显示
                    _NoNews.hidden = NO;
                }else{
                    
                    _NoNews.hidden = YES;
                }
            }
            
            [self.tableView reloadData];
        } failure:^(NSError * error) {
            
            NSLog(@"获取俱乐部新闻出错:%@", error);
        }];
    }
}

#pragma mark --- 加载更多数据
#warning 未正确处理
- (void)loadMoreData{
    
    [DataTool getClubNewsDataWithStr:_wapurl parameters:nil success:^(id responseObject) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        self.dataSource = responseObject;
        
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取俱乐部新闻出错:%@", error);
    }];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsCell * cell = [NewsCell cellWithTableView:tableView];
    NewsModel * newsModel = self.dataSource[indexPath.row];
    cell.newsModel = newsModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Margin196 * IPHONE6_H_SCALE;;
}
#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel * newsModel = self.dataSource[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(turnPageToDetailVCWithURL:)]) {
        [self.delegate turnPageToDetailVCWithURL:newsModel.url];
    } else{
        NSLog(@"ClubNewsVC的代理没有进行响应...");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
