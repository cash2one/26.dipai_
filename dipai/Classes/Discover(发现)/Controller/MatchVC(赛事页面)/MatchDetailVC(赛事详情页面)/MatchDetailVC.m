//
//  MatchDetailVC.m
//  dipai
//
//  Created by 梁森 on 16/6/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MatchDetailVC.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 自定义头视图
#import "HeaderViewInMatch.h"
// 进行中赛事的头视图
#import "MatchingHeader.h"

// 比赛模型
#import "EndMatchModel.h"
// 赛事详情页模型(进行中的赛事)
#import "MatchingModel.h"
// 有直播信息模型
#import "LiveModel.h"
// 直播信息模型
#import "LiveInfoModel.h"

// 资讯页模型
#import "NewsListModel.h"
// 资讯页单元格
#import "InformationCell.h"
// 网页详情页
#import "DetailWebViewController.h"
#import "LSAlertView.h"
// 登录页面
#import "LoginViewController.h"
// 评论页的单元格
#import "CommentsTableViewCell.h"
// 评论frame模型
#import "CommentsFrame.h"
// 评论模型
#import "CommentsModel.h"
// 某个人的模型
#import "SBModel.h"
// 普通用户主页
#import "AnyBodyVC.h"
// 名人主页
#import "StarVC.h"

#import "DataLiveModel.h"
//  直播单元格
#import "LiveCell.h"
// 评论视图
#import "CommentView.h"

#import "DataTool.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "UMSocial.h"
#import "UIImageView+WebCache.h"
@interface MatchDetailVC ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, CommentViewDelegate, LSAlertViewDeleagte, CommentsTableViewCellDelegate, LiveCellDelegate, UMSocialUIDelegate>
{
    UISegmentedControl *_segmented;
    // 滚动视图
    UIScrollView *_sc;
    // 发表的内容
    NSString * _sendContent;
    
    // 回复的ID
    NSString * _replyID;
    
    // 判断是否点击回复
    NSString * _reply;
    
    // 回复的用户名
    NSString * _replyName;
    
    // 选择赛事的下标
    NSString * _index;
    
    NSString * _shareURL;   // 分享的字符串
    
    NSString * _appendStr;   // 拼接的字符串
    
    NSString * _refresh;    // 是否刷新表格
}
// 三个表格
@property (nonatomic, strong) UITableView * tableView1;
@property (nonatomic, strong) UITableView * tableView2;
@property (nonatomic, strong) UITableView * tableView3;
// 三个数据源
@property (nonatomic, strong) NSMutableArray * dataSource1;
@property (nonatomic, strong) NSMutableArray * dataSource2;
@property (nonatomic, strong) NSMutableArray * dataSource3;
@property (nonatomic, strong) NSMutableArray * dataSource11;    // 待用数据源1

/**
 *  自定义的头视图
 */
@property (nonatomic, strong) MatchingHeader * headerView1;
@property (nonatomic, strong) HeaderViewInMatch * headerView2;

@property (nonatomic, strong) MatchingHeader * headerView;
/**
 *  赛事模型
 */
@property (nonatomic, strong) MatchingModel * matchingModel;

/**
 *  当前赛事
 */
@property (nonatomic, strong) UILabel * dayLbl;
/**
 *  当前赛事按钮
 */
@property (nonatomic, strong) UIButton * dayBtn;
/**
 *  赛事菜单
 */
@property (nonatomic, strong) UIView * menuView;

/*****************评论按钮************/
@property (nonatomic, strong) UIView * backView;
// 评论视图
@property (nonatomic, strong) CommentView * commentView;
// 提示框
@property (nonatomic, strong) LSAlertView * alertView;
@property (nonatomic, strong) UIView * alertBackView;
// 评论模型
@property (nonatomic, strong) CommentsModel * commentModel;

// 名人或普通用户的模型
@property (nonatomic, strong) SBModel * sbModel;
/**
 *  回复视图
 */
@property (nonatomic, strong) UIImageView * replyView;

// 放大图片的背景图
@property (nonatomic, strong) UIView * picBackView;
// 放大图片的滚动视图
@property (nonatomic, strong) UIScrollView * picSc;
// 放大的图片
@property (nonatomic, strong) UIImageView * image;
// 没有评论的展示图
@property (nonatomic, strong) UIImageView * commentV;
// 没有相关资讯的展示图
@property (nonatomic, strong) UIImageView * infoV;

// 新消息
@property (nonatomic, strong) UILabel * messageL;
@property (nonatomic, strong) UIImageView * messageV;
@end

@implementation MatchDetailVC

- (void)tableViewCell:(CommentsTableViewCell *)cell dicClickFaceWithModel:(CommentsModel *)model{
    NSLog(@"点击头像");
}

- (NSMutableArray *)dataSource1{
    if (_dataSource1 == nil) {
        _dataSource1 = [NSMutableArray array];
    }
    return _dataSource1;
}

- (NSMutableArray *)dataSource2{
    if (_dataSource2 == nil) {
        _dataSource2 = [NSMutableArray array];
    }
    return _dataSource2;
}
- (NSMutableArray *)dataSource3{
    if (_dataSource3 == nil) {
        _dataSource3 = [NSMutableArray array];
    }
    return _dataSource3;
}
- (NSMutableArray *)dataSource11{
    if (_dataSource11 == nil) {
        _dataSource11 = [NSMutableArray array];
    }
    return _dataSource11;
}
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    NSLog(@"%@", self.wapurl);
    
    // 设置导航栏
    [self setUpNavigationBar];
    
    // 添加头视图
    [self addHeaderView];
    // 对键盘添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 监听通知  选择赛事按钮一旦被点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanValueAction:) name:@"cleanValueNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeShareURL:) name:@"changeShareURL" object:nil];
    [self addCustomShareBtn];
}

#pragma mark --- 添加复制链接按钮
- (void)addCustomShareBtn
{
    
//    NSLog(@"%@", _shareURL);
    UMSocialSnsPlatform *snsPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"CustomPlatform"];
    // 设置自定义分享按钮的名称
    snsPlatform.displayName = @"复制链接";
    // 设置自定义分享按钮的图标
    snsPlatform.bigImageName = @"fuzhilianjie";
    //    __weak typeof(self) weakSelf = self;
    // 监听自定义按钮的点击事件
    snsPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
        UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
        pastboad.string = _shareURL;
        NSLog(@"复制的链接：%@", _shareURL);
        [SVProgressHUD showSuccessWithStatus:@"复制链接成功"];
        
    };
    
    // 添加自定义平台
    [UMSocialConfig addSocialSnsPlatform:@[snsPlatform]];
    // 设置你要在分享面板中出现的平台
    [UMSocialConfig setSnsPlatformNames:@[UMShareToSina ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,@"CustomPlatform"]];
}
// 移除通知
- (void)dealloc {
    // 指定名字移除接收器
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cleanValueAction" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeShareURL" object:nil];
    
}

#pragma mark --- 键盘发生变化后通知
- (void)keyBoardChanged:(NSNotification *)note
{
    // 键盘的大小
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 键盘出现的时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (frame.origin.y == HEIGHT) {   // 当键盘没有弹出的时候
        
        [UIView animateWithDuration:duration animations:^{
            
            _commentView.transform = CGAffineTransformIdentity;
        }];
    } else
    {
        [UIView animateWithDuration:duration animations:^{
            
            _commentView.transform = CGAffineTransformMakeTranslation(0, -(frame.size.height + Margin242 * IPHONE6_H_SCALE));
        }];
    }
}

#pragma mark --- 设置导航栏
- (void)setUpNavigationBar{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui_baise"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 添加头视图
- (void)addHeaderView{
    
    // 获取数据
    [self getData];
    
    
}
#pragma mark --- 添加头视图的子视图
// 有直播的头视图
- (void)addHeaderView1{
    
    MatchingHeader * headerView = [[MatchingHeader alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 326 * 0.5 * IPHONE6_H_SCALE)];
    
    // 设置数据
    headerView.titleLbl.text = _matchingModel.title;
    NSArray * liveModelArr = _matchingModel.app_live;   // 模型数组
    LiveModel * live = [liveModelArr firstObject];
    
    headerView.stateLbl.text = [NSString stringWithFormat:@"比赛状态:%@", live.match_state];
    headerView.blindNum.text = live.blind;  // 盲注
    //    NSLog(@"---blind---%@", live.blind);
    headerView.score.text = live.score; // 记分牌
    headerView.players.text = live.player;  // 剩余选手
    [self.view addSubview:headerView];
    _headerView = headerView;
    
    //
    UIView * dayView = [[UIView alloc] init];
    dayView.layer.masksToBounds = YES;
    dayView.layer.cornerRadius = 2;
    dayView.layer.borderWidth = 0.5;
    dayView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [headerView addSubview:dayView];
    [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(36 * IPHONE6_W_SCALE);
        make.top.equalTo(headerView.mas_top).offset(12 * IPHONE6_W_SCALE);
        make.width.equalTo(@(148*0.5*IPHONE6_W_SCALE));
        make.height.equalTo(@(21*IPHONE6_H_SCALE));
    }];
    
    // 赛事day
    UILabel * dayLbl = [[UILabel alloc] init];
    dayLbl.font = Font13;
    dayLbl.textColor = [UIColor whiteColor];
    [dayView addSubview:dayLbl];
    [dayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dayView.mas_left).offset(12.5 * IPHONE6_W_SCALE);
        make.top.equalTo(dayView.mas_top);
        make.bottom.equalTo(dayView.mas_bottom);
        make.right.equalTo(dayView.mas_right);
    }];
    _dayLbl = dayLbl;
    
    UIImageView * picView = [[UIImageView alloc] init];
    //    picView.userInteractionEnabled = YES;
    picView.image = [UIImage imageNamed:@"icon_xialasanjiao"];
    [dayView addSubview:picView];
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dayView.mas_right).offset(-7*IPHONE6_W_SCALE);
        make.top.equalTo(dayView.mas_top).offset(8.5*IPHONE6_W_SCALE);
        make.width.equalTo(@(6 * IPHONE6_W_SCALE));
        make.height.equalTo(@(4 * IPHONE6_W_SCALE));
    }];
    
    UIButton * dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dayView addSubview:dayBtn];
    [dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dayView.mas_left);
        make.right.equalTo(dayView.mas_right);
        make.top.equalTo(dayView.mas_top);
        make.bottom.equalTo(dayView.mas_bottom);
    }];
    //    dayBtn.backgroundColor = [UIColor redColor];
    [dayBtn addTarget:self action:@selector(clickDayBtn) forControlEvents:UIControlEventTouchUpInside];
    _dayBtn = dayBtn;
    
    dayLbl.text = live.name;
    
    
    
}
#pragma mark --- 添加下拉菜单
- (void)addMenuWithNum:(NSInteger)count{
    
}

#pragma mark ---  clickDayBtn
- (void)clickDayBtn{
    
    // 这样是很消耗内存的，需要优化一下
    
    NSLog(@".....");
    UIView * menuView = [[UIView alloc] init];
    // 添加下拉菜单
    [_headerView addSubview:menuView];
    _menuView = menuView;
    NSInteger count = _matchingModel.app_live.count;    // 直播数量
    //    NSInteger count = 3;
    CGFloat menuH = (52+62*(count-1))*0.5;
    menuView.frame = CGRectMake(36*IPHONE6_W_SCALE, 12*IPHONE6_H_SCALE, 148*0.5*IPHONE6_W_SCALE, menuH);
    
    menuView.layer.masksToBounds = YES;
    menuView.layer.cornerRadius = 2;
    menuView.layer.borderWidth = 0.5;
    menuView.layer.borderColor = [[UIColor whiteColor] CGColor];
    menuView.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.9];
    
    UIImageView * picView = [[UIImageView alloc] init];
    [menuView addSubview:picView];
    picView.image = [UIImage imageNamed:@"icon_xialasanjiao"];
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(menuView.mas_right).offset(-7*IPHONE6_W_SCALE);
        make.top.equalTo(menuView.mas_top).offset(17*0.5*IPHONE6_H_SCALE);
        make.width.equalTo(@(6*IPHONE6_W_SCALE));
        make.height.equalTo(@(4*IPHONE6_W_SCALE));
    }];
    
    // 分割线
    for (int i = 0; i < count-1; i ++) {
        UIView * separateView = [[UIView alloc] init];
        [menuView addSubview:separateView];
        CGFloat y = 26*IPHONE6_H_SCALE;
        separateView.frame = CGRectMake(0, y + i*(31+0.5), 148*0.5*IPHONE6_W_SCALE, 0.5);
        separateView.backgroundColor = [UIColor colorWithRed:58 / 255.f green:58 / 255.f blue:58 / 255.f alpha:1];
    }
    for (int i = 0; i < count; i ++) {
        UILabel * dayLbl = [[UILabel alloc] init];
        dayLbl.font = Font13;
        dayLbl.textColor = [UIColor whiteColor];
        //        dayLbl.backgroundColor = [UIColor redColor];
        [menuView addSubview:dayLbl];
        CGFloat dayLblX = 12.5*IPHONE6_W_SCALE;
        CGFloat dayLblW = (148-25)*0.5*IPHONE6_W_SCALE;
        dayLbl.frame = CGRectMake(dayLblX, 7+i*(18+13), dayLblW, 13);
        LiveModel * model = _matchingModel.app_live[i];
        dayLbl.text = model.name;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuView addSubview:btn];
        //        btn.backgroundColor = [UIColor redColor];
        btn.tag = i;
        btn.frame = CGRectMake(0, 0 + i*(26*IPHONE6_H_SCALE), 148*0.5*IPHONE6_W_SCALE, 26*IPHONE6_H_SCALE);
        [btn addTarget:self action:@selector(changeDay:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
// 点击按钮观看不同的比赛
- (void)changeDay:(UIButton *)btn{
    //    NSLog(@"%lu", btn.tag);
    NSInteger index = btn.tag;
    [_menuView removeFromSuperview];
    LiveModel * model = _matchingModel.app_live[index];
    
    //    NSLog(@"%@", model.name);
    
    _dayLbl.text = model.name;
    //    NSLog(@"%@", model.wapurl);
    
    
    NSString * indexStr = [NSString stringWithFormat:@"%lu", index];
    // 利用通知来查看不同的赛事
    // 发送通知  将点击的按钮下表发送出去
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanValueNotification" object:indexStr];
    [_tableView1.header beginRefreshing];
}

- (void)addHeaderView2{
    
    // 只有即将开始的页面是固定的
    HeaderViewInMatch * headerView = [[HeaderViewInMatch alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 290 * 0.5 * IPHONE6_H_SCALE)];
    headerView.matchModel = _matchingModel;
    [self.view addSubview:headerView];
}



#pragma mark --- 添加分段控件
- (void)addSegmentWithHeight:(CGFloat)height{
    
    // 分段控件
    _segmented = [[UISegmentedControl alloc]initWithItems:@[@"赛事直播",@"大家在说",@"赛事资讯"]];
    //    _segmented.selectedSegmentIndex = 0;
    // 被选中时的背景色
    _segmented.tintColor = [UIColor colorWithRed:51 / 255.f green:51 / 255.f blue:51 / 255.f alpha:1];
    _segmented.tintColor = [UIColor clearColor];
    //    _segmented.tintColor = [UIColor blackColor];
    _segmented.backgroundColor = [UIColor blackColor];
    //    [_segmented setBackgroundImage:[UIImage imageNamed:@"anniu_beijing"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    // 被选中时的字体的颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:Font13} forState:UIControlStateSelected];
    // 正常情况下的字体颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:Font13} forState:UIControlStateNormal];
    
    _segmented.frame=CGRectMake(0, height , WIDTH, 40 * IPHONE6_H_SCALE);
    
    if (height == 290*0.5*IPHONE6_H_SCALE) {    // 没有直播
        _segmented.selectedSegmentIndex = 2;
    } else{ // 有直播
        _segmented.selectedSegmentIndex = 0;
    }
    
    // 为分段控件添加点事件
    [_segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmented];
    
    
    // 添加滚动视图
    [self addScrollView];
}
#pragma mark - 分段控件的点击事件
-(void)segmentedClick:(UISegmentedControl*)seg{
    
    // 根据情况改变滚动视图的偏移
    if (seg.selectedSegmentIndex == 0) {
        _sc.contentOffset=CGPointMake(0, 0);
    }else if (seg.selectedSegmentIndex == 1){
        _sc.contentOffset=CGPointMake( WIDTH , 0);
    }else{
        _sc.contentOffset=CGPointMake( WIDTH * 2, 0);
    }
}

#pragma mark --- 添加滚动视图
- (void)addScrollView {
    CGFloat scH = CGRectGetMaxY(_segmented.frame);
    _sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, scH, WIDTH , HEIGHT - 64 - scH)];
    _sc.contentSize=CGSizeMake(WIDTH * 3 , HEIGHT - 64 - scH);
    _sc.delegate=self;
    _sc.bounces=NO;
    _sc.pagingEnabled=YES;
    _sc.backgroundColor = [UIColor redColor];
    
    if (_segmented.selectedSegmentIndex == 0) {
        _sc.contentOffset = CGPointMake(0, 0);
    }
    if (_segmented.selectedSegmentIndex == 2) {
        _sc.contentOffset=CGPointMake( WIDTH * 2, 0);
    }
    
    // 添加滚动视图
    [self.view addSubview:_sc];
    
    // 在滚动视图上添加tableView
    [self addTableView];
}
#pragma mark --- 添加tableView
- (void)addTableView{
    CGFloat scH = CGRectGetMaxY(_segmented.frame);
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 0 , WIDTH , HEIGHT - 64-scH) style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.showsVerticalScrollIndicator = NO;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!_matchingModel.app_live.count > 0) {
        UIImageView * picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _sc.frame.size.height)];
        picView.image = [UIImage imageNamed:@"meiyouzhibo"];
        [_sc addSubview:picView];
    }else{
        [_sc addSubview:_tableView1];
    }
    
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH , HEIGHT - 64-scH) style:UITableViewStylePlain];
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    _tableView2.showsVerticalScrollIndicator=NO;
    _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_sc addSubview:_tableView2];
    UIImageView * commentV = [[UIImageView alloc] init];
    commentV.image = [UIImage imageNamed:@"meiyouxiangguanpinglun"];
    [_sc addSubview:commentV];
    [commentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tableView2.mas_centerX);
        make.top.equalTo(_sc.mas_top).offset(111 * IPHONE6_H_SCALE);
        make.width.equalTo(@(242 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(187 * 0.5 * IPHONE6_W_SCALE));
    }];
    _commentV = commentV;
    _commentV.hidden = YES;
    
    _tableView3=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH * 2, 0, WIDTH, HEIGHT - 64-scH) style:UITableViewStylePlain];
    _tableView3.delegate=self;
    _tableView3.dataSource=self;
    _tableView3.showsVerticalScrollIndicator=NO;
    _tableView3.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_sc addSubview:_tableView3];
    
    UIImageView * infoV = [[UIImageView alloc] init];
    infoV.image = [UIImage imageNamed:@"meiyouxiangguanneirong"];
    [_sc addSubview:infoV];
    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tableView3.mas_centerX);
        make.top.equalTo(_commentV.mas_top);
        make.width.equalTo(@(246 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(187 * 0.5 * IPHONE6_W_SCALE));
    }];
    _infoV = infoV;
    _infoV.hidden = YES;
    
    // 添加刷新和加载
    [self addRefreshWithTableview1];
    [self addRefreshWithTableview2];
    [self addRefreshWith:_tableView3];
    
    // 在第二个表格上添加评论按钮
    [self addCommtBtnInTableView2];
}

- (void)addCommtBtnInTableView2{
    CGFloat scH = CGRectGetMaxY(_segmented.frame);
    UIView * bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    CGFloat bottomX= WIDTH;
    CGFloat bottomH = 92 * 0.5 * IPHONE6_H_SCALE;
    CGFloat bottomY = HEIGHT - 64-scH - bottomH;
    CGFloat bottomW = WIDTH;
    bottomView.frame = CGRectMake(bottomX, bottomY, bottomW, bottomH);
    [_sc addSubview:bottomView];
    
    // 横线
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color216;
    line.frame = CGRectMake(0, 0, WIDTH, 0.5);
    [bottomView addSubview:line];
    
    // 评论按钮
    UIButton * commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnX = Margin30 * IPHONE6_W_SCALE;
    CGFloat btnY = Margin14 * IPHONE6_H_SCALE;
    CGFloat btnW = WIDTH - 2 * btnX;
    CGFloat btnH = bottomH - 2 * btnY;
    commentBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [commentBtn setImage:[UIImage imageNamed:@"xiepinglunBtn"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:commentBtn];
}
#pragma mark --- 评论按钮的点击事件
- (void)commentAction{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backView.backgroundColor = ColorBlack60;
    // 当前顶层窗口
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    // 添加到灰色的背景图
    [window addSubview:backView];
    _backView = backView;
    // 添加评论视图
    CommentView * commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, Margin242 * IPHONE6_H_SCALE)];
    commentView.delegate = self;
    
    if (_reply) {   // 如果点击了回复
        commentView.placeholder = [NSString stringWithFormat:@"回复%@:", _replyName];
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    commentView.userInteractionEnabled = YES;
    [commentView addGestureRecognizer:tap];
    commentView.backgroundColor = Color239;
    [window addSubview:commentView];
    _commentView = commentView;
    
    UITapGestureRecognizer * backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperviewAction)];
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:backTap];
    
    [_commentView.textView becomeFirstResponder];
}
- (void)tapAction{
    
}
#pragma mark --- 灰色背景移出,评论视图移除
- (void)removeFromSuperviewAction
{
    // 灰色背景移除
    [_backView removeFromSuperview];
    // 移除评论视图
    [_commentView removeFromSuperview];
    //    [_commentView.textView resignFirstResponder];
}
#pragma mark --- CommentViewDelegate
- (void)commnetView:(CommentView *)commentView sendMessage:(NSString *)message{
    
    if (_reply) {// 进行回复
        //
        _reply = nil;
        NSLog(@"进行回复...");
        [self sendMessageWithTypes:_replyID andID:_replyID];
    } else{
        // 对赛事进行评论
        [self sendMessageWithTypes:@"0" andID:_matchingModel.iD];
    }
}

#pragma mark --- 进行评论或回复
- (void)sendMessageWithTypes:(NSString *)types  andID:(NSString * )ID{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if (cookieName || wxData) {
        NSLog(@"已经登录。。。进行发表");
        NSMutableDictionary * CommentDic = [NSMutableDictionary dictionary];
        NSLog(@"%@---%@", types, ID);
        CommentDic[@"id"] = _matchingModel.iD;
        CommentDic[@"types"] = types;//0:评论 1:回复
        CommentDic[@"type"] = @"5";
        CommentDic[@"content"] = _commentView.textView.text;
        [DataTool postWithStr:SendComment parameters:CommentDic success:^(id responseObject) {
            
            NSLog(@"发表评论返回的数据---%@", responseObject);
            NSString * content = [responseObject objectForKey:@"content"];
            NSLog(@"－－content--%@", content);
        } failure:^(NSError * error) {
            
            NSLog(@"发表评论的错误信息%@", error);
            
        }];
        // 移除评论视图
        [self removeFromSuperviewAction];
        
        // 显示发表成功
        [SVProgressHUD showSuccessWithStatus:@"发表成功"];
        // 再刷新一次
        [_tableView2.header beginRefreshing];
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
#pragma mark --- LSAlertViewDelegate
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
    // 移除评论框
    [self removeFromSuperviewAction];
    // 将发表的内容进行保存
    _sendContent = _commentView.textView.text;
    
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNav animated:YES completion:nil];
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
- (void)addRefreshWithTableview2{
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData2)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"没有数据" forState:MJRefreshStateNoMoreData];
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
- (void)addRefreshWithTableview1{
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData1)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"没有数据" forState:MJRefreshStateNoMoreData];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView1.header = header;
    [header beginRefreshing];
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData1)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    _tableView1.footer = footer;
}
#pragma mark --- 加载和刷新
// 刷新
- (void)loadNewData{
    // 获取相关资讯
    [DataTool getRelationInLiveWithStr:_matchingModel.relation parameters:nil success:^(id responseObject) {
        
        //        NSLog(@"%@", responseObject);
        if (!responseObject) {
            _infoV.hidden = NO;
        }else{
            _infoV.hidden = YES;
        }
        self.dataSource3 = responseObject;
        [self.tableView3 reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取相关数据失败：%@", error);
    }];
    
    [_tableView2.header endRefreshing];
    [_tableView3.header endRefreshing];
    [_tableView3.footer endRefreshing];
    [_tableView2.footer endRefreshing];
    
}
// 加载
- (void)loadMoreData{
    
    NewsListModel * model = [self.dataSource3 lastObject];
    NSString * url = [_matchingModel.relation stringByAppendingString:[NSString stringWithFormat:@"/%@", model.iD]];
    [DataTool getRelationInLiveWithStr:url parameters:nil success:^(id responseObject) {
        [_tableView3.footer endRefreshing];
        
        if (!responseObject) {
            _tableView3.footer.state = MJRefreshStateNoMoreData;
        }
        [self.dataSource3 addObjectsFromArray:responseObject];
        [_tableView3 reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取更多相关数据出错：%@", error);
        [_tableView3.footer endRefreshing];
        
    }];
    
}

// 获取评论数据
// 刷新
- (void)loadNewData2{
    // 获取评论
    [DataTool getCommentsListWithStr:_matchingModel.comment parameters:nil success:^(id responseObject) {
        
        [_tableView2.header endRefreshing];
        [_tableView2.footer endRefreshing];
        
        if ([responseObject isKindOfClass:[NSString class]]) {
            NSLog(@"没有评论..");
            _commentV.hidden = NO;
        }else{
            _commentV.hidden = YES;
            // 传递过来的是模型数组(模型是评论模型)
            NSArray * commentsArr = responseObject;
            NSMutableArray * commentsFrameArr = [NSMutableArray array];
            for (CommentsModel * commentModel in commentsArr) {
                CommentsFrame * commentsFrame = [[CommentsFrame alloc] init];
                // 将模型传递给视图模型
                commentsFrame.comments = commentModel;
                [commentsFrameArr addObject:commentsFrame];
            }
            // 将视图模型数组赋值给数据源
            //            NSLog(@"模型个数：%lu", commentsFrameArr.count);
            self.dataSource2 = commentsFrameArr;
        }
        
        [_tableView2 reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取评论列表的数据出错%@", error);
        [_tableView2.header endRefreshing];
    }];
    
    
}
// 加载
- (void)loadMoreData2{
    
    CommentsFrame * commentsFrameModel = [self.dataSource2 lastObject];
    CommentsModel * commentsModel = commentsFrameModel.comments;
    
    NSString * url = [NSString stringWithFormat:@"%@/%@/%@/%@", CommentsURL, _matchingModel.iD, @"5", commentsModel.comment_id];
    
    
    //    NSLog(@"---url---%@", url);
    [DataTool getCommentsListWithStr:url parameters:nil success:^(id responseObject) {
        [_tableView2.footer endRefreshing];
        
        
        NSLog(@"%@", responseObject);
        if ([responseObject isKindOfClass:[NSString class]]) {  // 没有更多数据
            
            _tableView2.footer.state = MJRefreshStateNoMoreData;
        }else{
            
            // 传递过来的是模型数组(模型是评论模型)
            NSArray * commentsArr = responseObject;
            NSMutableArray * commentsFrameArr = [NSMutableArray array];
            for (CommentsModel * commentModel in commentsArr) {
                CommentsFrame * commentsFrame = [[CommentsFrame alloc] init];
                // 将模型传递给视图模型
                commentsFrame.comments = commentModel;
                [commentsFrameArr addObject:commentsFrame];
            }
            // 将视图模型数组赋值给数据源
            [self.dataSource2 addObjectsFromArray:commentsFrameArr];
        }
        
        [_tableView2 reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取评论列表的错误信息%@",error);
        [_tableView2.footer endRefreshing];
    }];
    
    
}
#pragma mark --- 监听的通知
- (void)cleanValueAction:(NSNotification *)notification {
    
    NSLog(@"收到给小孩洗澡的通知");
    _index = notification.object;
    //    [self loadNewData1];
    
}

- (void)changeShareURL:(NSNotification *)notification{
    
    _shareURL = notification.object;
    NSLog(@"_shareURL%@", _shareURL);
}

// 获取直播信息
// 刷新
- (void)loadNewData1{
    
    // 获取直播
    NSUInteger index = [_index integerValue];
    
    NSLog(@"---index----%@", _index);
    if (_index) {   // 如果点击了某个赛事    主要这块有问题
        LiveModel * live = [_matchingModel.app_live objectAtIndex:index];
        _appendStr = live.wapurl;
        NSString * url = live.wapurl;
        // 设置头视图的数据
        NSDictionary * dic = live.keyValues;    // 模型转字典
        [self setHeaderDataWithDic:dic];
        if (self.dataSource11.count > 0) {  // 不是第一次点击某个赛事
            
            LiveInfoModel * infoModel = [self.dataSource11 firstObject];
            NSString * URL = [live.wapurl stringByAppendingString:[NSString stringWithFormat:@"/%@?direction=1", infoModel.iD]];
            [DataTool getLiveDataWithStr:URL parameters:nil success:^(id responseObject) {
                
                //                NSLog(@"%@", URL);
                [_tableView1.header endRefreshing];
                [_tableView1.footer endRefreshing];
                DataLiveModel * model = responseObject;
                if (!model.data) {  // 如果数据没有更新,依旧请求之前久的数据
                    [DataTool getLiveDataWithStr:url parameters:nil success:^(id responseObject) {
                        [_tableView1.header endRefreshing];
                        [_tableView1.footer endRefreshing];
                        DataLiveModel * dataModel = responseObject;
                        self.dataSource1 = (NSMutableArray *)dataModel.data;
                        self.dataSource11 = self.dataSource1;
                        if (_refresh && _refresh.length > 0) {
                            NSLog(@"不刷新...");
                            
                        }else{
                            [_tableView1 reloadData];
                        }
                        _refresh = @"";
                    } failure:^(NSError * error) {
                        
                        NSLog(@"获取直播信息出错：%@", error);
                        [_tableView1.header endRefreshing];
                    }];
                }else{  // 数据更新
                    
                    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, model.data.count)];
                    [self.dataSource1 insertObjects:model.data atIndexes:indexSet];
                    if ([model.live isKindOfClass:[NSNull class]]) {
                        
                        //                        NSLog(@"%@", model.live);
                        
                    }else{
                        [self setHeaderDataWithDic:model.live];
                    }
                    self.dataSource11 = self.dataSource1;
                    if (_refresh && _refresh.length > 0) {
                        NSLog(@"不刷新...");
                        _messageV.hidden = NO;
                        [UIView animateWithDuration:0.5 animations:^{
                            _messageV.transform = CGAffineTransformMakeTranslation(-101 * IPHONE6_W_SCALE, 0);
                            
                        } completion:nil];
                    }else{
                        [_tableView1 reloadData];
                    }
                    _refresh = @"";
                }
                
            } failure:^(NSError * error) {
                
                NSLog(@"获取直播信息出错：%@", error);
                [_tableView1.header endRefreshing];
            }];
        }else{  //  第一次点击某个赛事
            
            [DataTool getLiveDataWithStr:url parameters:nil success:^(id responseObject) {
                
                [_tableView1.header endRefreshing];
                [_tableView1.footer endRefreshing];
                DataLiveModel * model = responseObject;
                self.dataSource1 = (NSMutableArray *)model.data;
                self.dataSource11 = self.dataSource1;
                [_tableView1 reloadData];
                
                // 设置头视图数据
                //                [self setHeaderDataWithDic:model.live];
                
            } failure:^(NSError * error) {
                
                NSLog(@"获取直播信息出错：%@", error);
                [_tableView1.header endRefreshing];
                [_tableView1.footer endRefreshing];
            }];
        }
        
        
    }else{  // 如果没有点击某个赛事
        LiveModel * live = [_matchingModel.app_live firstObject];
        _appendStr = live.wapurl;
        NSString * url = live.wapurl;
        
        if (self.dataSource1.count > 0) {   // 如果self.dataSource1种已经有了数据
            
            LiveInfoModel * infoModel = [self.dataSource1 firstObject];
            NSString * URL = [live.wapurl stringByAppendingString:[NSString stringWithFormat:@"/%@?direction=1", infoModel.iD]];
            [DataTool getLiveDataWithStr:URL parameters:nil success:^(id responseObject) {
                [_tableView1.header endRefreshing];
                [_tableView1.footer endRefreshing];
                
                DataLiveModel * model = responseObject;
                if (!model.data) {  // 如果数据没有更新
                    [DataTool getLiveDataWithStr:url parameters:nil success:^(id responseObject) {
                        [_tableView1.header endRefreshing];
                        DataLiveModel * dataModel = responseObject;
                        self.dataSource1 = (NSMutableArray *)dataModel.data;
                        NSLog(@"--%@", _refresh);
                        if (_refresh && _refresh.length > 0) {
                            NSLog(@"不刷新...");
                            
                        }else{
                            [_tableView1 reloadData];
                        }
                        _refresh = @"";
                    } failure:^(NSError * error) {
                        
                        NSLog(@"获取直播信息出错：%@", error);
                        [_tableView1.header endRefreshing];
                    }];
                    
                }else{  // 有更新数据
                    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, model.data.count)];
                    [self.dataSource1 insertObjects:model.data atIndexes:indexSet];
                    // 设置头信息
                    if ([model.live isKindOfClass:[NSNull class]]) {
                        
                        //                        NSLog(@"%@", model.live);
                        
                    }else{
                        [self setHeaderDataWithDic:model.live];
                    }
                    
                    NSLog(@"--%@", _refresh);
                    if (_refresh && _refresh.length > 0) {
                        NSLog(@"不刷新...");
                        _messageV.hidden = NO;
                        [UIView animateWithDuration:0.5 animations:^{
                            _messageV.transform = CGAffineTransformMakeTranslation(-101 * IPHONE6_W_SCALE, 0);
                            
                        } completion:nil];
                    }else{
                        [_tableView1 reloadData];
                    }
                    _refresh = @"";
                }
                
            } failure:^(NSError * error) {
                
                NSLog(@"获取直播信息出错：%@", error);
                [_tableView1.header endRefreshing];
            }];
        }else{  // 第一次获取数据
            
            //            NSLog(@"第一次获取数据:%@", url);
            [DataTool getLiveDataWithStr:url parameters:nil success:^(id responseObject) {
                [_tableView1.header endRefreshing];
                [_tableView1.footer endRefreshing];
                DataLiveModel * model = responseObject;
                self.dataSource1 = (NSMutableArray *)model.data;
                [_tableView1 reloadData];
            } failure:^(NSError * error) {
                
                NSLog(@"获取直播信息出错：%@", error);
                [_tableView1.header endRefreshing];
            }];
        }
    }
    
}

#pragma mark --- 设置赛事头信息
- (void)setHeaderDataWithDic:(NSDictionary *)dic{
    
    //    NSLog(@"%@", dic);
    _headerView.stateLbl.text = [NSString stringWithFormat:@"比赛状态:%@", dic[@"match_state"]];    // 赛事状态
    _headerView.blindNum.text = dic[@"blind"];  // 盲注
    _headerView.score.text = dic[@"score"]; // 记分
    _headerView.players.text = dic[@"player"];  //剩余选手
}

// 加载
- (void)loadMoreData1{
    
    LiveInfoModel * model = [self.dataSource1 lastObject];
    
    NSString * url = [_appendStr stringByAppendingString:[NSString stringWithFormat:@"/%@", model.iD]];
    
    //    NSLog(@"%@", url);
    [DataTool getLiveDataWithStr:url parameters:nil success:^(id responseObject) {
        
        [_tableView1.footer endRefreshing];
        DataLiveModel * model = responseObject;
        if (!model.data) {
            //           [SVProgressHUD showSuccessWithStatus:@"没有更多内容了"];
            _tableView1.footer.state = MJRefreshStateNoMoreData;
        }else{
            [self.dataSource1 addObjectsFromArray:model.data];
        }
        [_tableView1 reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取更多的直播信息失败%@", error);
        [_tableView1.footer endRefreshing];
    }];
    
    
}
#pragma mark ---  滚动视图结束滚动后
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_sc.contentOffset.x == 0) {
        _segmented.selectedSegmentIndex=0;
    }else if (_sc.contentOffset.x == WIDTH){
        _segmented.selectedSegmentIndex=1;
    }else{
        _segmented.selectedSegmentIndex=2;
    }
}

#pragma mark --- UITableViewDataSource
// 单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        return self.dataSource1.count;
    }else if (tableView == _tableView2){
        return self.dataSource2.count;
    }else{
        return self.dataSource3.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView1) { // 直播信息页面
        LiveCell * cell = [LiveCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.liveInfoModel = self.dataSource1[indexPath.row];
        return cell;
    } else if (tableView == _tableView2){   // 评论页面
        CommentsTableViewCell * cell = [CommentsTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        CommentsFrame * commentsFrameModel = self.dataSource2[indexPath.row];
        cell.commentsFrame = commentsFrameModel;
        return cell;
    } else{ // 相关资讯页面
        InformationCell * cell = [InformationCell cellWithTableView:tableView];
        NewsListModel * listModel = self.dataSource3[indexPath.row];
        cell.newslistModel = listModel;
        return cell;
    }
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) {
        
        LiveInfoModel * liveInfoModel = self.dataSource1[indexPath.row];
        if (liveInfoModel.title && liveInfoModel.title.length > 0) {  // 如果是能转发的精彩牌局
            CGFloat contentW = WIDTH - 77 * IPHONE6_W_SCALE;
            NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
            contentDic[NSFontAttributeName] = Font12;
            CGRect contentRect = [liveInfoModel.body boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil];
            if (liveInfoModel.imgs) {   // 如果图片
                return 261 * IPHONE6_H_SCALE + contentRect.size.height;
            }else{
                return 143 * IPHONE6_H_SCALE + contentRect.size.height;
            }
            
            
        }else{
            CGFloat contentW = WIDTH - 77 * IPHONE6_W_SCALE;
            NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
            contentDic[NSFontAttributeName] = Font12;
            CGRect contentRect = [liveInfoModel.body boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil];
            if (liveInfoModel.imgs) {   // 如果图片
                return 168 * IPHONE6_H_SCALE + contentRect.size.height;
            }else{
                return 59 * IPHONE6_H_SCALE + contentRect.size.height;
            }
        }
        
    } else if (tableView == _tableView2){
        CommentsFrame * commentsFrameModel = self.dataSource2[indexPath.row];
        
        return commentsFrameModel.cellHeight;
    } else{
        return  Margin196 * IPHONE6_H_SCALE;
    }
}
#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == _tableView3) {
        NewsListModel * model = self.dataSource3[indexPath.row];
        NSString * url = model.url;
        DetailWebViewController * detaiVC = [[DetailWebViewController alloc] init];
        detaiVC.url = url;
        [self.navigationController pushViewController:detaiVC animated:YES];
    }else if (tableView == _tableView2){
        NSLog(@"%lu", indexPath.row);
    }else{
        NSLog(@"%lu", indexPath.row);
    }
}
#pragma mark ---CommentsTableViewCellDelegate  点击文字
- (void)tableViewCell:(CommentsTableViewCell *)cell didClickedContentWithID:(NSString *)ID andModel:(CommentsModel *)model{
    
    //    _model = model;
    
    CommentsModel * commentModel = [[CommentsModel alloc] init];
    commentModel = model;
    _commentModel = commentModel;
    
    [DataTool getSBDataWithStr:model.wapurl parameters:nil success:^(id responseObject) {
        
        SBModel * sbModel = [[SBModel alloc] init];
        sbModel = responseObject;
        _sbModel = sbModel;
    } failure:^(NSError * error) {
        NSLog(@"获取个人数据出错：%@", error);
    }];
    
    if (_replyView) {   // 如果有回复视图
        [_replyView removeFromSuperview];
    }
    
    _replyID = ID;
    UIImageView * replyView = [[UIImageView alloc] init];
    CGFloat replyViewX = (128+130)/2 * IPHONE6_W_SCALE;
    CGFloat replyViewY = 50 / 2 * IPHONE6_H_SCALE;
    CGFloat replyViewW = 301 / 2 * IPHONE6_W_SCALE;
    CGFloat replyViewH = 74 / 2 * IPHONE6_H_SCALE;
    replyView.frame = CGRectMake(replyViewX, replyViewY, replyViewW, replyViewH);
    replyView.image = [UIImage imageNamed:@"anniu_beijing"];
    [cell addSubview:replyView];
    // 图片要能与用户交互
    replyView.userInteractionEnabled = YES;
    _replyView = replyView;
    
    // 回复按钮
    UIButton * replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat replyBtnX = 0;
    CGFloat replyBtnY = 0;
    CGFloat replyBtnW = replyViewW / 2;
    CGFloat replyBtnH = replyViewH;
    replyBtn.frame = CGRectMake(replyBtnX, replyBtnY, replyBtnW, replyBtnH);
    replyBtn.backgroundColor = [UIColor clearColor];
    [replyBtn addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    [replyView addSubview:replyBtn];
    
    // 查看主页按钮
    UIButton * checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat checkBtnX = CGRectGetMaxX(replyBtn.frame);
    CGFloat checkBtnY = 0;
    CGFloat checkBtnW = replyBtnW;
    CGFloat checkBtnH = replyBtnH;
    checkBtn.frame = CGRectMake(checkBtnX, checkBtnY, checkBtnW, checkBtnH);
    [checkBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    [replyView addSubview:checkBtn];
    
    _reply = @"yes";
    
    _replyName = model.username;
}
#pragma mark ---- 回复事件
- (void)replyAction{
    NSLog(@"回复....");
    [_replyView removeFromSuperview];
    [self commentAction];
    // 对某个评论进行回复
    //    [self sendMessageWithTypes:@"1" andID:_replyID];
}
#pragma mark --- 查看用户主页
- (void)checkAction{
    NSLog(@"查看用户主页 ...");
    [_replyView removeFromSuperview];
    AnyBodyVC * anyBodyVC = [[AnyBodyVC alloc] init];
    StarVC * starVC = [[StarVC alloc] init];
    
    if ([_sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {   // 如果认证为空，就是普通人主页
        anyBodyVC.userURL = _commentModel.wapurl;
        [self.navigationController pushViewController:anyBodyVC animated:YES];
    }else{
        starVC.userURL = _commentModel.wapurl;
        [self.navigationController pushViewController:starVC animated:YES];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 回复视图移除
    [_replyView removeFromSuperview];
}

#pragma mark -- LiveCellDelegate
// 点击分享按钮
- (void)tableViewCell:(LiveCell *)cell didClickShareWithModel:(LiveInfoModel *)model{
    
    
    UIImage *img = [[UIImage alloc] init];
    if (model.imgs) {
        NSString *st = model.imgs[@"pimg2"];
        NSURL *url = [NSURL URLWithString:st];
        NSData *data = [NSData dataWithContentsOfURL:url];
        img = [UIImage imageWithData:data];
    }else{
        img = [UIImage imageNamed:@"dipai_logo"];
    }
    
    // 友盟分享代码，复制、粘贴
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55556bc8e0f55a56230001d8"
                                      shareText:[NSString stringWithFormat:@"%@ %@",model.title,model.body]
                                     shareImage:img
                                shareToSnsNames:@[UMShareToSina ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,@"CustomPlatform"]
                                       delegate:self]; // 分享到朋友圈、微信好友、QQ空间、QQ好友
    
    // 下面的三段代码是什么意思？ 解释：加上下面的几句话才能将网页内容分享成功
    // 分享到各个平台的内容  如果没有下面的代码就会跳到友盟首页（自己设置的URL）
    NSString * wapurl = [model.wapurl stringByAppendingString:@"?isshare=1"];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = wapurl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = wapurl;
    [UMSocialData defaultData].extConfig.qqData.url = wapurl;
    [UMSocialData defaultData].extConfig.qzoneData.url = wapurl;
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:wapurl];
    
    NSString * shareURL = wapurl;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeShareURL" object:shareURL];
    
    //    [self addCustomShareBtn];
}
// 点击图片
- (void)tableViewCell:(LiveCell *)cell didClickPicWithModel:(LiveInfoModel *)model{
    NSLog(@"点击图片...");
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView * picBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    picBackView.backgroundColor = [UIColor blackColor];
    [window addSubview:picBackView];
    _picBackView = picBackView;
    
    UIScrollView * picSc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];;
    [picBackView addSubview:picSc];
    //    picSc.backgroundColor = [UIColor redColor];
    picSc.minimumZoomScale = 1.0;
    picSc.maximumZoomScale = 2.0;
    picSc.delegate = self;
    _picSc = picSc;
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [picSc addSubview:image];
    [image sd_setImageWithURL:[NSURL URLWithString:model.imgs[@"pimg"]] placeholderImage:[UIImage imageNamed:@"123"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    _image = image;
    
    // 双击图片放大
    UITapGestureRecognizer * twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTap:)];
    twoTap.numberOfTapsRequired = 2;
    twoTap.numberOfTouchesRequired = 1;
    [picSc addGestureRecognizer:twoTap];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPic:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [picSc addGestureRecognizer:tap];
    
    // 双击没有识别到的时候识别单击手势
    [tap requireGestureRecognizerToFail:twoTap];
    
    
}
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _image;
}
#pragma mark --- 双击图片放大
- (void)twoTap:(UITapGestureRecognizer *)tap{
    NSLog(@"双击放大图片...");
    UIScrollView * sc = (UIScrollView *)tap.view;
    CGFloat zoomScale = sc.zoomScale;
    
    NSLog(@"%f", zoomScale);
    
    zoomScale = (zoomScale == 1.0) ? 3.0 : 1.0;
    
    NSLog(@"%f", zoomScale);
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[tap locationInView:tap.view]];
    [sc zoomToRect:zoomRect animated:YES];
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.view.frame.size.height / scale;
    zoomRect.size.width  =self.view.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

- (void)showBigPic:(UITapGestureRecognizer *)tap{
    [_picBackView removeFromSuperview];
}

/***********请求网路数据******************/
- (void)getData{
    
    // http://dipaiapp.replays.net/app/club/view/5/4917
    
    //    NSLog(@"%@", self.wapurl);
    // http://dipaiapp.replays.net/app/club/view/5/5110
    [DataTool getMatchDataInDetailWithStr:self.wapurl parameters:nil success:^(id responseObject) {
        
        _matchingModel= [[MatchingModel alloc] init];
        _matchingModel = responseObject;
        
        // 每次进来都会调用此方法
        NSLog(@"%lu", _matchingModel.match.count);
        if (_matchingModel.match.count > 0) {   // 没有直播
            [self addHeaderView2];
            // 添加分段控件
            [self addSegmentWithHeight:290*0.5*IPHONE6_H_SCALE];
        } else{     // 有直播
            
            [self addHeaderView1];
            [self addSegmentWithHeight:326*0.5*IPHONE6_H_SCALE];
            
        }
        
    } failure:^(NSError * error) {
        
        NSLog(@"获取赛事详情数据出错%@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
