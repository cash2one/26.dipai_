//
//  AnyBodyVC.m
//  dipai
//
//  Created by 梁森 on 16/7/5.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AnyBodyVC.h"

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
// 最后一个单元格
#import "FooterCell.h"

// 回帖用户模型
#import "ReplyModel.h"
// 某人主页模型
#import "SBModel.h"
// 帖子详情页
#import "PostDetailVC.h"

#import "LSAlertView.h"
// 登录页面
#import "LoginViewController.h"
// 资讯、图集详情页
#import "DetailWebViewController.h"
// 视频详情页
#import "VideoViewController.h"
// 赛事详情页
#import "MatchDetailVC.h"


// 更多名人列表／粉丝列表／关注列表
#import "MorePokersVC.h"

#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "HttpTool.h"
#import "AFNetworking.h"
#import "DataTool.h"
@interface AnyBodyVC ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, LSAlertViewDeleagte>

{
    UISegmentedControl *_segmented;
    // 滚动视图
    UIScrollView *_sc;
    NSString * _flag;
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
/**
 *  VIP标识
 */
@property (nonatomic, strong) UIImageView * vipView;

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

/**
 *  登录提示框
 */
@property (nonatomic, strong) LSAlertView * alertView;
@property (nonatomic, strong) UIView * alertBackView;

@end

@implementation AnyBodyVC
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
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
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
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"%@", self.userURL);
    
    // 设置导航栏
    [self setUpNavigationBar];
    
    // 添加三个页面的标题
    [self addThreePages];
    
    // 添加滚动视图
    [self addScrollView];
    
    // 添加三个表格
    [self addTableView];
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
    
    faceView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigFace:)];
    [faceView addGestureRecognizer:tap];
    
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
    UIImageView * vipView = [[UIImageView alloc] init];
    vipView.image = [UIImage imageNamed:@"vip"];
    [topView addSubview:vipView];
    [vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(faceView.mas_right).offset(-5);
        make.bottom.equalTo(faceView.mas_bottom);
        make.width.equalTo(@(17 * IPHONE6_W_SCALE));
        make.height.equalTo(@(17 * IPHONE6_W_SCALE));
    }];
    vipView.hidden = YES;
    _vipView = vipView;
    
    // 关注按钮
    UIButton * attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
#warning 修改
    //    [attentionBtn setImage:[UIImage imageNamed:@"jiaguangzhu"] forState:UIControlStateNormal];
    [topView addSubview:attentionBtn];
    _attentionBtn = attentionBtn;
    [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(64 * IPHONE6_H_SCALE);
        make.right.equalTo(topView.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.width.equalTo(@(61*IPHONE6_W_SCALE));
        make.height.equalTo(@(22 * IPHONE6_W_SCALE));
    }];
    attentionBtn.userInteractionEnabled = YES;
    // 要将按钮的父视图（UIImageView设置为可与用户交互）
    topView.userInteractionEnabled = YES;
    // 关注事件
    [attentionBtn addTarget:self action:@selector(attentionAction) forControlEvents:UIControlEventTouchUpInside];
    
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
        make.height.equalTo(@(17*IPHONE6_W_SCALE + 1.5));
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
    
    // 关注数按钮
    UIButton * atttionNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:atttionNumBtn];
    [atttionNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(attentionLbl.mas_left).offset(-5);
        make.right.equalTo(attentionLbl.mas_right).offset(5);
        make.top.equalTo(attentionLbl.mas_top).offset(-5);
        make.bottom.equalTo(attentionLbl.mas_bottom).offset(5);
    }];
    [atttionNumBtn addTarget:self action:@selector(showAtttionNum) forControlEvents:UIControlEventTouchUpInside];
    
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
    // 粉丝数按钮
    UIButton * fansNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:fansNumBtn];
    [fansNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fansLbl.mas_left).offset(-5);
        make.top.equalTo(fansLbl.mas_top).offset(-5);
        make.right.equalTo(fansLbl.mas_right).offset(5);
        make.bottom.equalTo(fansLbl.mas_bottom).offset(5);
    }];
    [fansNumBtn addTarget:self action:@selector(showFans) forControlEvents:UIControlEventTouchUpInside];
    
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
#pragma mark --- showBigFace
- (void)showBigFace:(UIGestureRecognizer *)tap{
    UIImageView *tapView = (UIImageView *)tap.view;
    // CZPhoto -> MJPhoto
    int i = 0;
    NSMutableArray *arrM = [NSMutableArray array];
    NSString * faceStr = _sbModel.data[@"info"][@"max_face"];
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObject:faceStr];
    for (NSString *photo in arr) {
        
        //        NSLog(@"%@", photo);
        
        MJPhoto *p = [[MJPhoto alloc] init];
        p.url = [NSURL URLWithString:photo];
        p.index = i;
        p.srcImageView = tapView;
        [arrM addObject:p];
        i++;
    }
    
    
    // 弹出图片浏览器
    // 创建浏览器对象
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    // MJPhoto
    brower.photos = arrM;
    brower.currentPhotoIndex = tapView.tag;
    [brower show];
}
#pragma mark --展示关注列表
- (void)showAtttionNum{
    NSLog(@"展示关注列表");
    NSString * userid = _sbModel.userid;
    MorePokersVC * attentionVC = [[MorePokersVC alloc] init];
    attentionVC.wapurl = [AttentionsURL stringByAppendingString:userid];
    attentionVC.titleStr = @"关注";
    NSLog(@"%@", attentionVC.wapurl);
    
    [self.navigationController pushViewController:attentionVC animated:YES];
}
#pragma mark --- 展示粉丝列表
- (void)showFans{
    NSLog(@"展示粉丝列表");
    NSString * userid = _sbModel.userid;
    MorePokersVC * fansVC = [[MorePokersVC alloc] init];
    fansVC.wapurl = [FansURL stringByAppendingString:userid];
    fansVC.titleStr = @"被关注";
    NSLog(@"%@", fansVC.wapurl);
    
    [self.navigationController pushViewController:fansVC animated:YES];
}
#pragma mark --- 关注事件
- (void)attentionAction{
    
    //  判断用户是否登录
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if (cookieName || wxData) {
        
        [self payAttentionWhenLogin];
    }else{
        // 未登陆要进行登陆
        [self addAlertView];
    }
}

- (void)payAttentionWhenLogin{

    // 已登陆直接进行操作
    // 如果要进行关注可以直接关注，而如果要取消关注则需要进行以下确认
    NSLog(@"%@", _sbModel.data[@"is_follow"]);
    
    if ([_sbModel.data[@"is_follow"] isEqualToString:@"0"]) {    // 未关注
        
        NSString * url = [PayAttentionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", _sbModel.userid]];
        [DataTool PayAttentionOrCancleWithStr:url parameters:nil success:^(id responseObject) {
#warning 返回的data有问题
            // 要根据返回的data判断有没有进行关注
            if ([responseObject[@"data"] isEqualToString:@"0"]) {   // 未关注
                // 取消关注成功
                [_attentionBtn setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
            } else{
                // 关注成功
                [_attentionBtn setImage:[UIImage imageNamed:@"jiaguangzhu"] forState:UIControlStateNormal];
            }
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            [_tableView2.header beginRefreshing];
        } failure:^(NSError * error) {
            NSLog(@"关注或取消失败错误%@", error);
        }];
    }
    if ([_sbModel.data[@"is_follow"] isEqualToString:@"1"]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定不再关注此人" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        UIAlertAction * OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 进行取消关注的操作
            [_attentionBtn setImage:[UIImage imageNamed:@"jiaguangzhu"] forState:UIControlStateNormal];
            NSString * url = [PayAttentionURL stringByAppendingString:[NSString stringWithFormat:@"/%@",_sbModel.userid]];
            [DataTool PayAttentionOrCancleWithStr:url parameters:nil success:^(id responseObject) {
                
                NSLog(@"进行取消关注获取到的数据%@", responseObject);
                NSLog(@"content:%@", responseObject[@"content"]);
            } failure:^(NSError * error) {
                NSLog(@"进行取消关注操作时出错%@", error);
            }];
            // 对数据的刷新还有影响
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            [_tableView2.header beginRefreshing];
        }];
        
        [alert addAction:cancle];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
    _segmented = [[UISegmentedControl alloc]initWithItems:@[@"发帖", @"回复"]];
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
        make.centerX.equalTo(self.view.mas_centerX).offset(-44*IPHONE6_W_SCALE);
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
            _redView.transform = CGAffineTransformMakeTranslation(84*IPHONE6_W_SCALE, 0);
            
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
    _sc.contentSize=CGSizeMake(WIDTH * 2 , HEIGHT-scY);
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
            _redView.transform = CGAffineTransformMakeTranslation(84*IPHONE6_W_SCALE, 0);
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
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH , HEIGHT -scY) style:UITableViewStylePlain];
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    _tableView2.showsVerticalScrollIndicator=NO;
    _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_sc addSubview:_tableView2];
    
    _tableView3=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH , HEIGHT -scY) style:UITableViewStylePlain];
    _tableView3.delegate=self;
    _tableView3.dataSource=self;
    _tableView3.showsVerticalScrollIndicator=NO;
    _tableView3.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_sc addSubview:_tableView3];
    
    //    [self addRefreshWith:_tableView1];
    [self addRefreshWith:_tableView2];
    
    [self addRefreshByTable3];
    
}
//  发帖单元格添加刷新加载效果
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
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
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
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    _tableView3.footer = footer;
}
#pragma mark 表格3的加载和刷新
- (void)loadNewData3{
    
    [_tableView3.header endRefreshing];
}
- (void)loadMoreData3{
    
//    [_tableView3.footer endRefreshing];
    
    // 上拉加载获取更多回复
    MyReplyFrameModel * myReFrameModel = [self.dataSource3 lastObject];
    MyReplyModel * myReModel = myReFrameModel.myreplyModel;
    NSString * userid = myReModel.userid;
    NSString * comment_id = myReModel.comment_id;
    NSString * url = [MoreReplysURL stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", userid, comment_id]];
    
    NSLog(@"%@", url);
    
    [DataTool getMoreReplysDataWithStr:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"-----%@", responseObject);
        [self.tableView3.footer endRefreshing];
        if (!responseObject) {
            self.tableView3.footer.state = MJRefreshStateNoMoreData;
        }else{
            for (MyReplyModel * model in responseObject) {
                MyReplyFrameModel * myReFrameModel = [[MyReplyFrameModel alloc] init];
                myReFrameModel.myreplyModel = model;
                [self.dataSource3 addObject:myReFrameModel];
            }
        }
       
        [self.tableView3 reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取更多回复出错：%@", error);
        
    }];
    
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
        }else{
            for (PostsModel * model in sbModel.app_my) {
                PostFrameModel * frameModel = [[PostFrameModel alloc] init];
                frameModel.postsModel = model;
                [self.dataSource2 addObject:frameModel];
            }
        }
        
        [self.tableView2 reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取个人主页出错：%@", error);
        [self.tableView2.header endRefreshing];
    }];
    
}
- (void)loadNewData:(UITableView *)tableView{
    
//    NSLog(@"%@", self.userURL);
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
    } else if([sbModel.data[@"is_follow"] isEqualToString:@"1"])
    {
        [_attentionBtn setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
    } else{ // 如果是自己
        _attentionBtn.hidden = YES;
    }
    _attentionBtn.userInteractionEnabled = YES;
    //    [_attentionBtn addTarget:self action:@selector(attentionAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 头像
    [_faceView sd_setImageWithURL:[NSURL URLWithString:sbModel.data[@"info"][@"face"]] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
    
    // 姓名
    _nameLbl.text = sbModel.data[@"info"][@"username"];
    
    // 关注数
    _attentionLbl.text = [NSString stringWithFormat:@"关注  %@", sbModel.data[@"info"][@"row"]];
    
    // 粉丝数
    _fansLbl.text = [NSString stringWithFormat:@"被关注  %@", sbModel.data[@"info"][@"follow"]];;
    
    if (![sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {
        _vipView.hidden = NO;   // 如果是经过底牌认证的就显示出来
    }
    
    NSString * str;
    if ([sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {   // 如果不属于底牌认证
        
        _certificateLbl.text = @"";
        str = @"";
        _showBtn.userInteractionEnabled = NO;
        
    } else{
        _certificateLbl.text = sbModel.data[@"certified"][@"title"];
        str = sbModel.data[@"certified"][@"brief"];
        str = [str substringToIndex:100];
        _showBtn.userInteractionEnabled = YES;
    }

    
    
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView2) {
        
        return self.dataSource2.count;
    } else if(tableView == self.tableView3){
        return self.dataSource3.count;
    } else{
        if (![_sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {  // 如果不是空
            NSArray * chroArr = _sbModel.data[@"certified"][@"chronology"];
            // 字典数组转模型数组
            NSArray * scoreModelArr = [ScoreModel objectArrayWithKeyValuesArray:chroArr];
            return scoreModelArr.count + 1;
        } else{ // 如果不是底牌认证
            return 0;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView2) { // 发帖页面
        PostCell * cell = [PostCell cellWithTableView:tableView];
        PostFrameModel * frameModel = self.dataSource2[indexPath.row];
        cell.frameModel = frameModel;
        return cell;
    }else if(tableView == self.tableView3){ // 回复页面
        
        MyReplyCell * cell = [MyReplyCell cellWithTableView:tableView];
        cell.myReplyFrameModel = self.dataSource3[indexPath.row];
        return cell;
        
    } else{
        
        if (![_sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {  // 如果是底牌认证
            NSArray * chroArr = _sbModel.data[@"certified"][@"chronology"];
            NSArray * atlasArr = _sbModel.data[@"certified"][@"atlas"];
            // 字典数组转模型数组
            NSArray * scoreModelArr = [ScoreModel objectArrayWithKeyValuesArray:chroArr];
            NSInteger row = indexPath.row;
            
            if (row!=scoreModelArr.count) {
                ScoreModel * scoreModel = [scoreModelArr objectAtIndex:row];
                ScoreCell * cell = [ScoreCell cellWithTableView:tableView];
                cell.scoreModel = scoreModel;
                return cell;
            } else{ // 最后一个单元格
                FooterCell * cell = [FooterCell cellWithTableView:tableView];
                cell.atlasArr = atlasArr;
                return cell;
            }
        }else{
            static NSString * cellID = @"cellID";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            
            return cell;
        }
        
    }
    
}
#pragma mark -- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView2) {
        NSLog(@"%lu", self.dataSource2.count);
        PostFrameModel * frameModel = self.dataSource2[indexPath.row];
        CGFloat cellHeight = frameModel.cellHeight;
        return cellHeight;
    } else{
        MyReplyFrameModel * myReFrameModel = self.dataSource3[indexPath.row];
        
        return myReFrameModel.cellHeight;
    }
    
//    if (tableView == _tableView2) {
//        NSLog(@"%lu", self.dataSource2.count);
//        PostFrameModel * frameModel = self.dataSource2[indexPath.row];
//        CGFloat cellHeight = frameModel.cellHeight;
//        return cellHeight;
//    } else if(tableView == _tableView3){
//        MyReplyFrameModel * myReFrameModel = self.dataSource3[indexPath.row];
//        
//        return myReFrameModel.cellHeight;
//    } else{
//        //  如果是最后一个单元格
//        CGFloat scoreX = 37*IPHONE6_W_SCALE;
//        CGFloat scoreW = WIDTH - 2 * scoreX;
//        NSMutableDictionary * scoreDic = [NSMutableDictionary dictionary];
//        scoreDic[NSFontAttributeName] = Font13;
//        NSArray * chroArr = _sbModel.data[@"certified"][@"chronology"];
//        // 字典数组转模型数组
//        NSArray * scoreModelArr = [ScoreModel objectArrayWithKeyValuesArray:chroArr];
//        NSInteger row = indexPath.row;
//        
//        if (row!=scoreModelArr.count) {
//            ScoreModel * scoreModel = [scoreModelArr objectAtIndex:row];
//            CGRect scoreRect = [scoreModel.Content boundingRectWithSize:CGSizeMake(scoreW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:scoreDic context:nil];
//            CGFloat height = scoreRect.size.height;
//            return height +51*IPHONE6_H_SCALE;
//        } else{
//            return 165 * IPHONE6_H_SCALE;
//        }
//        // 84 +18
//    }
    
}
#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView2) { // 发帖页面
        // 跳转到帖子详情页
        PostDetailVC * detailVC = [[PostDetailVC alloc] init];
        PostFrameModel * model = self.dataSource2[indexPath.row];
        detailVC.heightStr = @"64";
        detailVC.wapurl = model.postsModel.wapurl;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{  // 回复页面
        NSLog(@"%lu", indexPath.row);
        // 回复的情况：1.资讯／图集  2.视频  3.帖子  4.赛事评论
        MyReplyFrameModel * myReFrameModel = self.dataSource3[indexPath.row];
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
                postDetail.heightStr = @"64";
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

// 设置状态栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
