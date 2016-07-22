//
//  MineController.m
//  dipai
//
//  Created by 梁森 on 16/4/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MineController.h"
// 我的收藏
#import "MyCollectionViewController.h"
// 我的帖子
#import "MyPostsViewController.h"
// 我收到的评论
#import "MyReceiveCommentsViewController.h"
// 登录界面
#import "LoginViewController.h"
// 设置页面
#import "SettingViewController.h"
// 账户页面
#import "AccountViewController.h"
// 粉丝列表和关注列表
#import "MorePokersVC.h"


#import "ClickView.h"

#import "DataTool.h"
// 自定义alertView
#import "LSAlertView.h"
#import "BackgroundView.h"

#import "Masonry.h"
// 用户模型
#import "UserModel.h"

#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
@interface MineController ()<LSAlertViewDeleagte, UIScrollViewDelegate>
{
    NSArray *_cookies;
    NSString * _name;
    UIView * _alertBackView;
    LSAlertView * _alertView;
    NSString * _binding;    //  绑定的标识1：未绑定手机 2：未绑定微信 0：都绑定
}
/**
 *  表格
 */
@property (nonatomic, strong) UITableView * tableView;
/**
 *  登录头像
 */
@property (nonatomic, strong) UIButton * iconBtn;

@property (nonatomic, strong) UILabel * loginLbl;
/**
 *  竖线
 */
@property (nonatomic, strong) UIView * line;
/**
 *  被关注标签
 */
@property (nonatomic, strong) UILabel * fansLbl;
/**
 *  被关注数标签
 */
@property (nonatomic, strong) UILabel * fansNum;
/**
 *  关注标签
 */
@property (nonatomic, strong) UILabel * attention;
/**
 *  关注数标签
 */
@property (nonatomic, strong) UILabel * attentionNum;
/**
 *  查看账户按钮
 */
@property (nonatomic, strong) UIButton * picBtn;
// 编辑标签
@property (nonatomic, strong) UILabel * editLbl;
// 编辑按钮
@property (nonatomic, strong) UIButton * editBtn;

/**
 *  用户模型
 */
@property (nonatomic, strong) UserModel * model;

@property (nonatomic, strong) ClickView * commentsView;
/**
 *  微信用户
 */
@property (nonatomic, strong) NSDictionary * wxData;

// 点击用户头像
@property (nonatomic, strong) UIView * picBackView;
@property (nonatomic, strong) UIScrollView * picSc;
@property (nonatomic, strong) UIImageView * image;

@end

@implementation MineController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // 每次出现的时候都要重新获取数据
    [self getData];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.title = @"";
    
    // 设置导航栏上按钮
    [self setUpNavigationBarItem];
    [self getData];
    
}

#pragma mark --- 获取数据
- (void)getData{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * name = [defaults objectForKey:Cookie];
    NSDictionary * dataDic = [defaults objectForKey:User];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    _wxData = wxData;
    NSLog(@"持久性存储:%@", dataDic);
    
    // 字典转模型
    UserModel * userModel = [UserModel objectWithKeyValues:dataDic];
    _name = name;
    if (name || wxData) {
        NSLog(@"已登录");
//        _loginLbl.text = userModel.username;
        [_loginLbl sizeToFit];
        _loginLbl.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
        _line.hidden = NO;
        _fansNum.hidden = NO;
        _fansLbl.hidden = NO;
        _attentionNum.hidden = NO;
        _attention.hidden = NO;
        _picBtn.hidden = NO;
        _iconBtn.hidden = YES;
        _fansNum.text = userModel.count_follow; // 关注数
        _attentionNum.text = userModel.count_followed;  // 粉丝数
        // 显示收到的评论数
        _commentsView.commentNum.hidden = YES;
        // 编辑个人信息按钮
        _editBtn.hidden = NO;
        _editLbl.hidden = NO;
        
        // 登录成功以后才能进行网络数据的请求
        // 获取网络上的数据
        // 获取个人中心的数据
        [DataTool getPersonDataWithStr:PersonURL parameters:nil success:^(id responseObject) {
            UserModel * model = [[UserModel alloc] init];
            model = responseObject;
            _model = responseObject;
            // 设置数据
            _binding = model.binding;
            _fansNum.text = model.follow;
            _attentionNum.text = model.row;
            _loginLbl.text = model.username;
//            NSLog(@"%@", model.face);
            
            if (model.face && model.face.length > 0) {
                NSURL * url = [NSURL URLWithString:model.face];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_picBtn setBackgroundImage:img forState:UIControlStateNormal];
                    });
                    
                });
            }else{
                [_picBtn setBackgroundImage:[UIImage imageNamed:@"touxiang_moren"] forState:UIControlStateNormal];
            }
            
            if ([model.comment_num integerValue] > 99) {
                _commentsView.commentNum.hidden = NO;
                _commentsView.commentNum.text = @"...";
            }else{
                if ([model.comment_num integerValue] == 0) {
                    _commentsView.commentNum.hidden = YES;
                }else{
                    _commentsView.commentNum.hidden = NO;
                    _commentsView.commentNum.text = model.comment_num;
                }
                
            }
            
            
        } failure:^(NSError * error) {
            
            NSLog(@"获取个人中心出错:%@", error);
        }];
        
    } else{
        NSLog(@"没有登录");
        [SVProgressHUD dismiss];
        _line.hidden = YES;
        _fansNum.hidden = YES;
        _fansLbl.hidden = YES;
        _attentionNum.hidden = YES;
        _attention.hidden = YES;
        _loginLbl.text = @"点击登录";
        _loginLbl.textColor = Color178;
        _picBtn.hidden = YES;
        _iconBtn.hidden = NO;
        //
        _commentsView.commentNum.hidden = YES;
        // 编辑个人信息按钮
        _editBtn.hidden = YES;
        _editLbl.hidden = YES;
    }
}

#pragma mark ---设置导航栏上按钮
- (void)setUpNavigationBarItem{
    
    self.navigationController.navigationBarHidden = YES;
    
    [self createUI];
}
#pragma mark ---创建界面
- (void)createUI{
    CGFloat headerX = 0;
    CGFloat headerY = 0;
    CGFloat headerW = WIDTH;
    CGFloat headerH = 235 * IPHONE6_H_SCALE;
    UIImageView * headerView = [[UIImageView alloc] initWithFrame:CGRectMake(headerX, headerY, headerW, headerH)];
    headerView.image = [UIImage imageNamed:@"weidenglu_beijing"];
    
    // 设置按钮
    UIButton * settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnX = WIDTH - 15 - 21;
    CGFloat btnY = (40 + 23) / 2;
    CGFloat btnW = 21 * IPHONE6_W_SCALE;
    CGFloat btnH = 21 * IPHONE6_W_SCALE;
    settingBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [settingBtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
    headerView.userInteractionEnabled = YES;
    [headerView addSubview:settingBtn];
    
    // 登录头像
    UIButton * iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconBtn setImage:[UIImage imageNamed:@"touxiang_moren"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:iconBtn];
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(headerView.mas_top).offset(64 * IPHONE6_H_SCALE);
        make.width.equalTo(@(78 * IPHONE6_W_SCALE));
        make.height.equalTo(@(78 * IPHONE6_W_SCALE));
    }];
    _iconBtn = iconBtn;
    // 登录后的头像
    UIButton * picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:picBtn];
    [picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(headerView.mas_top).offset(64 * IPHONE6_H_SCALE);
        make.width.equalTo(@(78 * IPHONE6_W_SCALE));
        make.height.equalTo(@(78 * IPHONE6_W_SCALE));
    }];
    picBtn.layer.masksToBounds = YES;
    picBtn.layer.cornerRadius =  39 * IPHONE6_W_SCALE;
    picBtn.layer.borderWidth = 2 * IPHONE6_W_SCALE;
    picBtn.layer.borderColor = [[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.5] CGColor];
//    picBtn.backgroundColor = [UIColor lightGrayColor];
    [picBtn addTarget:self action:@selector(showBigFace) forControlEvents:UIControlEventTouchUpInside];
    _picBtn = picBtn;
    
    [self.view addSubview:headerView];
    // 登录状态的label
    UILabel * loginLbl = [[UILabel alloc] init];
//    loginLbl.backgroundColor = [UIColor redColor];
    [headerView addSubview:loginLbl];
    loginLbl.textColor = Color178;
    loginLbl.font = [UIFont systemFontOfSize:17];
    loginLbl.textAlignment = NSTextAlignmentCenter;
    [loginLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(iconBtn.mas_bottom).offset(5*IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(18));
    }];
    loginLbl.text = @"点击登录";
    //    [loginLbl sizeToFit];
    _loginLbl = loginLbl;
    
    // 竖线
    UIView * line = [[UIView alloc] init];
    [headerView addSubview:line];
    line.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(loginLbl.mas_bottom).offset(25 * 0.5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(0.5));
        make.height.equalTo(@(14*IPHONE6_H_SCALE));
    }];
    _line = line;
    
    // 被关注
    UILabel * fansLbl = [[UILabel alloc] init];
    [headerView addSubview:fansLbl];
    fansLbl.text = @"被关注";
    fansLbl.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
    fansLbl.font = Font13;
    [fansLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(14 * IPHONE6_W_SCALE);
        make.top.equalTo(loginLbl.mas_bottom).offset(23*0.5*IPHONE6_H_SCALE);
        make.width.equalTo(@(40*IPHONE6_W_SCALE));
        make.height.equalTo(@(13*IPHONE6_W_SCALE));
    }];
    [fansLbl sizeToFit];
    _fansLbl = fansLbl;
    // 被关注数
    UILabel * fansNum = [[UILabel alloc] init];
    [headerView addSubview:fansNum];
    fansNum.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
    fansNum.text = @"22";
    fansNum.font = Font13;
    [fansNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fansLbl.mas_right).offset(9 * IPHONE6_W_SCALE);
        make.top.equalTo(fansLbl.mas_top);
        make.width.equalTo(@(40*IPHONE6_W_SCALE));
        make.height.equalTo(@(13*IPHONE6_W_SCALE));
    }];
    _fansNum = fansNum;
    
    UILabel * attention = [[UILabel alloc] init];
    attention.textAlignment = NSTextAlignmentRight;
    attention.font = Font13;
    //    attention.backgroundColor = [UIColor redColor];
    attention.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
    attention.text = @"关注";
    [headerView addSubview:attention];
    _attention = attention;
    
    // 关注数
    UILabel * attentionNum = [[UILabel alloc] init];
    //    attentionNum.backgroundColor = [UIColor redColor];
    attentionNum.font = Font13;
    attentionNum.text = @"22";
    attentionNum.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
    [headerView addSubview:attentionNum];
    _attentionNum = attentionNum;
    [attentionNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(line.mas_left).offset(-28 / 2 * IPHONE6_W_SCALE);
        make.top.equalTo(loginLbl.mas_bottom).offset(26 / 2 * IPHONE6_H_SCALE);
        make.left.equalTo(attention.mas_right).offset(18 / 2 * IPHONE6_W_SCALE);
        make.height.equalTo(@(26 / 2 * IPHONE6_H_SCALE));
    }];
    // 关注
    [attention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40 * IPHONE6_W_SCALE));
        make.height.equalTo(@(26 / 2 * IPHONE6_H_SCALE));
        make.top.equalTo(attentionNum.mas_top);
    }];
    
    // 关注按钮和被关注按钮
    UIButton * attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:attentionBtn];
    [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(attention.mas_left).offset(-5);
        make.top.equalTo(attentionBtn.mas_top).offset(-5);
        make.right.equalTo(attentionNum.mas_right).offset(5);
        make.bottom.equalTo(attention.mas_bottom).offset(5);
    }];
    [attentionBtn addTarget:self action:@selector(showAtttionNum) forControlEvents:UIControlEventTouchUpInside];
    UIButton * fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:fansBtn];
    [fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fansLbl.mas_left).offset(-5);
        make.top.equalTo(fansLbl.mas_top).offset(-5);
        make.right.equalTo(fansNum.mas_right).offset(5);
        make.bottom.equalTo(fansLbl.mas_bottom).offset(5);
    }];
    [fansBtn addTarget:self action:@selector(showFans) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 编辑个人资料按钮
    UILabel * editLbl = [[UILabel alloc] init];
//    editBtn.backgroundColor = [UIColor redColor];
    [headerView addSubview:editLbl];
    editLbl.textColor = [UIColor whiteColor];
    editLbl.text = @"编辑个人资料";
    editLbl.textAlignment = NSTextAlignmentCenter;
    editLbl.font = Font12;
    editLbl.textColor = [UIColor whiteColor];
    editLbl.layer.borderColor = [[UIColor whiteColor] CGColor];
    editLbl.layer.borderWidth = 1;
    [editLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(line.mas_bottom).offset(9 * IPHONE6_H_SCALE);
        make.width.equalTo(@(110 * IPHONE6_W_SCALE));
        make.height.equalTo(@(21 * IPHONE6_W_SCALE));
    }];
    editLbl.layer.masksToBounds = YES;
    editLbl.layer.cornerRadius = 10 * IPHONE6_W_SCALE;
    _editLbl = editLbl;
    
    UIButton * editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(editLbl.mas_left).offset(-5);
        make.top.equalTo(editLbl.mas_top).offset(-5);
        make.right.equalTo(editLbl.mas_right).offset(5);
        make.bottom.equalTo(editLbl.mas_bottom).offset(5);
    }];
    [editBtn addTarget:self action:@selector(CheckAccount) forControlEvents:UIControlEventTouchUpInside];
    _editBtn = editBtn;
    
    
    // 分隔条
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    CGFloat separateX = 0;
//    CGFloat separateY = CGRectGetMaxY(headerView.frame);
    CGFloat separateY = 235 * IPHONE6_H_SCALE;
    CGFloat separateW = WIDTH;
    CGFloat sepatateH = 40 / 2 * IPHONE6_H_SCALE;
    separateView.frame = CGRectMake(separateX, separateY, separateW, sepatateH);
    [self.view addSubview:separateView];
    
    // 收藏
    ClickView * collectionView = [[ClickView alloc] init];
    collectionView.commentNum.hidden = YES;
    // 设置图片
    collectionView.picName = @"shoucang_moren";
    collectionView.message = @"我的收藏";
    [collectionView.btn addTarget:self action:@selector(turePageToCollection) forControlEvents:UIControlEventTouchUpInside];
    collectionView.btn.tag = 1;
    CGFloat collectX = 0;
    CGFloat collectY = CGRectGetMaxY(separateView.frame);
    CGFloat collectW = WIDTH;
    CGFloat collectH = 98 / 2 * IPHONE6_H_SCALE;
    collectionView.frame = CGRectMake(collectX, collectY, collectW, collectH);
    [self.view addSubview:collectionView];
    
    
//    // 帖子
    ClickView * postView = [[ClickView alloc] init];
    postView.commentNum.hidden = YES;
    postView.picName = @"wodetiezi";
    postView.message = @"我的帖子";
    [postView.btn addTarget:self action:@selector(turePageToPosts) forControlEvents:UIControlEventTouchUpInside];
    CGFloat postX = collectX;
    CGFloat postY = CGRectGetMaxY(collectionView.frame);
    CGFloat postW = collectW;
    CGFloat postH = collectH;
    postView.frame = CGRectMake(postX, postY, postW, postH);
    [self.view addSubview:postView];
    
    
    // 收到的评论
    ClickView * commentsView = [[ClickView alloc] init];
    commentsView.commentNum.text = @"";
    commentsView.commentNum.hidden = YES;
    commentsView.picName = @"woshoudaodepinglun";
    commentsView.message = @"我收到的评论";
    [commentsView.btn addTarget:self action:@selector(turePageToComments) forControlEvents:UIControlEventTouchUpInside];
    CGFloat commentsX = postX;
    CGFloat commentsY = CGRectGetMaxY(postView.frame);
    CGFloat commentsW = postW;
    CGFloat commentsH = postH;
    commentsView.frame = CGRectMake(commentsX, commentsY, commentsW, commentsH);
    [self.view addSubview:commentsView];
    _commentsView = commentsView;
}

#pragma mark --- 显示大头像
- (void)showBigFace{
    NSLog(@"显示大头像。。。");
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
//    [image sd_setImageWithURL:[NSURL URLWithString:model.imgs[@"pimg"]] placeholderImage:[UIImage imageNamed:@"123"]];
    [image sd_setImageWithURL:[NSURL URLWithString:_model.face] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
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

#pragma mark --展示关注列表
- (void)showAtttionNum{
    NSLog(@"展示关注列表");
    NSString * userid = _model.userid;
    MorePokersVC * attentionVC = [[MorePokersVC alloc] init];
    attentionVC.wapurl = [AttentionsURL stringByAppendingString:userid];
    
    NSLog(@"%@", attentionVC.wapurl);
    attentionVC.titleStr = @"关注";
    attentionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:attentionVC animated:YES];
}
#pragma mark --- 展示粉丝列表
- (void)showFans{
    NSLog(@"展示粉丝列表");
    NSString * userid = _model.userid;
    MorePokersVC * fansVC = [[MorePokersVC alloc] init];
    fansVC.wapurl = [FansURL stringByAppendingString:userid];
    fansVC.hidesBottomBarWhenPushed = YES;
    NSLog(@"%@", fansVC.wapurl);
    fansVC.titleStr = @"被关注";
    [self.navigationController pushViewController:fansVC animated:YES];
}

#pragma mark --- 查看账户
- (void)CheckAccount{
    AccountViewController * accountVC = [[AccountViewController alloc] init];
    accountVC.bindign = _binding;
    accountVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:accountVC animated:YES];
}

#pragma mark --- 按钮的点击事件
// 跳转到收藏页
- (void)turePageToCollection{
    if (_name || _wxData) {
        MyCollectionViewController * myCollectionVC = [[MyCollectionViewController alloc] init];
        myCollectionVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:myCollectionVC animated:YES];
    }else{
        [self addLSAlertView];
    }
    
}
// 跳转到帖子页
- (void)turePageToPosts{
    if (_name || _wxData) {
        MyPostsViewController * myPostsVC = [[MyPostsViewController alloc] init];
        myPostsVC.hidesBottomBarWhenPushed = YES;
        myPostsVC.userModel = _model;
        [self.navigationController pushViewController:myPostsVC animated:YES];
    }else{
        [self addLSAlertView];
    }
    
}
// 跳转到收到的评论页
- (void)turePageToComments{
    if (_name || _wxData) {
        MyReceiveCommentsViewController * myReceiveCommentsVC = [[MyReceiveCommentsViewController alloc] init];
        myReceiveCommentsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myReceiveCommentsVC animated:YES];
    }else{
        [self addLSAlertView];
    }
    
}

- (void)addLSAlertView{
    LSAlertView * alertView = [[LSAlertView alloc] init];
    alertView.delegate = self;
    CGFloat x = Margin105 * IPHONE6_W_SCALE;
    CGFloat y = Margin574 * IPHONE6_H_SCALE;
    CGFloat w = Margin540 * IPHONE6_W_SCALE;
    CGFloat h = Margin208 * IPHONE6_H_SCALE;
    alertView.frame = CGRectMake(x, y, w, h);
    UIView * alertBackView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    alertBackView.backgroundColor = ColorBlack30;
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加到灰色的背景图
    [window addSubview:alertBackView];
    [window addSubview:alertView];
    
    _alertBackView = alertBackView;
    _alertView = alertView;
}

#pragma mark ---- LSAlertViewDeleagte
- (void)lsAlertView:(LSAlertView *)alertView cancel:(NSString * )cancel{
    [self removeAlerView];
}
- (void)lsAlertView:(LSAlertView *)alertView sure:(NSString *)sure{
    [self removeAlerView];
    [self loginAction];
}

- (void)removeAlerView
{
    // 移除提示框的背景图
    [_alertBackView removeFromSuperview];
    // 移除提示框
    [_alertView removeFromSuperview];
}

#pragma mark --- 跳转到设置页面 
- (void)settings
{
    SettingViewController * settingVC = [[SettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark --- 登录事件
- (void)loginAction{
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
