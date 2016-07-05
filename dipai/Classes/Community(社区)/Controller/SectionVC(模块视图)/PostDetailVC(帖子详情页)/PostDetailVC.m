//
//  PostDetailVC.m
//  dipai
//
//  Created by 梁森 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "PostDetailVC.h"
// 帖子单元格
#import "PostCell.h"
// 帖子头视图
#import "PostHeaderView.h"
// 详情页模型
#import "PostDetailModel.h"
// 详情页中的data模型
#import "PostDaraModel.h"
#import "DataTool.h"

// 回帖页面
#import "ReplyPostVC.h"
// 回帖单元格
#import "ReplyCell.h"
// 回帖模型
#import "ReplyModel.h"
// 回帖frame模型
#import "ReplyFrameModel.h"

// 个人主页
#import "StarVC.h"


#import "Masonry.h"
@interface PostDetailVC ()<UITableViewDataSource, UITableViewDelegate, ReplyCellDelegate>
{
    
    CGFloat _h;
}
@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;
/**
 *  表格的头视图
 */
@property (nonatomic, strong) PostHeaderView * headerView;

@property (nonatomic, strong) PostDetailModel * detailModel;

@end

@implementation PostDetailVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏
    [self setUpNavigationBar];
    
    // 添加表格
    [self addTableView];
    // 添加底部评论框
    [self addBottomView];
    // 获取数据
    [self getData];
    
}

#pragma mark --- 设置导航栏内容
- (void)setUpNavigationBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark --- 返回上一个视图控制器
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 添加底部评论框
- (void)addBottomView
{
    UIView * bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];  // 不给颜色就会有透明效果
    [self.view addSubview:bottomView];
    bottomView.frame = CGRectMake(0, HEIGHT - 64 -92 * 0.5 * IPHONE6_H_SCALE, WIDTH, 92 * 0.5* IPHONE6_H_SCALE);
    UIView * line = [[UIView alloc] init];
    [bottomView addSubview:line];
    line.frame = CGRectMake(0, 0, WIDTH, 0.5);
    line.backgroundColor = Color216;
    
    // 评论按钮
    UIButton * commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:commentBtn];
    [commentBtn setImage:[UIImage imageNamed:@"pinglun_bianji"] forState:UIControlStateNormal];
    CGFloat commentX = 20 * IPHONE6_W_SCALE;
    CGFloat commentY = 12 * IPHONE6_H_SCALE;
    CGFloat commentW = 22 * IPHONE6_W_SCALE;
    CGFloat commentH = commentW;
    commentBtn.frame = CGRectMake(commentX, commentY, commentW, commentH);
    
    // 分享按钮
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [bottomView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(14 * IPHONE6_H_SCALE);
        make.right.equalTo(bottomView.mas_right).offset(-20 * IPHONE6_W_SCALE);
        make.width.equalTo(@(20 * IPHONE6_W_SCALE));
        make.height.equalTo(@(20 * IPHONE6_W_SCALE));
    }];
    
    // 收藏按钮
    UIButton * collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectBtn setImage:[UIImage imageNamed:@"shoucang_moren"] forState:UIControlStateNormal];
    [bottomView addSubview:collectBtn];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(23*0.5*IPHONE6_H_SCALE);
        make.right.equalTo(shareBtn.mas_left).offset(-31*IPHONE6_W_SCALE);
        make.width.equalTo(@(23*IPHONE6_W_SCALE));
        make.width.equalTo(@(23 * IPHONE6_W_SCALE));
    }];
    
    [commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn addTarget:self action:@selector(collecAction) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark --- 评论、分享、收藏事件
- (void)commentAction{
    // 进行回帖
    ReplyPostVC * replyVC = [[ReplyPostVC alloc] init];
    PostDaraModel * dataModel = [PostDaraModel objectWithKeyValues:_detailModel.data];
    replyVC.iD = dataModel.iD;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:replyVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (void)shareAction{
    
}

- (void)collecAction{
    
}

#pragma mark --- 添加标题
- (void)addTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64 - 92 *0.5*IPHONE6_H_SCALE) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"数据源的个数：%lu", self.dataSource.count);
    return self.dataSource.count;
//    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ReplyFrameModel * frameModel = self.dataSource[indexPath.row];
    ReplyCell * cell = [ReplyCell cellWithTableView:tableView WithArray:frameModel.replyModel.picname];
//    NSLog(@"%@", frameModel.replyModel.picname);
    cell.delegate = self;
    cell.frameModel = frameModel;
    
    cell.indexLbl.text = [NSString stringWithFormat:@"%lu楼", indexPath.row + 2];
    
    return cell;
    
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyFrameModel * frameModel = self.dataSource[indexPath.row];
    
//    NSLog(@"单元格的高度：%f    %lu", frameModel.cellHeight, indexPath.row);
    
    return frameModel.cellHeight;
}

#pragma mark --- 获取数据
- (void)getData{
        
    [DataTool getPostDetailDataWithStr:self.wapurl parameters:nil success:^(id responseObject) {
        
        PostDetailModel * detailModel = responseObject;
        _detailModel = detailModel;
        // 字典转模型
        PostDaraModel * dataModel = [PostDaraModel objectWithKeyValues:_detailModel.data];
        
        if (self.dataSource.count > 0) {
            [self.dataSource removeAllObjects];
        }
        
        NSArray * commentArr = dataModel.comment;
        for (ReplyModel * model in commentArr) {
            ReplyFrameModel * frameModel = [[ReplyFrameModel alloc] init];
            frameModel.replyModel = model;
            
//            NSLog(@"%@", frameModel.replyModel.picname);
            
            [self.dataSource addObject:frameModel];
        }
        
//        NSLog(@"%lu", self.dataSource.count);
        
        // 设置数据
        [self setData];
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取帖子详情页时出错：%@", error);
    }];
}
#pragma mark --- 设置数据
- (void)setData{
    // 字典转模型
    PostDaraModel * dataModel = [PostDaraModel objectWithKeyValues:_detailModel.data];
    // 添加表格的头视图
    PostHeaderView * headerView = [[PostHeaderView alloc] initWithArray:dataModel.imgs];
    headerView.dataModel = dataModel;
    
    self.tableView.tableHeaderView = headerView;
    
    _headerView = headerView;
    
}
#pragma mark --- ReplyCellDelegate
- (void)tableViewCell:(ReplyCell *)cell didClickedContentWithID:(NSString *)ID andModel:(ReplyModel *)model{
    
    // 进行回帖
    ReplyPostVC * replyVC = [[ReplyPostVC alloc] init];
    PostDaraModel * dataModel = [PostDaraModel objectWithKeyValues:_detailModel.data];
    replyVC.iD = dataModel.iD;
    replyVC.comm_id = model.comment_id;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:replyVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)tableViewCell:(ReplyCell *)cell didClickFaceWithModel:(ReplyModel *)model{
    StarVC * starVC = [[StarVC alloc] init];
    starVC.userURL = model.userurl;
    [self.navigationController pushViewController:starVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
