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

#import "UIBarButtonItem+Item.h"
#import "AppDelegate.h"
@interface DetailWebViewController ()<BottomViewDelegate>
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
    NSLog(@"%@", self.url);
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
}

- (void)getData
{
    [SVProgressHUD show];
    [DataTool getDataInWebViewWithStr:self.url parameters:nil success:^(NSArray * array) {
        
        NSString * type = array[0];
        NSLog(@"---type---%@", type);
        WebDetailModel * model = array[1];
        
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
#pragma mark ---- BottomViewDelegate
/**
 *  写评论
 */
- (void)commentAction
{
    BackgroundView * backView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backView.backgroundColor = ColorBlack60;
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加到灰色的背景图
    [window addSubview:backView];
    // 添加评论视图
    CommentView * commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, Margin242 * IPHONE6_H_SCALE)];
    commentView.backgroundColor = Color239;
    [backView addSubview:commentView];
    _commentView = commentView;
    
    [_commentView.textView becomeFirstResponder];
}
/**
 *  查看评论
 */
- (void)lookCommentsAction
{
//    CommentsViewController * commentsVC = [[CommentsViewController alloc] init];
//    [self.navigationController pushViewController:commentsVC animated:YES];
}
/**
 *  收藏
 */
- (void)collectionAction
{
    _bottomView.collectionBtn.selected = !_bottomView.collectionBtn.selected;
//    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"收藏" message:<#(nullable NSString *)#> preferredStyle:<#(UIAlertControllerStyle)#>];
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
