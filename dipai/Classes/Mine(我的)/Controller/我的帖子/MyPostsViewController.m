//
//  MyPostsViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/30.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyPostsViewController.h"
// 用户模型
#import "UserModel.h"
// 发帖frame模型
#import "PostFrameModel.h"
// 发帖模型
#import "PostsModel.h"
#import "SBModel.h"

// 发帖单元格
#import "PostCell.h"
// 回复单元格
#import "MyReplyCell.h"
#import "MyReplyModel.h"
// 回复的frame模型
#import "MyReplyFrameModel.h"

// 帖子详情页
#import "PostDetailVC.h"
// 资讯页详情
#import "DetailWebViewController.h"
// 视频页详情
#import "VideoViewController.h"
// 赛事详情页
#import "MatchDetailVC.h"

#import "DataTool.h"
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "HttpTool.h"
#import "AFNetworking.h"
@interface MyPostsViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    // 滚动视图
    
    // 对应分段控件的三个tableView
    UITableView *_tableView1;
    UITableView *_tableView2;
}
typedef NS_ENUM(NSUInteger, LSType) {
    /** 资讯 */
    LSTypeInfo = 2,
    /** 图集 */
    LSTypePictures = 4,
    /** 赛事 */
    LSTypeMatch = 5,
    /** 赛事 详情页*/
    LSTypeMatchDetail = 51,
    /** 直播 */
    LSTypeLive = 6,
    /** 视频 */
    LSTypeVideo = 11,
    /** 帖子详情 */
    LSTypePostDetail = 172,
    
    /** 视频专辑 */
    LSTypeVideoList = 101,
    /** 全部视频专辑 */
    LSTypeAllVideo = 10,
    /** 帖子列表 */
    LSTypePostList = 171,
    /** 名人堂*/
    LSTypePokerStar = 151,
    /** 名人主页*/
    LSTypeStar = 153,
    /** 名人堂列表 */
    LSTypePokerStarList = 152,
    /** 俱乐部详细页面 */
    LSTypeClubDetail = 81,
    /** 专题 */
    LSTypeSpecial = 9,
    /** 专题列表 */
    LSTypeSpecialList = 18,
    
    // H5活动
    LSTypeH5 = 201
};
/**
 *  发帖标签
 */
@property (nonatomic, strong) UILabel * postsLbl;
/**
 *  发帖按钮
 */
@property (nonatomic, strong) UIButton * postBtn;

/**
 *  回复按钮
 */
@property (nonatomic, strong) UIButton * replyBtn;
/**
 *  回复标签
 */
@property (nonatomic, strong) UILabel * replyLbl;

/**
 *  红色的下划线
 */
@property (nonatomic, strong) UIView * redView;

@property (nonatomic, strong) UIScrollView *sc;

/**
 *  发帖数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource1;
/**
 *  回复数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource2;

@property (nonatomic, strong) SBModel * sbModel;
// 没有发帖的提示图
@property (nonatomic, strong) UIImageView * imageV;
// 没有回复的提示图
@property (nonatomic, strong) UIImageView * replyV;

@end

@implementation MyPostsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    // 设置导航栏
    [self setNavigationBar];
    
    [self addScrollView];
    // 设置UI
    [self setUpUI];
}

#pragma mark --- 设置导航条
- (void)setNavigationBar {
    self.naviBar.titleStr = @"我的帖子";
    self.naviBar.popV.hidden = NO;
    self.naviBar.backgroundColor = [UIColor whiteColor];
    self.naviBar.bottomLine.hidden = NO;
    self.naviBar.titleLbl.textColor = [UIColor blackColor];
    self.naviBar.popImage = [UIImage imageNamed:@"houtui"];
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark --- 设置UI
- (void)setUpUI{
    // 添加分割条
    UIView * separateView = [[UIView alloc] init];
    [self.view addSubview:separateView];
    separateView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    separateView.frame = CGRectMake(0, 81 * 0.5 * IPHONE6_H_SCALE+64, WIDTH, 20 * IPHONE6_H_SCALE);
    
    UIView * topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.frame = CGRectMake(0, 64, WIDTH, 81 * 0.5 * IPHONE6_H_SCALE);
    [self.view addSubview:topView];
    
    // 添加我的发帖和我的回复两个标题
    UILabel * postsLbl = [[UILabel alloc] init];
//    postsLbl.backgroundColor = [UIColor redColor];
    postsLbl.font = Font15;
    postsLbl.text = @"我的发帖";
    postsLbl.textColor = Color102;
    [topView addSubview:postsLbl];
    postsLbl.frame = CGRectMake(102 * IPHONE6_W_SCALE, 0, 61 * IPHONE6_W_SCALE+2, 81 * 0.5 * IPHONE6_H_SCALE);
    _postsLbl = postsLbl;
    
    // 获取发帖按钮
    UIButton * postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:postBtn];
    postBtn.frame = CGRectMake(102 * IPHONE6_W_SCALE, 0, 61 * IPHONE6_W_SCALE, 81 * 0.5 * IPHONE6_H_SCALE);
    [postBtn addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventTouchUpInside];
    postBtn.selected = YES;
    postsLbl.textColor = [UIColor redColor];
    
    UILabel * replyLbl = [[UILabel alloc] init];
    replyLbl.font = Font15;
    replyLbl.text = @"我的回复";
    replyLbl.textColor = Color102;
    [topView addSubview:replyLbl];
    CGFloat replyX = CGRectGetMaxX(postsLbl.frame) + 49 * IPHONE6_W_SCALE;
    replyLbl.frame = CGRectMake(replyX, 0, 61 * IPHONE6_W_SCALE+2, 81 * 0.5 * IPHONE6_W_SCALE);
    _replyLbl = replyLbl;
    
    // 获取回复按钮
    UIButton * replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    replyBtn.backgroundColor = [UIColor greenColor];
    replyBtn.userInteractionEnabled = YES;
    [topView addSubview:replyBtn];
    replyBtn.frame = CGRectMake(replyX, 0, 61 * IPHONE6_W_SCALE, 81 * IPHONE6_W_SCALE);
    [replyBtn addTarget:self action:@selector(getReplys) forControlEvents:UIControlEventTouchUpInside];
    
    // 红色的下划线
    UIView * redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [topView addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(postsLbl.mas_centerX);
        make.top.equalTo(postsLbl.mas_bottom).offset(-2*IPHONE6_H_SCALE);
        make.width.equalTo(@(158*0.5*IPHONE6_W_SCALE));
        make.height.equalTo(@(2* IPHONE6_H_SCALE));
    }];
    _redView = redView;
    
}

#pragma mark --- 获取我的帖子的点击事件
- (void)getPosts{
    NSLog(@"发帖");
    // 滚动视图的偏移量
    
    [UIView animateWithDuration:0.25 animations:^{
        self.sc.contentOffset = CGPointMake(0, 0);
    } completion:nil];
    // 获取发帖
    [self postAction];
}

- (void)postAction{
    _replyBtn.selected = NO;
    _postsLbl.textColor = [UIColor redColor];
    _replyLbl.textColor = Color102;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat x = CGRectGetMinX(_postsLbl.frame) - 9 * IPHONE6_W_SCALE;
        CGFloat y = CGRectGetMaxY(_postsLbl.frame) - 2*IPHONE6_H_SCALE;
        CGFloat w = 158 * 0.5 * IPHONE6_W_SCALE;
        CGFloat h = 2 * IPHONE6_H_SCALE;
        _redView.frame = CGRectMake(x, y, w, h);
        
    } completion:nil];
}
#pragma mark --- 获取我的回复的点击事件
- (void)getReplys{
    NSLog(@"回复");
    // 加个动画就可以实现滑动了？  这是什么情况？
    [UIView animateWithDuration:0.25 animations:^{
        self.sc.contentOffset = CGPointMake(WIDTH, 0);
    } completion:nil];
    [self replyAction];
}
// 获取回复
- (void)replyAction{
    _postBtn.selected = NO;
    _postsLbl.textColor = Color102;
    _replyLbl.textColor = [UIColor redColor];
    [UIView animateWithDuration:0.25 animations:^{
        
        CGFloat x = CGRectGetMinX(_replyLbl.frame) - 9 * IPHONE6_W_SCALE;
        CGFloat y = CGRectGetMaxY(_replyLbl.frame) - 2*IPHONE6_H_SCALE;
        CGFloat w = 158 * 0.5 * IPHONE6_W_SCALE;
        CGFloat h = 2 * IPHONE6_H_SCALE;
        _redView.frame = CGRectMake(x, y, w, h);
    } completion:nil];
}

#pragma mark --- 添加滚动视图
- (void)addScrollView {
    
    CGFloat scY = 121 * 0.5 * IPHONE6_H_SCALE+64;
    self.sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, scY, WIDTH , HEIGHT - scY)];
    self.sc.contentSize=CGSizeMake(WIDTH * 2 , HEIGHT - 64-scY);
    self.sc.delegate=self;
    self.sc.bounces=NO;
    self.sc.showsHorizontalScrollIndicator = YES;
    self.sc.showsVerticalScrollIndicator = YES;
    self.sc.pagingEnabled=YES;
    self.sc.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.sc];
    
    // 在滚动视图上添加tableView
    [self addTableView];
}
#pragma mark --- 添加tableView
- (void)addTableView{
    CGFloat scY = 121 * 0.5 * IPHONE6_H_SCALE;
    _tableView1 = [[UITableView alloc]initWithFrame:self.sc.bounds style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_sc addSubview:_tableView1];
    
    UIImageView * imageV = [[UIImageView alloc] init];
    [_sc addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"meiyoutiezi"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tableView1.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(221 * IPHONE6_H_SCALE);
        make.width.equalTo(@(215 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(181 * 0.5 * IPHONE6_W_SCALE));
    }];
    _imageV = imageV;
    _imageV.hidden = YES;
    
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH , HEIGHT - 64 - scY) style:UITableViewStylePlain];
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.sc addSubview:_tableView2];

    UIImageView * replyV = [[UIImageView alloc] init];
    replyV.image = [UIImage imageNamed:@"haiyouhuifu"];
    [self.sc addSubview:replyV];
    [replyV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tableView2.mas_centerX);
        make.top.equalTo(imageV.mas_top);
        make.width.equalTo(imageV.mas_width);
        make.height.equalTo(imageV.mas_height);
    }];
    _replyV = replyV;
    _replyV.hidden = YES;
    
    // 添加刷新和加载
    [self addRefreshWith:_tableView1];
    
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData2)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView2.header = header;
    [header beginRefreshing];
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData2)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    _tableView2.footer = footer;
}
#pragma mark --- 添加刷新和加载
- (void)addRefreshWith:(UITableView *)tableView{
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    tableView.header = header;
    [header beginRefreshing];
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    tableView.footer = footer;
}
#pragma mark --- 加载和刷新
// 刷新
- (void)loadNewData{
    
    NSString * url = [MyPostsURL stringByAppendingString:self.userModel.userid];
    
//    NSLog(@"%@", url);
    [DataTool getMyPostsDataWithStr:url parameters:nil success:^(id responseObject) {
        [_tableView1.header endRefreshing];
//        NSLog(@"获取我的发帖获取到的数据:%@", responseObject);
        
        if ([responseObject isKindOfClass:[NSString class]]) {
            NSLog(@"发帖为空");
            _imageV.hidden = NO;
        }else{
            _imageV.hidden = YES;
            NSMutableArray * arr = [NSMutableArray array];
            for (PostsModel * model in responseObject) {
                PostFrameModel * frameModel = [[PostFrameModel alloc] init];
                frameModel.postsModel = model;
                [arr addObject:frameModel];
            }
            self.dataSource1 = arr;
        }
        
        [_tableView1 reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取我的发帖失败：%@", error);
        [_tableView1.header endRefreshing];
    }];
    
    
}
// 加载
- (void)loadMoreData{

    PostFrameModel * frameModel = [self.dataSource1 lastObject];
    PostsModel * postModel = frameModel.postsModel;
    NSString * iD = postModel.iD;   // 帖子ID
    NSString * uid = postModel.uid; // 用户ID
    
    NSString * url = [MorePostsURL stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", uid, iD]];
    
    NSLog(@"%@", url);
    
    [DataTool GetMorePostsDataWithStr:url parameters:nil success:^(id responseObject) {
        
        [_tableView1.footer endRefreshing];
        
        SBModel * sbModel = [[SBModel alloc] init];
        sbModel = responseObject;
        _sbModel = sbModel;
        if (!sbModel.app_my) {
//            _tableView1.footer.state = MJRefreshStateNoMoreData;
            [SVProgressHUD showSuccessWithStatus:@"没有更多数据"];
        }
        for (PostsModel * model in sbModel.app_my) {
            PostFrameModel * frameModel = [[PostFrameModel alloc] init];
            frameModel.postsModel = model;
            [self.dataSource1 addObject:frameModel];
        }
        [_tableView1 reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取个人主页出错：%@", error);
        [_tableView1.footer endRefreshing];
    }];
    
}
// 加载回复和刷新回复
- (void)loadNewData2{
    
    [DataTool getMyReplysDataWithStr:MyReplyURL parameters:nil success:^(id responseObject) {
        [_tableView2.header endRefreshing];
        [_tableView2.footer endRefreshing];
//        NSLog(@"%@", responseObject);
        
        if ([responseObject isKindOfClass:[NSString class]]) {
            NSLog(@"回复为空...");
            _replyV.hidden = NO;
        }else{
            _replyV.hidden = YES;
            NSMutableArray * arr = [NSMutableArray array];
            for (MyReplyModel * model in responseObject) {
                MyReplyFrameModel * frameModel = [[MyReplyFrameModel alloc] init];
                frameModel.myreplyModel = model;
                [arr addObject:frameModel];
            }
            self.dataSource2 = arr;
        }
        
        
//        NSLog(@"%@", self.dataSource2);
        [_tableView2 reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取我的回复出错：%@", error);
        [_tableView2.header endRefreshing];
    }];
}
- (void)loadMoreData2{
    // 上拉加载获取更多回复
    MyReplyFrameModel * myReFrameModel = [self.dataSource2 lastObject];
    MyReplyModel * myReModel = myReFrameModel.myreplyModel;
    NSString * userid = myReModel.userid;
    NSString * comment_id = myReModel.comment_id;
    NSString * url = [MoreReplysURL stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", userid, comment_id]];
    
    NSLog(@"%@", url);
    
    [DataTool getMoreReplysDataWithStr:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"-----%@", responseObject);
        [_tableView2.footer endRefreshing];
        if (!responseObject) {
//            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了"];
            _tableView2.footer.state = MJRefreshStateNoMoreData;
        }
        for (MyReplyModel * model in responseObject) {
            MyReplyFrameModel * myReFrameModel = [[MyReplyFrameModel alloc] init];
            myReFrameModel.myreplyModel = model;
            [self.dataSource2 addObject:myReFrameModel];
        }
        [_tableView2 reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取更多回复出错：%@", error);
        
    }];
}
#pragma mark --- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        return self.dataSource1.count;
    }else{
        return self.dataSource2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) { // 发帖
        PostCell * cell = [PostCell cellWithTableView:tableView];
        PostFrameModel * frameModel = self.dataSource1[indexPath.row];
        cell.frameModel = frameModel;
        return cell;
    }else{  // 回复
        
        MyReplyCell * cell = [MyReplyCell cellWithTableView:tableView];
        cell.myReplyFrameModel = self.dataSource2[indexPath.row];
        return cell;
        
    }
}

#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) {
        NSLog(@"%lu", self.dataSource2.count);
        PostFrameModel * frameModel = self.dataSource1[indexPath.row];
        CGFloat cellHeight = frameModel.cellHeight;
        return cellHeight;
    } else{
        MyReplyFrameModel * myReFrameModel = self.dataSource2[indexPath.row];
        
        return myReFrameModel.cellHeight;
    } 
   
}
#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) { // 我的发帖页面
        // 跳转到帖子详情页
        PostDetailVC * detailVC = [[PostDetailVC alloc] init];
        PostFrameModel * model = self.dataSource1[indexPath.row];
        detailVC.wapurl = model.postsModel.wapurl;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{  // 我的回复页面
        
        // 回复的情况：1.资讯／图集  2.视频  3.帖子  4.赛事评论
        MyReplyFrameModel * myReFrameModel = self.dataSource2[indexPath.row];
        MyReplyModel * replyModel = myReFrameModel.myreplyModel;
        NSString * url = replyModel.userurl;
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        //设置监听
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                NSLog(@"没有网络");
                [SVProgressHUD showErrorWithStatus:@"无网络连接"];
            }else{
            }
        }];
        [manager startMonitoring];        
        [HttpTool GET:url parameters:nil success:^(id responseObject) {
            
            NSString * type = responseObject[@"type"];
            NSInteger num = [type integerValue];
            NSLog(@"type:%lu", num);
            if (num == LSTypeInfo || num == LSTypePictures) {
                // 跳转到资讯页面或图集页面
                DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
                detailVC.url = url;
                detailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailVC animated:YES];
            } else if (num == LSTypeVideo){ // 如果是视频
                // 跳转到视频专辑页
                VideoViewController * videoVC = [[VideoViewController alloc] init];
                videoVC.url = url;
                videoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:videoVC animated:YES];
            } else if (num == LSTypeMatchDetail){  // 如果是赛事详情页
                MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
                detailVC.wapurl = url;
                detailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailVC animated:YES];
            }else if (num == LSTypePostDetail){ // 如果是帖子详情页
                PostDetailVC * postDetail =[[PostDetailVC alloc] init];
                postDetail.wapurl = url;
                postDetail.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:postDetail animated:YES];
            }else if (num == LSTypePokerStar){  // 扑克名人堂页面
                
            }else if (num == LSTypePokerStarList){  // 扑克名人堂列表
                
            }else if (num == LSTypePostList){   // 帖子列表
                
            }else if (num == LSTypeVideoList){  // 视频专辑
                
            }else if (num == LSTypeClubDetail){ // 俱乐部详情页
                
            }else if (num == LSTypeSpecial){    // 专题
                
            }else if (num == LSTypeSpecialList){    // 专题列表
                
            }else if (num == LSTypeAllVideo){   // 全部视频专辑
                
            }else if (num == LSTypeStar){   // 名人主页
                
            }
            else if(num == LSTypeH5){  // 如果是内部H5页面
                
            }
            else{   // 未识别type
                NSLog(@"---%@",url);
                
            }
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
            NSLog(@"出错：%@",error);
        }];

    }
}

#pragma mark ---  滚动视图结束滚动后
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.sc.contentOffset.x == 0) {
        [self postAction];
    }else {
        [self replyAction];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
