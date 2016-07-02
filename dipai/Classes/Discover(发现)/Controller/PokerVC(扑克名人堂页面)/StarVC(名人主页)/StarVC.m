//
//  StarVC.m
//  dipai
//
//  Created by 梁森 on 16/6/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "StarVC.h"

#import "Masonry.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

#import "PostCell.h"
#import "PostFrameModel.h"
#import "PostsModel.h"

// 我的回复单元格
#import "MyReplyCell.h"
// 我的回复模型
#import "MyReplyModel.h"
// 我的回复frame模型
#import "MyReplyFrameModel.h"
// 成绩模型
#import "ScoreModel.h"
// 名人成绩单元格
#import "ScoreCell.h"
// 名人图片展示
#import "ShowPicView.h"

// 回帖用户模型
#import "ReplyModel.h"
// 某人主页模型
#import "SBModel.h"
// 帖子详情页
#import "PostDetailVC.h"


#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

#import "DataTool.h"
@interface StarVC ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

{
     UISegmentedControl *_segmented;
    // 滚动视图
    UIScrollView *_sc;
    NSString * _flag;
}

/**
 *  头视图
 */
@property (nonatomic, strong) UIImageView * topView;

/**
 *  名人头像
 */
@property (nonatomic, strong) UIImageView * faceView;
/**
 *  关注按钮
 */
@property (nonatomic, strong) UIButton * attentionBtn;
/**
 *  姓名
 */
@property (nonatomic, strong) UILabel * nameLbl;
/**
 *  关注数
 */
@property (nonatomic, strong) UILabel * attentionLbl;
/**
 *  粉丝数
 */
@property (nonatomic, strong) UILabel * fansLbl;
/**
 *  底牌认证
 */
@property (nonatomic, strong) UILabel * certificateLbl;

@property (nonatomic, strong) SBModel * sbModel;

// 三个页面的下划线
@property (nonatomic, strong) UIView * redView;
// 三个标题的底部视图
@property (nonatomic, strong) UIView * pagesBackView;
// 分割线
@property (nonatomic, strong) UIView * sepatateView;

@property (nonatomic, strong) UIView * separate;
// 三个表格
@property (nonatomic, strong) UITableView * tableView1;
@property (nonatomic, strong) UITableView * tableView2;
@property (nonatomic, strong) UITableView * tableView3;
// 三个数据源
@property (nonatomic, strong) NSMutableArray * dataSource2;
@property (nonatomic, strong) NSMutableArray * dataSource3;

// 展开按钮、文字、图形
@property (nonatomic, strong) UIButton * showBtn;
@property (nonatomic, strong) UILabel * showLbl;
@property (nonatomic, strong) UIImageView * showView;

// 个人简介
@property (nonatomic, strong) UILabel * introduceLbl;
@end

@implementation StarVC

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setUpNavigationBar];
    
    // 添加三个页面的标题
    [self addThreePages];
    
    // 添加滚动视图
    [self addScrollView];
    
    // 添加三个表格
    [self addTableView];
    
    NSLog(@"%@", self.userURL);
}

#pragma mark --- 设置导航栏
- (void)setUpNavigationBar
{
    // 头视图
    UIImageView * topView = [[UIImageView alloc] init];
    [self.view addSubview:topView];
    topView.image = [UIImage imageNamed:@"mingrenzhuye_beijing"];
    topView.frame = CGRectMake(0, 0, WIDTH, 226 * IPHONE6_H_SCALE);
    _topView = topView;

    // 返回按钮
    UIImageView * popView = [[UIImageView alloc] init];
    [self.view addSubview:popView];
    popView.frame = CGRectMake(15, 30, 10 * IPHONE6_W_SCALE, 19 * IPHONE6_W_SCALE);
    popView.image = [UIImage imageNamed:@"houtui_baise"];
    
    UIButton * popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:popBtn];
    popBtn.frame = CGRectMake(0, 20, 50, 44);
    popBtn.backgroundColor =[UIColor clearColor];
    [popBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    // 头像
    UIImageView * faceView = [[UIImageView alloc] init];
    faceView.layer.masksToBounds = YES;
    [topView addSubview:faceView];
    [faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(topView.mas_top).offset(64 * IPHONE6_H_SCALE);
        make.width.equalTo(@(78 * IPHONE6_W_SCALE));
        make.height.equalTo(@(78 * IPHONE6_W_SCALE));
    }];
    faceView.layer.cornerRadius = 78 * 0.5 * IPHONE6_W_SCALE;
    faceView.layer.borderWidth = 2;
    faceView.layer.borderColor = [[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.5] CGColor];
    _faceView = faceView;
    
    // 关注按钮
    UIButton * attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
#warning 修改
//    [attentionBtn setImage:[UIImage imageNamed:@"jiaguangzhu"] forState:UIControlStateNormal];
    [topView addSubview:attentionBtn];
    [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(64 * IPHONE6_H_SCALE);
        make.right.equalTo(topView.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.width.equalTo(@(61*IPHONE6_W_SCALE));
        make.height.equalTo(@(22 * IPHONE6_W_SCALE));
    }];
    
    // 姓名
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.textAlignment = NSTextAlignmentCenter;
    nameLbl.font = Font17;
    nameLbl.textColor = [UIColor whiteColor];
#warning 可变内容
//    nameLbl.text = @"阿福空间啊啦放假啦";
    [topView addSubview:nameLbl];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(faceView.mas_bottom).offset(5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(17*IPHONE6_W_SCALE));
    }];
    _nameLbl = nameLbl;
    
    // 分割线竖线
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:separateView];
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(nameLbl.mas_bottom).offset(12.5*IPHONE6_H_SCALE);
        make.width.equalTo(@(0.5));
        make.height.equalTo(@(15));
    }];
    
    // 关注数
    UILabel * attentionLbl = [[UILabel alloc] init];
    attentionLbl.textAlignment = NSTextAlignmentRight;
#warning 可变
//    attentionLbl.text = @"关注 10";
    attentionLbl.textColor = [UIColor whiteColor];
    attentionLbl.font = Font13;
    [topView addSubview:attentionLbl];
    [attentionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(separateView.mas_left).offset(-14 * IPHONE6_W_SCALE);
        make.top.equalTo(nameLbl.mas_bottom).offset(13 * IPHONE6_H_SCALE);
        make.left.equalTo(topView.mas_left);
        make.height.equalTo(@(13*IPHONE6_W_SCALE));
    }];
    _attentionLbl = attentionLbl;
    // 粉丝数
    UILabel * fansLbl = [[UILabel alloc] init];
    fansLbl.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:fansLbl];
//    fansLbl.text = @"被关注 10";
    fansLbl.textColor = [UIColor whiteColor];
    fansLbl.font = Font13;
    [fansLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(separateView.mas_right).offset(14 * IPHONE6_W_SCALE);
        make.top.equalTo(nameLbl.mas_bottom).offset(13 * IPHONE6_H_SCALE);
        make.right.equalTo(topView.mas_right);
        make.height.equalTo(@(13 * IPHONE6_W_SCALE));
    }];
    _fansLbl = fansLbl;
    
    // 底牌认证
    UILabel * certificateLbl = [[UILabel alloc] init];
    certificateLbl.font = Font12;
    certificateLbl.textAlignment = NSTextAlignmentCenter;
    certificateLbl.text = @"底牌认证";
    certificateLbl.textColor = [UIColor whiteColor];
    [topView addSubview:certificateLbl];
    _certificateLbl = certificateLbl;
    [certificateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(separateView.mas_bottom).offset(7 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(12 * IPHONE6_W_SCALE));
    }];
    
}
#pragma mark --- 返回上一个视图控制器
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addThreePages{
    
    UIView * pagesBackView = [[UIView alloc] init];
    pagesBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pagesBackView];
    _pagesBackView = pagesBackView;
    [pagesBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_topView.mas_bottom);
        make.height.equalTo(@(40 * IPHONE6_H_SCALE));
    }];
    
    // 分段控件
    _segmented = [[UISegmentedControl alloc]initWithItems:@[@"主页",@"发帖", @"回复"]];
    _segmented.selectedSegmentIndex = 0;
    // 被选中时的背景色
    _segmented.tintColor = [UIColor whiteColor];
    // 未被选中的背景色
    _segmented.backgroundColor = [UIColor whiteColor];
    
    // 被选中时的字体的颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:Font15} forState:UIControlStateSelected];
    // 正常情况下的字体颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:Color102,NSFontAttributeName:Font15} forState:UIControlStateNormal];
    
    [pagesBackView addSubview:_segmented ];
    [_segmented mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(pagesBackView.mas_top);
        make.bottom.equalTo(pagesBackView.mas_bottom);
        make.width.equalTo(@(167 * IPHONE6_W_SCALE));
    }];
    //    _segmented.backgroundColor = [UIColor yellowColor];
    // 为分段控件添加点事件
    [_segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    
    // 下划线
    UIView * redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-57*IPHONE6_W_SCALE);
        make.bottom.equalTo(pagesBackView.mas_bottom);
        make.height.equalTo(@(2 * IPHONE6_H_SCALE));
        make.width.equalTo(@(50 * IPHONE6_W_SCALE));
    }];
    _redView = redView;
    
    
    // 分割线
    UIView * sepatateView = [[UIView alloc] init];
    [self.view addSubview:sepatateView];
    [sepatateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(pagesBackView.mas_bottom);
        make.height.equalTo(@(20 * IPHONE6_H_SCALE));
    }];
    sepatateView.backgroundColor = SeparateColor;
    _sepatateView = sepatateView;
}
#pragma mark --- 分段控件的点击事件
-(void)segmentedClick:(UISegmentedControl*)seg{
    
    // 根据情况改变滚动视图的偏移
    if (seg.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            
            _redView.transform = CGAffineTransformIdentity;
        } completion:nil];
         _sc.contentOffset=CGPointMake(0, 0);
    }else if(seg.selectedSegmentIndex == 1){
        [UIView animateWithDuration:0.25 animations:^{
            _redView.transform = CGAffineTransformMakeTranslation(56*IPHONE6_W_SCALE, 0);
            
        } completion:nil];
         _sc.contentOffset=CGPointMake(WIDTH, 0);
    } else{
        [UIView animateWithDuration:0.25 animations:^{
            _redView.transform = CGAffineTransformMakeTranslation(112*IPHONE6_W_SCALE, 0);
            
        } completion:nil];
         _sc.contentOffset=CGPointMake(2*WIDTH, 0);
    }
}

- (void)addScrollView {
    
    CGFloat scY = CGRectGetMaxY(_topView.frame) + 60 * IPHONE6_H_SCALE;
    _sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, scY, WIDTH , HEIGHT-scY)];
    _sc.contentSize=CGSizeMake(WIDTH * 3 , HEIGHT-scY);
//    _sc.scrollEnabled = NO; // 禁止活动
    _sc.scrollsToTop = NO;
    _sc.delegate=self;
    _sc.bounces=NO;
    _sc.pagingEnabled=YES;
    _sc.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sc];
}
#pragma mark --- UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_sc.contentOffset.x == 0) {
        _segmented.selectedSegmentIndex=0;
        [UIView animateWithDuration:0.25 animations:^{
            _redView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }else if(_sc.contentOffset.x == WIDTH){
        _segmented.selectedSegmentIndex = 1;
        [UIView animateWithDuration:0.25 animations:^{
            _redView.transform = CGAffineTransformMakeTranslation(56*IPHONE6_W_SCALE, 0);
        } completion:nil];
    }else{
        _segmented.selectedSegmentIndex = 2;
        [UIView animateWithDuration:0.25 animations:^{
            _redView.transform = CGAffineTransformMakeTranslation(112*IPHONE6_W_SCALE, 0);
            
        } completion:nil];
    }
}

#pragma mark --- 添加tableView
- (void)addTableView{
    
    CGFloat scY = CGRectGetMaxY(_topView.frame) + 60 * IPHONE6_H_SCALE;
    
    // 显示“个人简介”四个字的视图
    UIView * titleView = [[UIView alloc] init];
    [_sc addSubview:titleView];
    titleView.frame = CGRectMake(0, 0, WIDTH, 44 * IPHONE6_H_SCALE);
    titleView.backgroundColor = [UIColor whiteColor];
    UILabel * titleLbl = [[UILabel alloc] init];
    [titleView addSubview:titleLbl];
    titleLbl.frame = CGRectMake(15*IPHONE6_W_SCALE, 0, WIDTH - 15*IPHONE6_W_SCALE, 44 * IPHONE6_H_SCALE);
    titleLbl.text = @"个人简介";
    titleLbl.font = Font16;
    // 展开收起的按钮和文字
    UILabel * showLbl = [[UILabel alloc] init];
    showLbl.text = @"展开";
    showLbl.textColor = [UIColor redColor];
    showLbl.font = Font14;
    [titleView addSubview:showLbl];
    _showLbl = showLbl;
    [showLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.right.equalTo(titleView.mas_right).offset(-20*IPHONE6_W_SCALE);
        make.height.equalTo(@(14*IPHONE6_W_SCALE));
        make.width.equalTo(@(30*IPHONE6_W_SCALE));
    }];
    UIImageView * showView = [[UIImageView alloc] init];
    [titleView addSubview:showView];
    _showView = showView;
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.right.equalTo(showLbl.mas_left).offset(-8*IPHONE6_W_SCALE);
        make.width.equalTo(@(8 * IPHONE6_W_SCALE));
        make.height.equalTo(@(4 * IPHONE6_W_SCALE));
    }];
    [showView setImage:[UIImage imageNamed:@"zhankai_p"]];
    UIButton * showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleView addSubview:showBtn];
    _showBtn = showBtn;
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showView.mas_left).offset(-5);
        make.top.equalTo(showView.mas_top).offset(-5);
        make.right.equalTo(showLbl.mas_right).offset(5);
        make.bottom.equalTo(showView.mas_bottom).offset(5);
    }];
    showBtn.backgroundColor = [UIColor colorWithRed:288 / 255.f green:0/255.f blue:0/255.f alpha:0.5];
    // 展示按钮的点击事件
    [showBtn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * lineView = [[UIView alloc] init];
    [titleView addSubview:lineView];
    lineView.backgroundColor = Color238;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).offset(15*IPHONE6_W_SCALE);
        make.right.equalTo(titleView.mas_right).offset(-15*IPHONE6_W_SCALE);
        make.bottom.equalTo(titleView.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
    
    
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH , HEIGHT -scY) style:UITableViewStylePlain];
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    _tableView2.showsVerticalScrollIndicator=NO;
    _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_sc addSubview:_tableView2];
    
    _tableView3=[[UITableView alloc]initWithFrame:CGRectMake(2*WIDTH, 0, WIDTH , HEIGHT -scY) style:UITableViewStylePlain];
    _tableView3.delegate=self;
    _tableView3.dataSource=self;
    _tableView3.showsVerticalScrollIndicator=NO;
    _tableView3.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_sc addSubview:_tableView3];
    
//    [self addRefreshWith:_tableView1];
    [self addRefreshWith:_tableView2];
    
    [self addRefreshByTable3];
    
}
#pragma mark ---showAction 展示按钮的点击效果
- (void)showAction{
    _showBtn.selected = !_showBtn.selected;
    if (_showBtn.selected) {
        _showLbl.text = @"收起";
        _showView.image = [UIImage imageNamed:@"shouqi_p"];
        
        
        // 改变简介的高度
        NSString * str = _sbModel.data[@"certified"][@"brief"];
        _introduceLbl.text = str;
        CGFloat x = 15*IPHONE6_W_SCALE;
        CGFloat y = 59*IPHONE6_H_SCALE;
        CGFloat w = WIDTH - 2 * x;
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = Font13;
        CGRect rect = [str boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        _introduceLbl.frame =(CGRect){{x, y},rect.size};
        
        CGFloat separateY = CGRectGetMaxY(_introduceLbl.frame) + 19*IPHONE6_H_SCALE;
        _separate.frame = CGRectMake(0, separateY, WIDTH, 20*IPHONE6_H_SCALE);
        
        CGFloat tableY = CGRectGetMaxY(_separate.frame);
        _tableView1.frame = CGRectMake(0, tableY, WIDTH, HEIGHT-tableY);
        
    }else{
        _showLbl.text = @"展开";
        _showView.image = [UIImage imageNamed:@"zhankai_p"];
        
        // 改变高度
        NSString * str = _sbModel.data[@"certified"][@"brief"];
        str = [str substringToIndex:100];
        _introduceLbl.text = str;
        CGFloat x = 15*IPHONE6_W_SCALE;
        CGFloat y = 59*IPHONE6_H_SCALE;
        CGFloat w = WIDTH - 2 * x;
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = Font13;
        CGRect rect = [str boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        _introduceLbl.frame =(CGRect){{x, y},rect.size};
        
        CGFloat separateY = CGRectGetMaxY(_introduceLbl.frame) + 19*IPHONE6_H_SCALE;
        _separate.frame = CGRectMake(0, separateY, WIDTH, 20*IPHONE6_H_SCALE);
        CGFloat tableY = CGRectGetMaxY(_separate.frame);
        _tableView1.frame = CGRectMake(0, tableY, WIDTH, HEIGHT-tableY);
    }
}

- (void)addRefreshWith:(UITableView *)tableView{
    //    // 添加刷新和加载
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    tableView.header = header;
    [header beginRefreshing];
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多赛事" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    tableView.footer = footer;
}
#pragma mark --- 表格3加刷新和加载功能
- (void)addRefreshByTable3{
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData3)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView3.header = header;
    [header beginRefreshing];
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData3)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多赛事" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    _tableView3.footer = footer;
}
#pragma mark 表格3的加载和刷新
- (void)loadNewData3{
    
    [_tableView3.header endRefreshing];
}
- (void)loadMoreData3{
    
    // 上拉加载获取更多回复
    MyReplyFrameModel * myReFrameModel = [self.dataSource3 lastObject];
    MyReplyModel * myReModel = myReFrameModel.myreplyModel;
    NSString * userid = myReModel.userid;
    NSString * comment_id = myReModel.comment_id;
    NSString * url = [MoreReplysURL stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", userid, comment_id]];
    [DataTool getMoreReplysDataWithStr:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"-----%@", responseObject);
        [self.tableView3.footer endRefreshing];
        if (!responseObject) {
            self.tableView3.footer.state = MJRefreshStateNoMoreData;
        }
        for (MyReplyModel * model in responseObject) {
            MyReplyFrameModel * myReFrameModel = [[MyReplyFrameModel alloc] init];
            myReFrameModel.myreplyModel = model;
            [self.dataSource3 addObject:myReModel];
        }
        [self.tableView3 reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取更多回复出错：%@", error);
        
    }];
    
}

- (void)loadNewData:(UITableView *)tableView{
    
    [DataTool getSBDataWithStr:self.userURL parameters:nil success:^(id responseObject) {
        [self.tableView2.header endRefreshing];
        
        SBModel * sbModel = [[SBModel alloc] init];
       
        sbModel = responseObject;
        _sbModel = sbModel;
        NSMutableArray * arr = [NSMutableArray array];
        for (PostsModel * model in sbModel.app_my) {
            PostFrameModel * frameModel = [[PostFrameModel alloc] init];
            frameModel.postsModel = model;
            [arr addObject:frameModel];
        }
        NSMutableArray * replyArr = [NSMutableArray array];
        for (MyReplyModel * model in sbModel.comment) {
            MyReplyFrameModel * myReFrameModel = [[MyReplyFrameModel alloc] init];
            myReFrameModel.myreplyModel = model;
            [replyArr addObject:myReFrameModel];
        }
        self.dataSource3 = replyArr;
        self.dataSource2 = arr;
        
        [self.tableView2 reloadData];
        [self.tableView3 reloadData];
        
        // 设置数据
        [self setDataWithModel:sbModel];
        
    } failure:^(NSError * error) {
        NSLog(@"获取个人主页出错：%@", error);
        [self.tableView2.header endRefreshing];
    }];
    
}
#pragma mark --- 设置数据
- (void)setDataWithModel:(SBModel *)sbModel{
    
    // 关注按钮
    if ([sbModel.data[@"is_follow"] isEqualToString:@"0"]) {    // 未关注
        [_attentionBtn setImage:[UIImage imageNamed:@"jiaguangzhu"] forState:UIControlStateNormal];
    } else{
        [_attentionBtn setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
    }
    // 头像
   [_faceView sd_setImageWithURL:[NSURL URLWithString:sbModel.data[@"info"][@"face"]] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
    
    // 姓名
    _nameLbl.text = sbModel.data[@"info"][@"username"];
  
    // 关注数
    _attentionLbl.text = [NSString stringWithFormat:@"关注  %@", sbModel.data[@"info"][@"row"]];
    
    // 粉丝数
    _fansLbl.text = [NSString stringWithFormat:@"被关注  %@", sbModel.data[@"info"][@"follow"]];;
    
    _certificateLbl.text = sbModel.data[@"certified"][@"title"];
    
    
    NSString * str = sbModel.data[@"certified"][@"brief"];
    str = [str substringToIndex:100];
    UILabel * introduceLbl = [[UILabel alloc] init];
    introduceLbl.backgroundColor = [UIColor greenColor];
    introduceLbl.text = str;
    introduceLbl.numberOfLines = 0;
    introduceLbl.font = Font13;
    introduceLbl.textColor = Color123;
    [_sc addSubview:introduceLbl];
    _introduceLbl = introduceLbl;
    CGFloat x = 15*IPHONE6_W_SCALE;
    CGFloat y = 59*IPHONE6_H_SCALE;
    CGFloat w = WIDTH - 2 * x;
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = Font13;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    introduceLbl.frame =(CGRect){{x, y},rect.size};
    
    UIView * separate = [[UIView alloc] init];
    [_sc addSubview:separate];
    _separate = separate;
    CGFloat separateY = CGRectGetMaxY(_introduceLbl.frame) + 19*IPHONE6_H_SCALE;
    separate.frame = CGRectMake(0, separateY, WIDTH, 20*IPHONE6_H_SCALE);
    separate.backgroundColor = SeparateColor;
    
    CGFloat tableY = CGRectGetMaxY(separate.frame);
    CGFloat scY = CGRectGetMaxY(_topView.frame) + 60 * IPHONE6_H_SCALE;
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake( 0 , tableY , WIDTH , HEIGHT -tableY-scY) style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.showsVerticalScrollIndicator = NO;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_sc addSubview:_tableView1];
    
    [self addTableHeaderView];
    [self addTableFooterView];
}

- (void)addTableHeaderView{
    UIView * headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, WIDTH, 87 * 0.5 * IPHONE6_H_SCALE);
    _tableView1.tableHeaderView = headerView;
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel * scoreLbl = [[UILabel alloc] init];
    scoreLbl.text = @"取得成绩";
    scoreLbl.font = Font16;
    [headerView addSubview:scoreLbl];
    scoreLbl.frame = CGRectMake(15 * IPHONE6_W_SCALE, 0, WIDTH, 87 * 0.5 * IPHONE6_H_SCALE);
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.right.equalTo(headerView.mas_right).offset(-15*IPHONE6_W_SCALE);
        make.bottom.equalTo(headerView.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
}
- (void)addTableFooterView{
    UIView * footerView = [[UIView alloc] init];
    _tableView1.tableFooterView = footerView;
    footerView.frame = CGRectMake(0, 0, WIDTH, 165 * IPHONE6_H_SCALE);
    footerView.backgroundColor = [UIColor redColor];
    UIView * separateView = [[UIView alloc] init];
    [footerView addSubview:separateView];
    separateView.frame = CGRectMake(0, 144*IPHONE6_H_SCALE, WIDTH, 20*IPHONE6_H_SCALE);
    separateView.backgroundColor = SeparateColor;
    
    UILabel * titleLbl = [[UILabel alloc] init];
    [footerView addSubview:titleLbl];
    titleLbl.text = @"风采展示";
    titleLbl.font = Font16;
    titleLbl.frame = CGRectMake(15*IPHONE6_W_SCALE, 0, WIDTH, 44*IPHONE6_H_SCALE);
    
    // 图片展示
    ShowPicView * showView = [[ShowPicView alloc] init];
    [footerView addSubview:showView];
    
    
}

- (void)loadMoreData:(UITableView *)tableView{
    
    
    PostFrameModel * frameModel = [self.dataSource2 lastObject];
    PostsModel * postModel = frameModel.postsModel;
    NSString * iD = postModel.iD;   // 帖子ID
    NSString * uid = postModel.uid; // 用户ID
    
    NSString * url = [MorePostsURL stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", uid, iD]];
    
    NSLog(@"%@", url);
    
    [DataTool GetMorePostsDataWithStr:url parameters:nil success:^(id responseObject) {
        
        [self.tableView2.footer endRefreshing];
        
        SBModel * sbModel = [[SBModel alloc] init];
        _sbModel = sbModel;
        sbModel = responseObject;
        if (!sbModel.app_my) {
            self.tableView2.footer.state = MJRefreshStateNoMoreData;
            [SVProgressHUD showSuccessWithStatus:@"没有更多数据"];
        }
        for (PostsModel * model in sbModel.app_my) {
            PostFrameModel * frameModel = [[PostFrameModel alloc] init];
            frameModel.postsModel = model;
            [self.dataSource2 addObject:frameModel];
        }
        [self.tableView2 reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取个人主页出错：%@", error);
        [self.tableView2.header endRefreshing];
    }];

}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView2) {
        
        return self.dataSource2.count;
    } else if(tableView == self.tableView3){
        return self.dataSource3.count;
    } else{
        NSArray * chroArr = _sbModel.data[@"certified"][@"chronology"];
        // 字典数组转模型数组
        NSArray * scoreModelArr = [ScoreModel objectArrayWithKeyValuesArray:chroArr];
        return scoreModelArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView2) {
        PostCell * cell = [PostCell cellWithTableView:tableView];
        PostFrameModel * frameModel = self.dataSource2[indexPath.row];
        cell.frameModel = frameModel;
        return cell;
    }else if(tableView == self.tableView3){
        
        MyReplyCell * cell = [MyReplyCell cellWithTableView:tableView];
        cell.myReplyFrameModel = self.dataSource3[indexPath.row];
        return cell;

    } else{

        ScoreCell * cell = [ScoreCell cellWithTableView:tableView];
        NSArray * chroArr = _sbModel.data[@"certified"][@"chronology"];
        // 字典数组转模型数组
        NSArray * scoreModelArr = [ScoreModel objectArrayWithKeyValuesArray:chroArr];
        NSInteger row = indexPath.row;
        ScoreModel * scoreModel = [scoreModelArr objectAtIndex:row];
        cell.scoreModel = scoreModel;
        return cell;
    }
    
}
#pragma mark -- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView2) {
        NSLog(@"%lu", self.dataSource2.count);
        PostFrameModel * frameModel = self.dataSource2[indexPath.row];
        CGFloat cellHeight = frameModel.cellHeight;
        return cellHeight;
    } else if(tableView == _tableView3){
        MyReplyFrameModel * myReFrameModel = self.dataSource3[indexPath.row];
        
        return myReFrameModel.cellHeight;
    } else{
        //  如果是最后一个单元格
        CGFloat scoreX = 37*IPHONE6_W_SCALE;
        CGFloat scoreY = 0;
        CGFloat scoreW = WIDTH - 2 * scoreX;
        NSMutableDictionary * scoreDic = [NSMutableDictionary dictionary];
        scoreDic[NSFontAttributeName] = Font13;
        NSArray * chroArr = _sbModel.data[@"certified"][@"chronology"];
        // 字典数组转模型数组
        NSArray * scoreModelArr = [ScoreModel objectArrayWithKeyValuesArray:chroArr];
        NSInteger row = indexPath.row;
        ScoreModel * scoreModel = [scoreModelArr objectAtIndex:row];
        CGRect scoreRect = [scoreModel.Content boundingRectWithSize:CGSizeMake(scoreW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:scoreDic context:nil];
        CGFloat height = scoreRect.size.height;
        
        NSLog(@"%f", height);
        
        return height +51*IPHONE6_H_SCALE;
        // 84 +18
        return 100;
        
    }
    
}
#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView2) {
        // 跳转到帖子详情页
        PostDetailVC * detailVC = [[PostDetailVC alloc] init];
        PostFrameModel * model = self.dataSource2[indexPath.row];
        
        detailVC.wapurl = model.postsModel.wapurl;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        NSLog(@"%lu", indexPath.row);
    }
}


// 设置状态栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
