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
//  普通用户主页
#import "AnyBodyVC.h"
//
#import "SBModel.h"
// 登录页面
#import "LoginViewController.h"


#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"
#import "UMSocial.h"
#import "LSAlertView.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
@interface PostDetailVC ()<UITableViewDataSource, UITableViewDelegate, ReplyCellDelegate, LSAlertViewDeleagte, UMSocialUIDelegate, PostHeaderViewDelegate>
{
    
    CGFloat _h;
    NSString * _noFirstIn;  // 是否第一次进入的标识
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

/**
 *  收藏按钮
 */
@property (nonatomic, strong) UIButton * collectBtn;

@property (nonatomic, strong) LSAlertView * alertView;

@property (nonatomic, strong) UIView * alertBackView;

@property (nonatomic, strong) SBModel * sbModel;
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
    
//    [self.tableView.header beginRefreshing];
    if (_noFirstIn && _noFirstIn.length > 0) {
        //        [self loadNewData];
        [self loadMoreData];
    }else{
        NSLog(@"这是第一次进入...");
    }
    _noFirstIn = @"noFirstIn";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSLog(@"%@", self.wapurl);
    
    // 设置导航栏
    [self setUpNavigationBar];
    
    // 添加表格
    [self addTableView];
    // 添加底部评论框
    [self addBottomView];
    // 获取数据
    [self getData];
    
}
#pragma mark --- 添加复制链接按钮
- (void)addCustomShareBtn
{
    
//    NSLog(@"%@", _detailModel.data);
    
    PostDaraModel * dataModel = [PostDaraModel objectWithKeyValues:_detailModel.data];
    UMSocialSnsPlatform *snsPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"CustomPlatform"];
    // 设置自定义分享按钮的名称
    snsPlatform.displayName = @"复制链接";
    // 设置自定义分享按钮的图标
    snsPlatform.bigImageName = @"fuzhilianjie";
    //    __weak typeof(self) weakSelf = self;
    // 监听自定义按钮的点击事件
    snsPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
        UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
        NSString * str = dataModel.wapurl;

        pastboad.string = str;
        
//        NSLog(@"复制的链接：%@", _wapurl);
        [SVProgressHUD showSuccessWithStatus:@"复制链接成功"];
        
    };
    
    // 添加自定义平台
    [UMSocialConfig addSocialSnsPlatform:@[snsPlatform]];
    // 设置你要在分享面板中出现的平台
    [UMSocialConfig setSnsPlatformNames:@[UMShareToSina ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,@"CustomPlatform"]];
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
    [collectBtn setImage:[UIImage imageNamed:@"shoucang_xuanzhong"] forState:UIControlStateSelected];
    _collectBtn = collectBtn;
    
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
// 分享
- (void)shareAction{
    
    PostDaraModel * dataModel = [PostDaraModel objectWithKeyValues:_detailModel.data];
    NSString *st = dataModel.imgs[0];
    NSURL *url = [NSURL URLWithString:st];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    
    NSString * wapurl = dataModel.wapurl;
    
    // 友盟分享代码，复制、粘贴
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55556bc8e0f55a56230001d8"
                                      shareText:[NSString stringWithFormat:@"%@ %@",dataModel.title,dataModel.content]
                                     shareImage:img
                                shareToSnsNames:@[UMShareToSina ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,@"CustomPlatform"]
                                       delegate:self]; // 分享到朋友圈、微信好友、QQ空间、QQ好友
    
    // 下面的三段代码是什么意思？ 解释：加上下面的几句话才能将网页内容分享成功
    // 分享到各个平台的内容  如果没有下面的代码就会跳到友盟首页（自己设置的URL）
    NSString * URL = [wapurl stringByAppendingString:@"?isshare=1"];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = URL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = URL;
    [UMSocialData defaultData].extConfig.qqData.url = URL;
    [UMSocialData defaultData].extConfig.qzoneData.url = URL;
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:URL];
}

- (void)collecAction{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if (userName || wxData) { // 如果已经登录
        if (!_collectBtn.selected) {  // 如果收藏按钮没有被选中
            
            // 进行收藏
            [self collectOrCancelCollect];
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        } else{     // 如果收藏按钮被选中
            
            [self collectOrCancelCollect];
            [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
            
        }
        _collectBtn.selected = !_collectBtn.selected;
    } else  // 如果没有登录
    {
        [self addAlertView];
    }
    
}

#pragma mark --- 收藏或取消收藏
- (void)collectOrCancelCollect{
    
    // 字典转模型
    PostDaraModel * dataModel = [PostDaraModel objectWithKeyValues:_detailModel.data];
    NSString * url = [CollectionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", dataModel.iD]];
    //            NSLog(@"进行收藏的接口----%@", url);
    [DataTool getCollectWithStr:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"收藏返回的数据%@", responseObject);
        NSLog(@"%@", responseObject[@"content"]);
        
    } failure:^(NSError * error) {
        
        NSLog(@"收藏的错误信息--%@", error);
    }];
}

#pragma mark --- 添加登录的alertView
- (void)addAlertView{
    LSAlertView * alertView = [[LSAlertView alloc] init];
    alertView.messageLbl.text = @"请在登录后进行操作";
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

#pragma mark --- 添加标题
- (void)addTableView{
    if (self.height) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64 - 92 *0.5*IPHONE6_H_SCALE) style:UITableViewStylePlain];
    }else{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64 - 92 *0.5*IPHONE6_H_SCALE) style:UITableViewStylePlain];
    }
    
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
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
    [DataTool getPostDetailDataWithStr:self.wapurl parameters:nil success:^(id responseObject) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
//        NSLog(@"%@", self.wapurl);
        
        PostDetailModel * detailModel = responseObject;
        _detailModel = detailModel;
        // 字典转模型
        PostDaraModel * dataModel = [PostDaraModel objectWithKeyValues:_detailModel.data];
        
        NSArray * commentArr = dataModel.comment;
        NSMutableArray * arr = [NSMutableArray array];
        for (ReplyModel * model in commentArr) {
            ReplyFrameModel * frameModel = [[ReplyFrameModel alloc] init];
            frameModel.replyModel = model;
            [arr addObject:frameModel];
        }
        self.dataSource = arr;
        
        // 设置数据
        [self setData];
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取帖子详情页时出错：%@", error);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}
- (void)loadMoreData{
    
    ReplyFrameModel * frameModel = [self.dataSource lastObject];
    ReplyModel * replyModel = frameModel.replyModel;
    NSString * commentId = replyModel.comment_id;
    // 字典转模型
    PostDaraModel * dataModel = [PostDaraModel objectWithKeyValues:_detailModel.data];
    NSString * iD = dataModel.iD;
    NSString * url = [ListOfReplyURL stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", iD, commentId]];
    NSLog(@"%@", url);

    [DataTool GetMoreReplyOfPostWithStr:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"---responseObject---%@", responseObject);
        if (!responseObject) {
            [self.tableView.footer noticeNoMoreData];
        }else{
             [self.tableView.footer endRefreshing];
        }
        for (ReplyModel * model in responseObject) {
            ReplyFrameModel * frameModel = [[ReplyFrameModel alloc] init];
            frameModel.replyModel = model;
            [self.dataSource addObject:frameModel];
        }
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取更多的回帖失败:%@", error);
        [self.tableView.footer endRefreshing];
    }];

}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ReplyFrameModel * frameModel = self.dataSource[indexPath.row];
    ReplyCell * cell = [ReplyCell cellWithTableView:tableView WithArray:frameModel.replyModel.picname];
    cell.delegate = self;
    cell.frameModel = frameModel;
    
    cell.indexLbl.text = [NSString stringWithFormat:@"%lu楼", indexPath.row + 2];
    return cell;
    
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyFrameModel * frameModel = self.dataSource[indexPath.row];
    
//    NSLog(@"%f", frameModel.cellHeight);
    return frameModel.cellHeight;
//    return 200;
}

#pragma mark --- 获取数据
- (void)getData{
        
    
}
#pragma mark --- 设置数据
- (void)setData{
    // 字典转模型
    PostDaraModel * dataModel = [PostDaraModel objectWithKeyValues:_detailModel.data];
    // 添加表格的头视图
//    PostHeaderView * headerView = [[PostHeaderView alloc] initWithArray:dataModel.imgs];
    PostHeaderView * headerView = [[PostHeaderView alloc] init];
    
//    headerView.backgroundColor = [UIColor redColor];
    headerView.delegate = self;
    headerView.dataModel = dataModel;
    self.tableView.tableHeaderView = headerView;
    
    _headerView = headerView;
    
    // 在分享中添加自定义按钮
    [self addCustomShareBtn];
    
    // 设置收藏按钮的状态
    if ([dataModel.is_collection isEqualToString:@"1"]) {
        _collectBtn.selected = YES;
    } else{
        _collectBtn.selected = NO;
    }
    
}

#pragma mark --- PostHeaderViewDelegate
- (void)PostHeaderView:(PostHeaderView *)headerView didClickFaceWith:(PostDaraModel *)model{
    StarVC * starVC = [[StarVC alloc] init];
    AnyBodyVC * anyVC = [[AnyBodyVC alloc] init];
    [DataTool getSBDataWithStr:model.userurl parameters:nil success:^(id responseObject) {
        SBModel * sbModel = [[SBModel alloc] init];
        sbModel = responseObject;
        if ([sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {   // 如果认证为空，就是普通人主页
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
#pragma mark --- 点击头像跳转到个人主页
- (void)tableViewCell:(ReplyCell *)cell didClickFaceWithModel:(ReplyModel *)model{
    
    StarVC * starVC = [[StarVC alloc] init];
    AnyBodyVC * anyVC = [[AnyBodyVC alloc] init];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
