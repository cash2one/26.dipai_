//
//  VideoViewController.m
//  dipai
//
//  Created by 梁森 on 16/6/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "VideoViewController.h"

#import "DataTool.h"
// 视频模型
#import "VideoModel.h"
// 视频列表模型
#import "AlbumModel.h"


// 相关视频的模型
#import "AssociatedModel.h"
// 头视图
#import "HeaderView.h"
// 自定义单元格
#import "InformationCell.h"
// 底部视图
#import "BottomView.h"
// 视频列表
#import "AlbumViewController.h"
// 评论列表
#import "CommentsViewController.h"
// 视频列表的底图
#import "BackViewOfTable.h"

#import "BackgroundView.h"
#import "CommentView.h"
// 自定义提示框
#import "LSAlertView.h"

#import "Masonry.h"

#import "SVProgressHUD.h"
// 登录页面
#import "LoginViewController.h"

#import "UMSocial.h"
@interface VideoViewController ()<TCPlayerEngineDelegate, BottomViewDelegate, CommentViewDelegate, AlbumViewControllerDelegate, LSAlertViewDeleagte,UMSocialUIDelegate, UITableViewDataSource, UITableViewDelegate>
{
    TCPlayerView * _playerView;
    UIButton * _playBtn;
    //    UIView * _backView;
    
    // 发表的内容
    NSString * _sendContent;
    // 要进行评论的视频的ID
    NSString * _iD;
    
    // 分享需要图片、标题、描述、视频链接
    // 进行转发的标题
    NSString * _title;
    // 进行转发的描述
    NSString * _description;
    // 进行转发的网址
    NSString * _wapurl;
    // 图片地址
    NSString * _picUrl;
    
    // 用来记录当前播放视频的下标
    int _index;
}

@property (nonatomic, strong) UIView * blackView;
@property (nonatomic, strong) VideoModel * videoModel;
/**
 *  视频标题
 */
@property (nonatomic, strong) UILabel * titleLbl;
/**
 *  视频描述
 */
@property (nonatomic, strong) UILabel * descriptionLbl;
/**
 *  视频详细描述
 */
@property (nonatomic, strong) UILabel * summaryLbl;
/**
 *  展开视频按钮
 */
@property (nonatomic, strong) UIImageView * openImage;
/**
 *  视频下标标签
 */
@property (nonatomic, strong) UILabel * numLbl;
/**
 *  表格
 */
@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) HeaderView * headerView;
/**
 *  展开图片
 */
@property (nonatomic, strong) UIImageView * openPic;
/**
 *  展开按钮
 */
@property (nonatomic, strong) UIButton * openPicBtn;
/**
 *  详细描述文字
 */
@property (nonatomic, copy) NSString * summaryStr;
/**
 *  分割条
 */
@property (nonatomic, strong) UIView * separateView;
/**
 *  底部视图
 */
@property (nonatomic, strong) BottomView * bottomView;

@property (nonatomic, strong) BackgroundView * backView;
@property (nonatomic, strong) CommentView * commentView;

// 提示框的背景图
@property (nonatomic, strong) BackgroundView * alertBackView;
// 提示框
@property (nonatomic, strong) LSAlertView * alertView ;

/**
 *  视频列表表格
 */
@property (nonatomic, strong) AlbumViewController * albumVC;
// 相关视频视图
@property (nonatomic, strong) UIView * associateView;

// 返回按钮图片
@property (nonatomic, strong) UIImageView * returnView;
// 返回按钮
@property (nonatomic, strong) UIButton * returnBtn;


@end

@implementation VideoViewController

- (AlbumViewController *)albumVC{
    if (_albumVC == nil) {
        _albumVC = [[AlbumViewController alloc] init];
        _albumVC.delegate = self;
    }
    return _albumVC;
}

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

#pragma mark --- 隐藏navigationBar
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    // 视图出现以后就开始播放视频
    [self playVideo];
    // 显示或隐藏进度条
    [_playerView autoShowOrHideBottomView:5];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 每次进来的时候都要检测是否登录
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if ((cookieName || wxData) && _sendContent) {  // 如果已经登录，并且有发表内容，则进行发表
        NSMutableDictionary * CommentDic = [NSMutableDictionary dictionary];
        CommentDic[@"id"] = _iD;
        CommentDic[@"types"] = @"0";   // 0:评论 1:回复
        CommentDic[@"type"] = @"11";
        CommentDic[@"content"] = _sendContent;
        [DataTool postWithStr:SendComment parameters:CommentDic success:^(id responseObject) {
            
            NSLog(@"发表评论返回的数据---%@", responseObject);
            NSString * content = [responseObject objectForKey:@"content"];
            NSLog(@"－－content--%@", content);
            
            [SVProgressHUD showSuccessWithStatus:@"发表成功"];
        } failure:^(NSError * error) {
            
            NSLog(@"发表评论的错误信息%@", error);
            
        }];
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
//    [_playerView stop];
}
#pragma mark --- 显示navigationBar
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    [BackViewOfTable hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.view.backgroundColor = [UIColor whiteColor];
//    // 设置状态栏
    [self setUpStatusBar];
//
//    // 搭建界面
    [self setUpUI];
//
//    NSLog(@"%@", self.url);
//    // 获取网络上的数据
    [self getVideoDataWithURL:self.url];
//    // 在分享中添加自定义按钮
//    [self addCustomShareBtn]; // 可能造成了内存泄漏    分享功能暂时未开放
//    // 对键盘添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

#pragma mark --- 添加复制链接按钮
- (void)addCustomShareBtn
{
    NSLog(@"暂时不用此功能了");
//    UMSocialSnsPlatform *snsPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"CustomPlatform"];
//    // 设置自定义分享按钮的名称
//    snsPlatform.displayName = @"复制链接";
//    // 设置自定义分享按钮的图标
//    snsPlatform.bigImageName = @"fuzhilianjie";
//    //    __weak typeof(self) weakSelf = self;
//    // 监听自定义按钮的点击事件
//    snsPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
//        UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
//        pastboad.string = _wapurl;
//        NSLog(@"复制的链接：%@", _wapurl);
//        [SVProgressHUD showSuccessWithStatus:@"复制链接成功"];
//        
//    };
//    
//    // 添加自定义平台
//    [UMSocialConfig addSocialSnsPlatform:@[snsPlatform]];
//    // 设置你要在分享面板中出现的平台
//    [UMSocialConfig setSnsPlatformNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,@"CustomPlatform"]];
}

// 键盘发生变化后通知
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

#pragma mark --- 设置状态栏
- (void)setUpStatusBar{
    UIView * statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    statusBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBar];
}

#pragma mark --- 设置状态栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark --- 获取视频数据
- (void)getVideoDataWithURL:(NSString *)url{
//    NSLog(@"%@", url);
    [DataTool getVideoDataWithStr:url parameters:nil success:^(id responseObject) {
        
        _videoModel = responseObject;
        
        // 分享需要的东西
        _title = _videoModel.title;
        _description = _videoModel.descriptioN;
        _picUrl = _videoModel.picname;
        _wapurl = _videoModel.videourl;
        
        _iD = _videoModel.iD;
        NSArray * associateArr = _videoModel.associated;
        
        NSString * videoUrl = _videoModel.videourl;
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:videoUrl forKey:VideoUrl];
        [defaults synchronize];
        // 数据源中的数据是相关视频
        self.dataSource = (NSMutableArray *)associateArr;
        
        [self addTableviewHeaderView];
        
        // 设置数据
        [self setData];
        // 用表格试一下，进行一下刷新
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取视频数据的错误信息：%@", error);
    }];
}


#pragma mark --- 设置数据
- (void)setData{
    // 视频下标签
    _titleLbl.text = _videoModel.title;
    
    // 视频评论数
    _bottomView.commentsLbl.text = _videoModel.commentNumber;
    
    // 视频列表中的视频数
    NSUInteger counts = _videoModel.album.count;
    
    // 描述
    _descriptionLbl.text = _videoModel.title;
    // 详细描述
    _summaryLbl.text = _videoModel.descriptioN;
    
    NSArray * albums = _videoModel.album;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * videoUrl = [defaults objectForKey:VideoUrl];
    
    int i = 0;
    for (AlbumModel * model in albums) {
//        NSLog(@"循环中...%d", i ++);
        i += 1;
        if ([videoUrl isEqualToString:model.videourl]) {
//            NSLog(@"循环次数---%d", i);
            // 将视频下标存储，下标从1开始
            _index = i;
            break;
        }
    }
    // 视频下标
    _numLbl.text = [NSString stringWithFormat:@"%d/%lu",_index ,counts];
    
    
    // 设置评论数
    NSLog(@"---发表评论数---%@", _videoModel.commentNumber);
    if ([_videoModel.commentNumber integerValue] >= 100) {
        _bottomView.commentsLbl.text = @"99+";
    } else{
        if ([_videoModel.commentNumber integerValue] == 0) {
            _bottomView.commentsLbl.hidden = YES;
        }else{
            _bottomView.commentsLbl.text = _videoModel.commentNumber;
        }
    }
    // 判断收藏按钮的状态
    
    NSLog(@"---收藏的状态---%@", _videoModel.is_collection);
    if ([_videoModel.is_collection isEqualToString:@"1"]) {
        _bottomView.collectionBtn.selected = YES;
    } else{
        _bottomView.collectionBtn.selected = NO;
    }
}

#pragma mark --- 搭建界面
- (void)setUpUI{
    // 创建播放视图
    _playerView = [[TCPlayerView alloc] init];
    _playerView.frame = CGRectMake( 0 , 20 , WIDTH , 422 / 2 * IPHONE6_H_SCALE);
    _playerView.defaultForceToOrientation = UIDeviceOrientationLandscapeLeft;
    [self.view addSubview:_playerView];
    // 缓存，下次播放有效
    _playerView.enableCache = YES;
    // 如果设为真，则清除本次播放过程中的Cache文件
    _playerView.clearPlayCache = YES;
    // 设置代理
    _playerView.playerDelegate = self;
    
    // 清除缓存按钮
    UIButton * clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 450, 80, 30)];
    clearBtn.backgroundColor = [UIColor blueColor];
    [clearBtn setTitle:@"清除缓存" forState:UIControlStateNormal];
//    [self.view addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    
    // 返回按钮
    UIImageView * returnView = [[UIImageView alloc] init];
    returnView.userInteractionEnabled = YES;
    CGFloat x = Margin30 * IPHONE6_W_SCALE;
    CGFloat y = Margin25 * IPHONE6_H_SCALE;
    CGFloat w = Margin20 * IPHONE6_W_SCALE;
    CGFloat h = 38 / 2 * IPHONE6_H_SCALE;
    returnView.frame = CGRectMake(x,  y, w, h);
    returnView.image = [UIImage imageNamed:@"houtui_baise"];
    returnView.userInteractionEnabled = YES;
    [_playerView addSubview:returnView];
    _returnView = returnView;
//    [self.view addSubview:returnView];
    
    UIButton * returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    CGFloat btnX = 0;
//    CGFloat btnY = 0;
//    CGFloat btnW = 50;
//    CGFloat btnH = 40;
//    returnBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
//    returnBtn.backgroundColor = [UIColor clearColor];
//     returnBtn.backgroundColor = [UIColor redColor];
    [returnBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [_playerView addSubview:returnBtn];
    [returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(returnView.mas_left).offset(-10);
        make.top.equalTo(returnView.mas_top).offset(-10);
        make.right.equalTo(returnView.mas_right).offset(20);
        make.bottom.equalTo(returnView.mas_bottom).offset(10);
    }];
    _returnBtn = returnBtn;
    
    // 播放器下方的标题
    UIView * blackView = [[UIView alloc] init];
    blackView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1];
    CGFloat blackX = 0;
    CGFloat blackY = CGRectGetMaxY(_playerView.frame);
    CGFloat blackW = WIDTH;
    CGFloat blackH = 80 / 2 * IPHONE6_H_SCALE;
    blackView.frame = CGRectMake(blackX, blackY, blackW, blackH);
    [self.view addSubview:blackView];
    _blackView = blackView;
    
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.font = Font16;
    titleLbl.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
//    titleLbl.backgroundColor = [UIColor redColor];
    CGFloat titleX = Margin30 * IPHONE6_H_SCALE;
    CGFloat titleY = 0;
    CGFloat titleW = WIDTH - x - 60;
    CGFloat titleH = blackH;
    titleLbl.frame = CGRectMake(titleX, titleY, titleW, titleH);
    [blackView addSubview:titleLbl];
//    titleLbl.textColor = [UIColor redColor];
    _titleLbl = titleLbl;
    
    // 展开视频列表的按钮
    UIImageView * openImage = [[UIImageView alloc] init];
    [blackView addSubview:openImage];
    openImage.image = [UIImage imageNamed:@"zhankai"];
    [openImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(blackView.mas_right).offset(-Margin30 * IPHONE6_H_SCALE);
        make.top.equalTo(blackView.mas_top).offset(39 / 2 * IPHONE6_H_SCALE);
        make.width.equalTo(@(Margin22 * IPHONE6_W_SCALE));
        make.height.equalTo(@(12 / 2 * IPHONE6_H_SCALE));
    }];
    _openImage = openImage;
    
    UIButton * openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [blackView addSubview:openBtn];
    openBtn.backgroundColor = [UIColor colorWithRed:228 green:0 blue:0 alpha:0];
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(blackView.mas_right).offset(-Margin30 * IPHONE6_H_SCALE + 10);
        make.top.equalTo(blackView.mas_top).offset(39 / 2 * IPHONE6_H_SCALE - 10);
        make.width.equalTo(@(Margin22 * IPHONE6_W_SCALE + 20));
        make.height.equalTo(@(12 / 2 * IPHONE6_H_SCALE + 20));
    }];
    [openBtn addTarget:self action:@selector(openAlbum:) forControlEvents:UIControlEventTouchUpInside];
    
    // 视频下标标签
    UILabel * numLbl = [[UILabel alloc] init];
    numLbl.font = Font12;
    numLbl.text = @"";
    numLbl.textColor = [UIColor whiteColor];
    numLbl.textAlignment = NSTextAlignmentRight;
    [blackView addSubview:numLbl];
    [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blackView.mas_top).offset(30 / 2 * IPHONE6_H_SCALE);
        make.right.equalTo(openImage.mas_left).offset(-12 / 2 * IPHONE6_W_SCALE);
        make.height.equalTo(@(24 / 2 * IPHONE6_W_SCALE));
        make.width.equalTo(@(50));
    }];
    _numLbl = numLbl;
    
    // 底部视图
    [self addBottomView];
    
//    [self addTableviewHeaderView];

//    [self createTableView];
}
#pragma mark --- 添加头视图
- (void)addTableviewHeaderView{
    
    if (_descriptionLbl) {
        [_descriptionLbl removeFromSuperview];
    }
    // 描述
    UILabel * desLbl = [[UILabel alloc] init];
//    desLbl.backgroundColor = [UIColor redColor];
    desLbl.numberOfLines = 0;
//    desLbl.text = @"";
//    desLbl.text = @"我是中国人=我是中国人=我是中国人=我是中国人=我是中国人=我是中国人=我是中国人=我是中国人=我是中国人=我是中国人=我是中国人=我是中国人=我是中国人=";
    desLbl.text = _videoModel.title;
    desLbl.font = Font16;
    CGFloat desX = Margin30 * IPHONE6_W_SCALE;
    CGFloat desY = CGRectGetMaxY(_blackView.frame) + 26 / 2 * IPHONE6_H_SCALE;
    CGFloat desW = WIDTH -  desX - 60 * IPHONE6_W_SCALE;
//    CGFloat desW = WIDTH - 2 * desX;
    
    NSMutableDictionary * desDic = [NSMutableDictionary dictionary];
    desDic[NSFontAttributeName] = Font16;
    CGRect desRect = [desLbl.text boundingRectWithSize:CGSizeMake(desW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:desDic context:nil];
    desLbl.frame = (CGRect){{desX, desY}, desRect.size};
    
    [self.view addSubview:desLbl];
    _descriptionLbl = desLbl;
    
    // 展开按钮
    if (_openPic) {
        [_openPic removeFromSuperview];
    }
    UIImageView * openPic = [[UIImageView alloc] init];
    openPic.image = [UIImage imageNamed:@"zhankai"];
    [self.view addSubview:openPic];
    _openPic = openPic;
    [openPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-Margin30 * IPHONE6_W_SCALE);
        make.top.equalTo(_blackView.mas_bottom).offset(44 / 2 * IPHONE6_H_SCALE);
        make.width.equalTo(@(Margin22 * IPHONE6_W_SCALE));
        make.height.equalTo(@(12 / 2 * IPHONE6_H_SCALE));
    }];
    
    if (_openPicBtn) {
        [_openPicBtn removeFromSuperview];
    }
    UIButton * openPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openPicBtn.backgroundColor = [UIColor clearColor];
    [openPicBtn addTarget:self action:@selector(checkSummary:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openPicBtn];
    _openPicBtn = openPicBtn;
    [openPicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(openPic.mas_left).offset(-10);
        make.right.equalTo(openPic.mas_right).offset(10);
        make.top.equalTo(openPic.mas_top).offset(-10);
        make.bottom.equalTo(openPic.mas_bottom).offset(10);
    }];
    
    // summary
    if (_summaryLbl) {
        [_summaryLbl removeFromSuperview];
    }
    UILabel * summaryLbl = [[UILabel alloc] init];
//    summaryLbl.backgroundColor = [UIColor blueColor];
    summaryLbl.numberOfLines = 0;
//    summaryLbl.text = @"";
//    summaryLbl.text = @"我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人＝＝";
    summaryLbl.text = _videoModel.summary;
    if (summaryLbl.text.length > 54) {
        summaryLbl.text = [summaryLbl.text substringToIndex:54];
        summaryLbl.text = [NSString stringWithFormat:@"%@...", summaryLbl.text];
        _summaryStr = summaryLbl.text;
    } else{
        _summaryStr = summaryLbl.text;
    }
    summaryLbl.font = Font12;
    summaryLbl.textColor = Color123;
     _summaryLbl = summaryLbl;
    [self setSummaryFrame];
    [self.view addSubview:_summaryLbl];
    
    // 分割条
    if (_separateView) {
        [_separateView removeFromSuperview];
    }
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    CGFloat separateX = 0;
    CGFloat separateY = CGRectGetMaxY(_summaryLbl.frame) + 38 / 2 * IPHONE6_H_SCALE;
    CGFloat separateW = WIDTH;
    CGFloat separateH = Margin40 * IPHONE6_H_SCALE;
    separateView.frame = CGRectMake(separateX, separateY, separateW, separateH);
    [self.view addSubview:separateView];
    _separateView = separateView;
    
    // 相关视频
    if (_associateView) {
        [_associateView removeFromSuperview];
    }
    UIView * associateView = [[UIView alloc] init];
//    associateView.backgroundColor = [UIColor redColor];
    CGFloat associateX = 0;
    CGFloat associateY = CGRectGetMaxY(_separateView.frame);
    CGFloat associateW = WIDTH;
    CGFloat associateH = Margin60 * IPHONE6_H_SCALE;
    associateView.frame = CGRectMake(associateX, associateY, associateW, associateH);
    [self.view addSubview:associateView];
    _associateView = associateView;
    
    UILabel * associateLbl = [[UILabel alloc] init];
//    associateLbl.backgroundColor = [UIColor lightGrayColor];
    associateLbl.font = Font16;
    associateLbl.text = @"相关视频";
    [associateView addSubview:associateLbl];
    CGFloat associateLblX = Margin30 * IPHONE6_W_SCALE;
    CGFloat associateLblY = 27 / 2 * IPHONE6_H_SCALE;
//    CGFloat associateLbl
    NSMutableDictionary * associateDic = [NSMutableDictionary dictionary];
    associateDic[NSFontAttributeName] = Font16;
    CGSize associateSize = [associateLbl.text sizeWithAttributes:associateDic];
    associateLbl.frame = (CGRect){{associateLblX, associateLblY}, associateSize};
    
    // 表格
    [self createTableView];
    

}
#pragma mark --- 创建表格
- (void)createTableView{
    
    if (self.tableView) {
        [self.tableView removeFromSuperview];
    }
    
    CGFloat tableViewY = CGRectGetMaxY(_associateView.frame) ;
    CGFloat tableViewH = HEIGHT - tableViewY - Margin92 * IPHONE6_H_SCALE;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, WIDTH, tableViewH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.tableView];
}

#pragma mark --- 添加底部评论框
- (void)addBottomView
{
    BottomView * bottomView = [[BottomView alloc] init];
    bottomView.delegate = self;
    CGFloat x = 0;
    CGFloat y = HEIGHT - Margin92 * IPHONE6_H_SCALE;
    CGFloat w = WIDTH;
    CGFloat h = Margin92 * IPHONE6_H_SCALE;
    bottomView.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:bottomView];
    _bottomView = bottomView;

}
#pragma mark ---- BottomViewDelegate底部评论框定义的协议中的方法
// 评论、分享、查看评论详情  视频都会暂停
#pragma mark --- 点击评论按钮
- (void)commentAction
{
    // 暂停
    [_playerView pause];
    
    BackgroundView * backView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backView.backgroundColor = ColorBlack60;
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加到灰色的背景图
    [window addSubview:backView];
    _backView = backView;
    // 添加评论视图
    CommentView * commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, Margin242 * IPHONE6_H_SCALE)];
    commentView.delegate = self;
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
#pragma mark --- 灰色背景移出
- (void)removeFromSuperviewAction
{
    // 灰色背景移除
    [_backView removeFromSuperview];
    // 移除评论视图
    [_commentView removeFromSuperview];
    //    [_commentView.textView resignFirstResponder];
}

- (void)tapAction
{
    NSLog(@"tap...");
}

/**
 *  查看评论
 */
- (void)lookCommentsAction
{
    // 暂停播放
    [_playerView pause];
    CommentsViewController * commentsVC = [[CommentsViewController alloc] init];
    // 传类型：视频   传ID：视频ID
    commentsVC.type = @"11";
    commentsVC.iD = _iD;
    [self.navigationController pushViewController:commentsVC animated:YES];
}
/**
 *  收藏
 */
- (void)collectionAction
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if (userName || wxData) { // 如果已经登录
        if (!_bottomView.collectionBtn.selected) {  // 如果收藏按钮没有被选中
            
            // 进行收藏
            [self collectOrCancelCollect];
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        } else{     // 如果收藏按钮被选中
            
            //  取消收藏
            NSString * url = [CollectionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", _iD]];
            //            NSLog(@"进行收藏的接口----%@", url);
            [DataTool getCollectWithStr:url parameters:nil success:^(id responseObject) {
                
                NSLog(@"收藏返回的数据%@", responseObject);
                [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
            } failure:^(NSError * error) {
                
                NSLog(@"收藏的错误信息--%@", error);
            }];
            
        }
        _bottomView.collectionBtn.selected = !_bottomView.collectionBtn.selected;
    } else  // 如果没有登录
    {
        [self addAlertView];
    }
    
}

#pragma mark --- 收藏或取消收藏
- (void)collectOrCancelCollect{
    NSString * url = [CollectionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", _iD]];
    //            NSLog(@"进行收藏的接口----%@", url);
    [DataTool getCollectWithStr:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"收藏返回的数据%@", responseObject);
    } failure:^(NSError * error) {
        
        NSLog(@"收藏的错误信息--%@", error);
    }];
}

#pragma mark ---分享
- (void)shareAction
{
    
    // 暂停视频
//    [_playerView pause];
    
    [SVProgressHUD showErrorWithStatus:@"该功能暂未开放"];
    
//    // 分享需要图片、标题、描述、视频链接
//    NSString *st = _picUrl;
//    NSURL *url = [NSURL URLWithString:st];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *img = [UIImage imageWithData:data];
//    
//    // 友盟分享代码，复制、粘贴
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55556bc8e0f55a56230001d8"
//                                      shareText:[NSString stringWithFormat:@"%@ %@",_title,_description]
//                                     shareImage:img
//                                shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,@"CustomPlatform"]
//                                       delegate:self]; // 分享到朋友圈、微信好友、QQ空间、QQ好友
//    
//    // 下面的三段代码是什么意思？ 解释：加上下面的几句话才能将网页内容分享成功
//    // 分享到各个平台的内容  如果没有下面的代码就会跳到友盟首页（自己设置的URL）
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = _wapurl;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _wapurl;
//    [UMSocialData defaultData].extConfig.qqData.url = _wapurl;
//    [UMSocialData defaultData].extConfig.qzoneData.url = _wapurl;
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:_wapurl];
}

#pragma mark --- CommentViewDelegate
- (void)commnetView:(CommentView *)commentView sendMessage:(NSString *)message
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if (cookieName || wxData) {
        NSLog(@"已经登录。。。进行发表");
        /*
         http://10.0.0.14:8080/app/add_comment
         发送：id（被评论的id）,types(0:评论 1：回复),type(模块),content
         */
        NSMutableDictionary * CommentDic = [NSMutableDictionary dictionary];
        //        CommentDic[@"id"] = self.newsModel.iD;
        CommentDic[@"id"] = _iD;
        CommentDic[@"types"] = @"0";    // 0:评论   1:回复
        CommentDic[@"type"] = @"11";    // 2:资讯   4:图集   11:类型
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
    }else{  // 如果没有登录
        NSLog(@"发表时发现没有登录...");
        // 添加登录提示框
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
    BackgroundView * alertBackView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
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
    // 移除评论框
    [self removeFromSuperviewAction];
    // 将发表的内容进行保存
    _sendContent = _commentView.textView.text;
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNav animated:YES completion:nil];
}


#pragma mark --- 查看summary
- (void)checkSummary:(UIButton * )btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.openPic.image = [UIImage imageNamed:@"shouqi"];
        _summaryLbl.text = _videoModel.summary;
//        _summaryLbl.text = @"我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人我是众人＝＝";
        [self setSummaryFrame];
    } else{
        self.openPic.image = [UIImage imageNamed:@"zhankai"];
        _summaryLbl.text = _summaryStr;
        [self setSummaryFrame];
    }
}
#pragma mark --- 改变summary的frame
- (void)setSummaryFrame{
    CGFloat summaryX = Margin30 * IPHONE6_W_SCALE;
    CGFloat summaryY = CGRectGetMaxY(_descriptionLbl.frame) + Margin24 * IPHONE6_H_SCALE;
#warning 代码有问题，不能居中
    CGFloat summaryW = WIDTH -  2 * summaryX + 15/2*IPHONE6_W_SCALE;
    
    NSMutableDictionary * summaryDic = [NSMutableDictionary dictionary];
    summaryDic[NSFontAttributeName] = Font12;
    CGRect summaryRect = [_summaryLbl.text boundingRectWithSize:CGSizeMake(summaryW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:summaryDic context:nil];
    _summaryLbl.frame = (CGRect){{summaryX, summaryY}, summaryRect.size};
    
    CGFloat separateX = 0;
    CGFloat separateY = CGRectGetMaxY(_summaryLbl.frame) + 38 / 2 * IPHONE6_H_SCALE;
    CGFloat separateW = WIDTH;
    CGFloat separateH = Margin40 * IPHONE6_H_SCALE;
    _separateView.frame = CGRectMake(separateX, separateY, separateW, separateH);
    
    CGFloat associateY = CGRectGetMaxY(_separateView.frame);
    _associateView.frame = CGRectMake(0, associateY, WIDTH, Margin60 * IPHONE6_H_SCALE);
    
    CGFloat tableViewY = CGRectGetMaxY(_associateView.frame);
    self.tableView.frame = CGRectMake(0, tableViewY, WIDTH, HEIGHT - tableViewY - Margin92 * IPHONE6_H_SCALE);
}

#pragma mark --- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"数据源个数%lu", self.dataSource.count);
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationCell * cell = [InformationCell cellWithTableView:tableView];
    cell.associateModel = self.dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 播放相关视频
    TCPlayItem *item = [[TCPlayItem alloc] init];
    // 视频类型
    item.type = @"";
    // 播放视频的地址
    AssociatedModel * associateModel = self.dataSource[indexPath.row];
    item.url = associateModel.videourl;
    
    // 视频播放
    [_playerView play:item];
    
    //  重新获取网络上的数据
    [self getVideoDataWithURL:associateModel.url];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Margin196 * IPHONE6_H_SCALE;
}


#pragma mark --- 展开视频列表
- (void)openAlbum:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        _openImage.image = [UIImage imageNamed:@"shouqi"];
        CGFloat popW = WIDTH;
        CGFloat popX = 0;
        CGFloat popY = CGRectGetMaxY(_blackView.frame);
        CGFloat popH = HEIGHT - popY;
        // 弹出菜单  此方法是有返回值的
        BackViewOfTable * menu = [BackViewOfTable showWithRect:CGRectMake(popX, popY, popW, popH)];
        // 设置菜单的内容视图
        self.albumVC.dataSource = [NSMutableArray arrayWithArray:_videoModel.album];
        menu.contenView = self.albumVC.view;
        
        menu.backgroundColor = [UIColor colorWithRed:27 / 255.0 green:27 / 255.0 blue:27 / 255.0 alpha:1];
    } else{
        _openImage.image = [UIImage imageNamed:@"zhankai"];
        [BackViewOfTable hide];
    }
}
// 清除缓存按钮
- (void)clear
{
    [TCPlayerView clearAllPlayCache];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缓存已清除" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}
#pragma mark --- 播放视频
- (void)playVideo
{
    NSLog(@"播放视频");
    TCPlayItem *item = [[TCPlayItem alloc] init];
    // 视频类型
    item.type = @"";
    // 播放视频的地址
//    NSLog(@"视频播放地址－－－－%@", _videoModel.videourl);
    item.url = _videoModel.videourl;
    // 视频播放
    [_playerView play:item];
    
}


#pragma mark --- 点击按钮返回
- (void)returnBack{
    NSLog(@"单击返回按钮...");
    if ([_playerView isFullScreen]) {
        NSLog(@"此时全屏...");
        [_playerView changeToFullScreen:NO];
        
    }else{
       [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark --- AlbumViewControllerDelegate
// 第几视频列表中的某个视频触发的事件
- (void)sendVideoUrl:(NSString *)videoUrl andIndex:(NSInteger)index andVideoID:(NSString *)iD andURL:(NSString *)url andAblumModel:(AlbumModel *)albumModel{
    // 播放链接
    _videoModel.videourl = videoUrl;
    // 1／12
    _numLbl.text = [NSString stringWithFormat:@"%lu/%lu", index+1, _videoModel.album.count];
    [self playVideo];
    
    // 分享需要的东西
    
    // 获取新的数据
    [self getVideoDataWithURL:url];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
