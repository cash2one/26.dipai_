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

#import "NewsListModel.h"

#import "UIBarButtonItem+Item.h"
#import "AppDelegate.h"
@interface DetailWebViewController ()<BottomViewDelegate, CommentViewDelegate, LSAlertViewDeleagte>
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
    
    // 对键盘添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
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
    CGFloat y = HEIGHT - Margin92 * IPHONE6_H_SCALE;
    CGFloat w = WIDTH;
    CGFloat h = Margin92 * IPHONE6_H_SCALE;
    bottomView.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:bottomView];
    _bottomView = bottomView;
    
    // 判断收藏按钮的状态
    NSArray * arr = [DataBase findTheTracks:_newsModel.iD];
    if (arr.count) {
        bottomView.collectionBtn.selected = YES;
    }
}

- (void)getData
{
    [SVProgressHUD show];
    [DataTool getDataInWebViewWithStr:self.url parameters:nil success:^(WebDetailModel * model) {
        
        _model = model;
        
        _wapurl = model.wapurl;
        if ([_model.commentNumber integerValue] >= 100) {
            _bottomView.commentsLbl.text = @"99+";
        }
        _bottomView.commentsLbl.text = _model.commentNumber;
        [SVProgressHUD dismiss];
        // 设置网页内容
        [self setUpView:_wapurl];
    } failure:^(NSError * error) {
        
        NSLog(@"错误信息：%@", error);
    }];
}
#pragma mark --- 请求网页
- (void)setUpView:(NSString *)url
{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - Margin92*IPHONE6_H_SCALE)];
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
    NSLog(@"显示提示框...");
    LSAlertView * alertView = [[LSAlertView alloc] init];
    alertView.delegate = self;
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 10;
    alertView.backgroundColor = [UIColor whiteColor];
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
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNav animated:YES completion:nil];
}


#pragma mark ---- BottomViewDelegate
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
#pragma mark --- 灰色背景移出
- (void)removeFromSuperviewAction
{
    // 灰色背景移除
    [_backView removeFromSuperview];
    [_commentView.textView resignFirstResponder];
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
    [self.navigationController pushViewController:commentsVC animated:YES];
}
/**
 *  收藏
 */
- (void)collectionAction
{
    if (!_bottomView.collectionBtn.selected) {  // 如果收藏按钮没有被选中
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"收藏成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:OK];
        [self presentViewController:alertController animated:YES completion:nil];
        // 将此模型存入到数据库中
        [DataBase saveLocation:_newsModel];
    } else{     // 如果收藏按钮被选中
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"已取消收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:OK];
        [self presentViewController:alertController animated:YES completion:nil];
        
        [DataBase deleteTreacks:_newsModel.iD];
    }
    
    _bottomView.collectionBtn.selected = !_bottomView.collectionBtn.selected;
    
    
    
}
/**
 *  分享
 */
- (void)shareAction
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
