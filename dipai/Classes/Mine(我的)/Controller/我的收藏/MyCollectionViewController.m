//
//  MyCollectionViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/23.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyCollectionViewController.h"

#import "DataBase.h"
#import "NewsListModel.h"
#import "DataTool.h"
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 自定义单元格
#import "InformationCell.h"
#import "PicturesCell.h"

// 我的收藏模型
#import "MyCollectionModel.h"
// 某人模型
#import "SBModel.h"

// 我的收藏单元格
#import "MyCollectCell.h"
// 我的收藏模型
#import "MyCollectionModel.h"

// 网页详情页
#import "DetailWebViewController.h"
// 视频页详情
#import "VideoViewController.h"
// 帖子详情页
#import "PostDetailVC.h"

// 普通用户页面
#import "AnyBodyVC.h"
// 认证用户页面
#import "StarVC.h"
#import "SVProgressHUD.h"
#import "Masonry.h"
@interface MyCollectionViewController ()<UITableViewDataSource, UITableViewDelegate, MyCollectCellDelegate>

{
    NSString * _page;   // 分页使用
}
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) SBModel * sbModel;
// 没有收藏的图片提示
@property (nonatomic, strong) UIImageView * imageV;

@end

@implementation MyCollectionViewController

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
    [self setNavigationBar];
    
    [self addTableView];
    [self loadNewData];

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
    titleLabel.text = @"我的收藏";
    self.navigationItem.titleView = titleLabel;
    
//    self.editButtonItem.title = @"";
    
    self.editButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

}
// 开启可编辑功能

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 设置删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPat{
    return @"警告：删除";
}
// 点击编辑按钮调用的方法
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
        [self.tableView setEditing:editing animated:YES];
        if (self.editing) {
            self.editButtonItem.title = @"完成";
//            self.navigationItem.rightBarButtonItem.title = @"完成";
        } else {
            self.editButtonItem.title = @"编辑";
            self.editButtonItem.tintColor = [UIColor blackColor];
        }
    
}

//完成编辑的触发事件  左滑显示删除按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除收藏 网络上的删除
    MyCollectionModel * model = [self.dataSource objectAtIndex:indexPath.row];
    NSString * iD = model.iD;
    NSString * url = [DeleteCollectURL stringByAppendingString:iD];
    
    
    [DataTool deleteMyCollectionWithStr:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"删除收藏成功返回的数据:%@", responseObject);
        NSLog(@"%@", responseObject[@"content"]);
    } failure:^(NSError * error) {
        
        NSLog(@"删除收藏的错误信息%@", error);
    }];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.dataSource removeObjectAtIndex: indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        if (self.dataSource.count == 0) {
            self.editButtonItem.title = @"";
            self.editButtonItem.tintColor = [UIColor whiteColor];
        }else{
            self.editButtonItem.title = @"编辑";
            self.editButtonItem.tintColor = [UIColor blackColor];
        }
        [self.tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}
//返回编辑状态的style
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCellEditingStyleInsert
    //    return UITableViewCellEditingStyleNone;
    return UITableViewCellEditingStyleDelete;
}

#pragma mark --- 返回
- (void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 0 , WIDTH , HEIGHT - 64 ) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIImageView * imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"meiyoushoucang"];
    [self.view addSubview:imageV];
    _imageV = imageV;
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(298 * 0.5 * IPHONE6_H_SCALE);
        // 215   178
        make.width.equalTo(@(215 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(178 * 0.5 * IPHONE6_W_SCALE));
    }];
    _imageV.hidden = YES;
    
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = header;
//    [header beginRefreshing];
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
    [DataTool getCollectionDataWithStr:MyCollectionURL parameters:nil success:^(id responseObject) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
//        NSLog(@"%@", responseObject);
        if ([responseObject isKindOfClass:[NSString class]]) {  // 数据为空的情况
            NSLog(@"responseObject为空");
            _imageV.hidden = NO;
        }else{
            _imageV.hidden = YES;
            self.dataSource = responseObject;
            if (self.dataSource.count > 0) {
                self.editButtonItem.title = @"编辑";
                self.editButtonItem.tintColor = [UIColor blackColor];
            }else{
                self.editButtonItem.title = @"";
                self.editButtonItem.tintColor = [UIColor whiteColor];
            }
        }
//        NSMutableArray * arr = responseObject;
//        self.dataSource = [arr objectAtIndex:0];
//        NSString * page = [arr objectAtIndex:1];
//        _page = page;
        
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取我的收藏失败：%@", error);
    }];
}
- (void)loadMoreData{
    
//    NSLog(@"%@", _page);
    MyCollectionModel * model = [self.dataSource lastObject];
    NSString * url = [MyCollectionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", model.iD]];
    NSLog(@"%@", url);
    [DataTool getCollectionDataWithStr:url parameters:nil success:^(id responseObject) {
        [self.tableView.footer endRefreshing];
//        _page = page;
        if ([responseObject isKindOfClass:[NSString class]]) {
//            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了"];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }else{
            [self.dataSource addObjectsFromArray:responseObject];
            if (self.dataSource.count > 0) {
                self.editButtonItem.title = @"编辑";
                self.editButtonItem.tintColor = [UIColor blackColor];
            }else{
                self.editButtonItem.title = @"";
                self.editButtonItem.tintColor = [UIColor whiteColor];
            }
        }
        
        [self.tableView reloadData];
        NSLog(@"%@", responseObject);
    } failure:^(NSError * error) {
       
        NSLog(@"获取更多收藏数据出错%@", error);
        [self.tableView.footer endRefreshing];
    }];
    

}


#pragma mark --- 编辑按钮的点击事件
- (void)editAction{
    NSLog(@"进行编辑...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


#pragma mark --- 单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectCell * cell = [MyCollectCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.collectionModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%lu", indexPath.row);
    MyCollectionModel * collectModel = self.dataSource[indexPath.row];
    if ([collectModel.type isEqualToString:@"2"] || [collectModel.type isEqualToString:@"4"]) { // 跳到网页详情页
        
        DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
        detailVC.url = collectModel.url;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if ([collectModel.type isEqualToString:@"11"]){   // 跳到视频页详情
        
        VideoViewController * videoVC = [[VideoViewController alloc] init];
        videoVC.url = collectModel.url;
        [self.navigationController pushViewController:videoVC animated:YES];
    }else{  // 跳到帖子页详情
        PostDetailVC * postVC = [[PostDetailVC alloc] init];
        postVC.wapurl = collectModel.url;
        NSLog(@"%@", postVC.wapurl);
        [self.navigationController pushViewController:postVC animated:YES];
    }

}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionModel * collectModel = self.dataSource[indexPath.row];
    if ([collectModel.type isEqualToString:@"2"] || [collectModel.type isEqualToString:@"11"]) {    // 资讯或视频
        return 96 * IPHONE6_H_SCALE;
    } else if ([collectModel.type isEqualToString:@"4"]){   // 图集
        return 317 * 0.5 * IPHONE6_H_SCALE;
    } else{
        // 51 + 10(标题和内容的间距)
        
        // 帖子标题
        CGFloat titleX = 118 * 0.5 * IPHONE6_W_SCALE;
        CGFloat titleY = 0;
        CGFloat titleW = WIDTH - titleX - 10 * IPHONE6_W_SCALE;
        
        NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
        titleDic[NSFontAttributeName] = Font16;
        CGRect titleRect = [collectModel.title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
        CGRect rect = (CGRect){{titleX, titleY}, titleRect.size};
        CGFloat h1 = rect.size.height;
        
        // 帖子内容
        CGFloat contentsX = titleX;
        CGFloat contentsY = 0;
        CGFloat contentsW = WIDTH - contentsX - 15 * IPHONE6_W_SCALE;
        
        NSMutableDictionary * contentsDic = [NSMutableDictionary dictionary];
        contentsDic[NSFontAttributeName] = Font13;
        CGRect contentsRect = [collectModel.descriptioN boundingRectWithSize:CGSizeMake(contentsW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentsDic context:nil];
        CGRect rect2 = (CGRect){{contentsX, contentsY}, contentsRect.size};
        CGFloat h2 = rect2.size.height;
        // 帖子图片
        CGFloat h3 = 80.0*IPHONE6_H_SCALE;
        if (collectModel.covers && collectModel.covers.count > 0) {  // 有图片的情况下
                        
            return h1 + h2 + 74*IPHONE6_H_SCALE + h3 + 13 * IPHONE6_H_SCALE;
        }else{  // 没有图片的情况下
            return h1 + h2 + 74*IPHONE6_H_SCALE;
        }
        
    }
}

#pragma mark --- MyCollectCellDelegate
- (void)tableViewCell:(MyCollectCell *)cell didClickFaceWith:(MyCollectionModel *)model{
    // 有两种情况  1:跳到认证用户主页  2:跳到普通用户主页
    AnyBodyVC * anyBodyVC = [[AnyBodyVC alloc] init];
    StarVC * starVC = [[StarVC alloc] init];
    
    
    [DataTool getSBDataWithStr:model.url parameters:nil success:^(id responseObject) {
        SBModel * sbModel = [[SBModel alloc] init];
        sbModel = responseObject;
        _sbModel = sbModel;
    } failure:^(NSError * error) {
        NSLog(@"获取个人数据出错：%@", error);
    }];
    if (![_sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {   // 如果认证为空，就是普通人主页
        anyBodyVC.userURL = model.userurl;
        [self.navigationController pushViewController:anyBodyVC animated:YES];
    }else{
        starVC.userURL = model.userurl;
        [self.navigationController pushViewController:starVC animated:YES];
    }
}


@end
