//
//  DetailWebViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/3.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "DetailWebViewController.h"

#import "UIImageView+WebCache.h"

// 数据层，获取网络上的数据
#import "DataTool.h"
// 模型
#import "WebDetailModel.h"
// 活动指示器
#import "SVProgressHUD.h"

// 底部评论框
#import "BottomView.h"
// 弹出的评论视图
#import "CommentView.h"
// 评论详情页
#import "CommentsViewController.h"
// 灰色的背景图
#import "BackgroundView.h"
// 自定义的AlertView
#import "LSAlertView.h"
// 登录控制器
#import "LoginViewController.h"
// 数据库
#import "DataBase.h"
//
#import "UMSocial.h"
#import "NewsListModel.h"

#import "UIBarButtonItem+Item.h"
#import "AppDelegate.h"
@interface DetailWebViewController ()<BottomViewDelegate, CommentViewDelegate, LSAlertViewDeleagte, UMSocialUIDelegate>

{
    // 发表的内容
    NSString * _sendContent;
}

/**
 *  文章类型
 */
@property (nonatomic, copy) NSString * type;
/**
 *  网页链接
 */
@property (nonatomic, copy) NSString * wapurl;
/**
 *  网页模型
 */
@property (nonatomic, strong) WebDetailModel * model;

/**
 *  底部的控件
 */
@property (nonatomic, strong) BottomView * bottomView;
/**
 *  评论视图
 */
@property (nonatomic, strong) CommentView * commentView;
/**
 *  网页视图
 */
@property (nonatomic, strong) UIWebView * webView;
/**
 *  灰色的背景图
 */
@property (nonatomic, strong) UIView * backView;
/**
 *  出现alertView时的灰色背景图
 */
@property (nonatomic, strong) UIView * alertBackView;
/**
 *  提示框
 */
@property (nonatomic, strong) LSAlertView * alertView;
@property (nonatomic, strong) UIButton * leftBtn;

@end

@implementation DetailWebViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
        
    // 每次进来的时候都要检测是否登录
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    if (cookieName && _sendContent) {  // 如果已经登录，并且有发表内容，则进行发表
        NSMutableDictionary * CommentDic = [NSMutableDictionary dictionary];
        //        CommentDic[@"id"] = self.newsModel.iD;
        CommentDic[@"id"] = _model.iD;
        CommentDic[@"types"] = @"0";    // 0:评论  1:回复
        CommentDic[@"type"] = _model.type;
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
    
    [_leftBtn removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"跳转到网页详情页的接口：%@", self.url);
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 请求数据
    [self getData];
    // 添加底部评论框
    [self addBottomView];
    // 设置导航栏
    [self setUpNavigationBar];
    // 添加评论视图
//    [self addCommentView];
    
    // 在分享中添加自定义按钮
    [self addCustomShareBtn];
    
    // 对键盘添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark --- 添加复制链接按钮
- (void)addCustomShareBtn
{
    UMSocialSnsPlatform *snsPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"CustomPlatform"];
    // 设置自定义分享按钮的名称
    snsPlatform.displayName = @"复制链接";
    // 设置自定义分享按钮的图标
    snsPlatform.bigImageName = @"fuzhilianjie";
    //    __weak typeof(self) weakSelf = self;
    // 监听自定义按钮的点击事件
    snsPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
        UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
        pastboad.string = _wapurl;
        NSLog(@"复制的链接：%@", _wapurl);
        [SVProgressHUD showSuccessWithStatus:@"复制链接成功"];
        
    };
    
    // 添加自定义平台
    [UMSocialConfig addSocialSnsPlatform:@[snsPlatform]];
    // 设置你要在分享面板中出现的平台
    [UMSocialConfig setSnsPlatformNames:@[UMShareToSina ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,@"CustomPlatform"]];
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
#pragma mark --- 设置导航栏内容
- (void)setUpNavigationBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    // 返回按钮, 如果不符合美工的要求就添加
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(15, 25/2, 10, 38 / 2);
    [btn setImage:[UIImage imageNamed:@"houtui"] forState:UIControlStateNormal];
//    [self.navigationController.navigationBar addSubview:btn];
    _leftBtn = btn;
//    self.navigationController.
}
#pragma mark --- 返回上一个视图控制器
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 添加底部评论框
- (void)addBottomView
{
    BottomView * bottomView = [[BottomView alloc] init];
    bottomView.delegate = self;
    CGFloat x = 0;
    CGFloat y = HEIGHT - Margin92 * IPHONE6_H_SCALE - 64;
    CGFloat w = WIDTH;
    CGFloat h = Margin92 * IPHONE6_H_SCALE;
    bottomView.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:bottomView];
    _bottomView = bottomView;
}

- (void)getData
{
    [SVProgressHUD show];
    [DataTool getDataInWebViewWithStr:self.url parameters:nil success:^(NSArray * array) {
        
        WebDetailModel * model = array[0];
        NSString * type = array[1];
        _model = model;
        
        _type = type;
        _wapurl = model.wapurl;
        // 设置数据
        [self setData];
        
        [SVProgressHUD dismiss];
        // 设置网页内容
        [self setUpView:_wapurl];
    } failure:^(NSError * error) {
        
        NSLog(@"错误信息：%@", error);
    }];
}

#pragma mark --- 设置数据
- (void)setData{
    
    // 设置评论数
    NSLog(@"---发表评论数---%@", _model.commentNumber);
    if ([_model.commentNumber integerValue] >= 100) {
        _bottomView.commentsLbl.text = @"99+";
    } else{
        _bottomView.commentsLbl.text = _model.commentNumber;
    }
    // 判断收藏按钮的状态
    
    NSLog(@"---收藏的状态---%@", _model.is_collection);
    if ([_model.is_collection isEqualToString:@"1"]) {
        _bottomView.collectionBtn.selected = YES;
    } else{
        _bottomView.collectionBtn.selected = NO;
    }
}

#pragma mark --- 请求网页
- (void)setUpView:(NSString *)url
{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - Margin92*IPHONE6_H_SCALE)];
    [self.view addSubview:webView];
    _webView = webView;
    
    NSURL * URL = [NSURL URLWithString:url];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    [webView loadRequest:request];
}

// 设置状态栏的颜色为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark --- CommentViewDelegate
- (void)commnetView:(CommentView *)commentView sendMessage:(NSString *)message
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSLog(@"---用户迷宫%@,", cookieName);
    if (cookieName) {
        NSLog(@"已经登录。。。进行发表");
        /*
         http://10.0.0.14:8080/app/add_comment
         发送：id（被评论的id）,types(0:评论 1：回复),type(模块),content
         */
        NSMutableDictionary * CommentDic = [NSMutableDictionary dictionary];
//        CommentDic[@"id"] = self.newsModel.iD;
        CommentDic[@"id"] = _model.iD;
        CommentDic[@"types"] = @"0";
        CommentDic[@"type"] = _type;
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
    }else{
        [self addAlertView];
    }
    
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


#pragma mark ---- BottomViewDelegate底部评论框定义的协议中的方法
/**
 *  写评论
 */
- (void)commentAction
{
    UIView * backView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
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
#pragma mark --- 灰色背景移出,评论视图移除
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
    CommentsViewController * commentsVC = [[CommentsViewController alloc] init];
    commentsVC.type = _type;
    commentsVC.iD = _model.iD;
    [self.navigationController pushViewController:commentsVC animated:YES];
}
/**
 *  收藏
 */
- (void)collectionAction
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = [defaults objectForKey:Cookie];
    
    if (userName) { // 如果已经登录
        if (!_bottomView.collectionBtn.selected) {  // 如果收藏按钮没有被选中
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"收藏成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:OK];
            [self presentViewController:alertController animated:YES completion:nil];
            
            // 进行收藏
            [self collectOrCancelCollect];
        } else{     // 如果收藏按钮被选中
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"已取消收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:OK];
            [self presentViewController:alertController animated:YES completion:nil];
            
            //  取消收藏
            NSString * url = [CollectionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", _model.iD]];
            //            NSLog(@"进行收藏的接口----%@", url);
            [DataTool getCollectWithStr:url parameters:nil success:^(id responseObject) {
                
                NSLog(@"收藏返回的数据%@", responseObject);
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
    NSString * url = [CollectionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", _model.iD]];
    //            NSLog(@"进行收藏的接口----%@", url);
    [DataTool getCollectWithStr:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"收藏返回的数据%@", responseObject);
    } failure:^(NSError * error) {
        
        NSLog(@"收藏的错误信息--%@", error);
    }];
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
/**
 *  分享
 */
- (void)shareAction
{
    NSString *st = _model.picname;
    NSURL *url = [NSURL URLWithString:st];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    
    // 友盟分享代码，复制、粘贴
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55556bc8e0f55a56230001d8"
                                      shareText:[NSString stringWithFormat:@"%@ %@",_model.title,_model.descriptioN]
                                     shareImage:img
                                shareToSnsNames:@[UMShareToSina ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,@"CustomPlatform"]
                                       delegate:self]; // 分享到朋友圈、微信好友、QQ空间、QQ好友
    
    // 下面的三段代码是什么意思？ 解释：加上下面的几句话才能将网页内容分享成功
    // 分享到各个平台的内容  如果没有下面的代码就会跳到友盟首页（自己设置的URL）
    [UMSocialData defaultData].extConfig.wechatSessionData.url = _wapurl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _wapurl;
    [UMSocialData defaultData].extConfig.qqData.url = _wapurl;
    [UMSocialData defaultData].extConfig.qzoneData.url = _wapurl;
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:_wapurl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
