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

// 普通人主页
#import "AnyBodyVC.h"

// 数据库
#import "DataBase.h"
//
#import "UMSocial.h"
#import "NewsListModel.h"

#import "UIBarButtonItem+Item.h"
#import "AppDelegate.h"

#import "Masonry.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface DetailWebViewController ()<BottomViewDelegate, CommentViewDelegate, LSAlertViewDeleagte, UMSocialUIDelegate, UIWebViewDelegate, UIScrollViewDelegate>

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

/**
 *  装图集信息的数组
 */
@property (nonatomic, strong) NSMutableArray * picsArr;
/**
 *  点击图片的下标
 */
@property (nonatomic, strong) JSValue * picIndex;
//  滚动视图的背景图
@property (nonatomic, strong) UIView * scBack;

@property (nonatomic, strong) UIScrollView * scrollView;
// 显示图片下标的标签
@property (nonatomic, strong) UILabel * pageLbl;

@property (nonatomic,assign) int currentPage;
//scroll里面的图片view 数组
@property (nonatomic,strong) NSMutableArray *arr_viewImg;
//scroller里面的scroller   数组
@property (nonatomic,strong) NSMutableArray *arr_scro;
//未缩放的 view的Img 的frame 的数组
@property (nonatomic,strong) NSMutableArray *arr_imgF;
// 展示的图片
@property (nonatomic, strong) UIImageView *img;
// 底部视图
@property (nonatomic, strong) UIView * botomView;
// 图片标题
@property (nonatomic, strong) UILabel * titleLbl;
// 图片描述
@property (nonatomic, strong) UILabel * contentLbl;
@end

@implementation DetailWebViewController
- (NSMutableArray *) arr_imgF{
    if (!_arr_imgF) {
        _arr_imgF = [NSMutableArray array];
    }
    return _arr_imgF;
}
- (NSMutableArray *) arr_scro{
    if (!_arr_scro) {
        _arr_scro = [NSMutableArray array];
    }
    return _arr_scro;
}
- (NSMutableArray *)arr_viewImg{
    if (!_arr_viewImg) {
        _arr_viewImg = [NSMutableArray array];
    }
    return _arr_viewImg;
}
- (int)currentPage{
    if (!_currentPage) {
        _currentPage = 1;
    }
    return _currentPage;
}
- (NSMutableArray *)picsArr{
    if (_picsArr == nil) {
        _picsArr = [NSMutableArray array];
    }
    return _picsArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    // 每次进来的时候都要检测是否登录
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if ((cookieName || wxData) && _sendContent) {  // 如果已经登录，并且有发表内容，则进行发表
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
    
    [_leftBtn removeFromSuperview];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        pastboad.string = [_wapurl stringByAppendingString:@"?isshare=1"];
        NSLog(@"复制的链接：%@", [_wapurl stringByAppendingString:@"?isshare=1"]);
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
    
//    NSLog(@"%@", _commentView);
    if (frame.origin.y == HEIGHT) {   // 当键盘没有弹出的时候
        
        NSLog(@"键盘隐藏");
//        NSLog(@"%@", _commentView);
        [UIView animateWithDuration:duration animations:^{
            
            _commentView.transform = CGAffineTransformIdentity;
        }];
        
       
    } else
    {
        NSLog(@"键盘弹出");
//        NSLog(@"%@", _commentView);
        // 键盘弹出
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
    [DataTool getDataInWebViewWithStr:self.url parameters:nil success:^(NSArray * array) {
        
        WebDetailModel * model = array[0];
        NSString * type = array[1];
        _model = model;
        
        _type = type;
        _wapurl = model.wapurl;
        // 设置数据
        [self setData];
        
        // 设置网页内容
        [self setUpView:_wapurl];
    } failure:^(NSError * error) {
        
        NSLog(@"错误信息：%@", error);
    }];
}

#pragma mark --- 设置数据
- (void)setData{
    
    // 设置评论数
//    NSLog(@"---发表评论数---%@", _model.commentNumber);
    
    NSInteger commentNum = _model.commentNumber.integerValue;
//    NSLog(@"%lu", commentNum);
    if (commentNum > 0) {
        
        _bottomView.commentsLbl.hidden = NO;
        if (commentNum >= 100) {
             _bottomView.commentsLbl.text = @"99+";
        }else{
            
             _bottomView.commentsLbl.text = _model.commentNumber;
        }
    }else{
    
        _bottomView.commentsLbl.hidden = YES;
    }
//    if ([_model.commentNumber integerValue] >= 100) {
//        _botomView.hidden = NO;
//        _bottomView.commentsLbl.text = @"99+";
//    } else{
//        if ([_model.commentNumber integerValue] == 0) {
//            _bottomView.commentsLbl.hidden = YES;
//        }else{
//            _botomView.hidden = NO;
//            _bottomView.commentsLbl.text = _model.commentNumber;
//        }
//        
//    }
    // 判断收藏按钮的状态
    
//    NSLog(@"---收藏的状态---%@", _model.is_collection);
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
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    [webView setScalesPageToFit:YES];
    _webView = webView;
    
    NSURL * URL = [NSURL URLWithString:url];
//    NSURL * URL = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    [webView loadRequest:request];
    
    JSContext *context = [_webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"image_add_i"] = ^() { // 通过block回调获得h5传来的数据
    
        NSArray *args = [JSContext currentArguments];
//        NSLog(@"%@", args);
        // 数组中装数组
        [self.picsArr addObject:args];
//        NSLog(@"%@", self.picsArr);
        
//        for (JSValue *jsVal in args) {
//            NSLog(@"－－%@", jsVal);
//        }
//        JSValue *this = [JSContext currentThis];
//        NSLog(@"this: %@",this);
    };
    
    context[@"image_show_i"] = ^() {
        NSArray *args = [JSContext currentArguments];
//        NSLog(@"%@", args);
        for (JSValue *jsVal in args) {
//            NSLog(@"%@", jsVal);
            _picIndex = jsVal;
            // 展示图片
            [self showBigPic];
        }
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
    };
}


- (void)showBigPic{
    NSLog(@"展示图片..");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        
        UIView * scBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        scBack.backgroundColor = [UIColor blackColor];
        _scBack = scBack;
        // 装滚动视图的滚动视图
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        scrollView.pagingEnabled = YES;
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [_scBack addSubview:scrollView];
        _scrollView = scrollView;
        
        NSString * indexStr = _picIndex.toString;
        
        int index = [indexStr intValue];
        
        NSArray * arr = [self.picsArr objectAtIndex:index];
        JSValue * title = [arr objectAtIndex:1];
        NSString * titleStr = title.toString;
//        NSString * titleStr = @"jaksjfa;sjdfldjlk";
        JSValue * content = [arr objectAtIndex:2];
        NSString * contentStr = content.toString;
        
        index = index + 1;
        _pageLbl = [[UILabel alloc] init];
        _pageLbl.text = [NSString stringWithFormat:@"%d/%lu" ,index, self.picsArr.count];
        self.currentPage = index;
        _pageLbl.textAlignment = NSTextAlignmentCenter;
        _pageLbl.textColor = [UIColor whiteColor];
        _pageLbl.backgroundColor = [UIColor blackColor];
        
        // 图片标题
        UILabel * titleLbl = [[UILabel alloc] init];
//        titleLbl.backgroundColor = [UIColor greenColor];
        titleLbl.text = titleStr;
        titleLbl.textColor = [UIColor whiteColor];
        titleLbl.font = Font14;
        _titleLbl = titleLbl;
        CGFloat titleX = 15 * IPHONE6_W_SCALE;
        CGFloat titleY = 13 * IPHONE6_H_SCALE;
        CGFloat titleW = WIDTH - 2 * titleX;
        NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
        titleDic[NSFontAttributeName] = Font14;
        // 图片描述
        UILabel * contentLbl = [[UILabel alloc] init];
        contentLbl.text = contentStr;
        contentLbl.textColor = [UIColor whiteColor];
        contentLbl.font = Font12;
        _contentLbl = contentLbl;
        
        // 下载按钮
        UIImageView * downV = [[UIImageView alloc] init];
        UIButton * downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 底部视图
        UIView * botomView = [[UIView alloc] init];
        botomView.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.6];
        [_scrollView addSubview:botomView];
        _botomView = botomView;
        botomView.frame = CGRectMake(0, HEIGHT - 164 * IPHONE6_H_SCALE, WIDTH, 164 * IPHONE6_H_SCALE);
        
        
        for ( int i = 0 ; i < self.picsArr.count ; i++ ) {
            
            UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(WIDTH * i, 64, WIDTH , HEIGHT)];
            sc.backgroundColor = [UIColor blackColor];
            sc.maximumZoomScale = 2.0;
            sc.minimumZoomScale = 1.0;
            sc.decelerationRate = 0.2;
            sc.delegate = self;
            sc.tag = 1 + i;
            [_scrollView addSubview:sc];

            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
            NSArray * arr = [self.picsArr objectAtIndex:i];
            JSValue * js = [arr objectAtIndex:0];
            NSString * str = js.toString;
            
            [img sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"123"]];
            
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPics:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [sc addGestureRecognizer:tap];
            
            UITapGestureRecognizer * twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makePicBigger:)];
            twoTap.numberOfTapsRequired = 2;
            img.userInteractionEnabled = YES;
            [img addGestureRecognizer:twoTap];
            
            img.contentMode = UIViewContentModeScaleAspectFit;
            img.tag = 1000 + i;
            img.userInteractionEnabled = YES;
            [sc addSubview:img];
            _img = img;
            sc.contentSize = CGSizeMake( WIDTH , 0);
            //   双击没有识别到的时候识别单击手势
            [tap requireGestureRecognizerToFail:twoTap];
            
            [self.arr_viewImg addObject:img];
            [self.arr_scro addObject:sc];
            UIImageView *viewimg = [[UIImageView alloc]initWithFrame:img.frame];
            [self.arr_imgF addObject:viewimg];
            
        }
        _scrollView.contentSize = CGSizeMake( WIDTH * self.picsArr.count , 0);
        
        _scrollView.contentOffset = CGPointMake(WIDTH * (index-1), 0);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CGRect titleRect = [titleStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
                _titleLbl.frame = (CGRect){{titleX, titleY},titleRect.size};
                
                CGFloat contentX = titleX;
                CGFloat contentY = CGRectGetMaxY(_titleLbl.frame) + 14 * IPHONE6_H_SCALE;
                CGFloat contentW = WIDTH - 2 * contentX;
                NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
                contentDic[NSFontAttributeName] = Font12;
                CGRect contentRect = [contentStr boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil];
                _contentLbl.frame = (CGRect){{contentX, contentY}, contentRect.size};
                
                downV.image = [UIImage imageNamed:@"xiazai"];
                downV.userInteractionEnabled = YES;
                [_botomView addSubview:downV];
                [downV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(botomView.mas_right).offset(-20 * IPHONE6_W_SCALE);
                    make.bottom.equalTo(botomView.mas_bottom).offset(- 12 * IPHONE6_H_SCALE);
                    make.width.equalTo(@(23 * IPHONE6_W_SCALE));
                    make.height.equalTo(@(21 * IPHONE6_W_SCALE));
                }];
                [_botomView addSubview:downBtn];
                [downBtn addTarget:self action:@selector(downloadPic) forControlEvents:UIControlEventTouchUpInside];
                downBtn.backgroundColor = [UIColor clearColor];
                [downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(downV.mas_left).offset(-10);
                    make.top.equalTo(downV.mas_top).offset(-10);
                    make.right.equalTo(downV.mas_right).offset(10);
                    make.bottom.equalTo(downV.mas_bottom).offset(10);
                }];
                
                [window addSubview:_scBack];
                [window addSubview:_pageLbl];
                [window addSubview:_botomView];
                [_botomView addSubview:_titleLbl];
                [_botomView addSubview:_contentLbl];
                [_pageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_scrollView.mas_centerX);
                    make.top.equalTo(_scrollView.mas_top).offset(32);
                    make.width.equalTo(@(WIDTH));
                    make.height.equalTo(@(18 * IPHONE6_H_SCALE));
                }];
                if ([self.url rangeOfString:@"view/4"].location != NSNotFound) {    // 图集
                    
                    _titleLbl.hidden = NO;
                    _titleLbl.hidden = NO;
                    _botomView.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.6];
                   
                }else{
                    
                    _titleLbl.hidden = YES;
                    _contentLbl.hidden = YES;
                     _botomView.backgroundColor = [UIColor clearColor];
                }
                
            });
        
    });
}

- (void)downloadPic{
    int page = self.currentPage - 1;
    NSArray * arr = [self.picsArr objectAtIndex:page];
    JSValue * value = [arr objectAtIndex:0];
    NSString * str = value.toString;
//    NSLog(@"%@", str);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
    
    UIImage *img = [UIImage imageWithData:data];
    
    // 将图片存入到相册
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
// 保存到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
#pragma mark --- 双击放大图片
- (void)makePicBigger:(UIGestureRecognizer *)gesture{
    UIScrollView * sc = (UIScrollView *)[gesture.view superview];
    CGFloat zoomScale = sc.zoomScale;
    
    zoomScale = (zoomScale == 1.0) ? 3.0 : 1.0;
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[gesture locationInView:gesture.view]];
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
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"sc.tag:%lu", scrollView.tag);
    
//    if (scrollView.tag >0 == NO) {  // scrollView.tag = 0时
        NSInteger numOfPage = ABS(self.scrollView.contentOffset.x / scrollView.frame.size.width);
        
        if (numOfPage != self.currentPage-1) {
            
            UIScrollView *scro = [self.arr_scro objectAtIndex:self.currentPage-1];
            scro.contentSize = CGSizeMake( WIDTH , Height126 );
//            scro.zoomScale = 1;
        }
        self.currentPage = (int)(numOfPage + 1);
        _pageLbl.text = [NSString stringWithFormat:@"%d/%ld",_currentPage , self.picsArr.count];
    
    NSLog(@"currentPage:%d", self.currentPage);
        
        // 标题,标题内容在变，要不断地调用此方法
        NSArray * arr = [self.picsArr objectAtIndex:numOfPage];
        JSValue * title = [arr objectAtIndex:1];
        NSString * titleStr = title.toString;
        CGFloat titleX = 15 * IPHONE6_W_SCALE;
        CGFloat titleY = 13 * IPHONE6_H_SCALE;
        CGFloat titleW = WIDTH - 2 * titleX;
        NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
        titleDic[NSFontAttributeName] = Font14;
        CGRect titleRect = [titleStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
        _titleLbl.frame = (CGRect){{titleX, titleY},titleRect.size};
        _titleLbl.text = titleStr;
        // 图片描述
        NSArray * arr1 = [self.picsArr objectAtIndex:numOfPage];
        JSValue * content = [arr1 objectAtIndex:2];
        NSString * contentStr = content.toString;
        CGFloat contentX = titleX;
        CGFloat contentY = CGRectGetMaxY(_titleLbl.frame) + 14 * IPHONE6_H_SCALE;
        CGFloat contentW = WIDTH - 2 * contentX;
        NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
        contentDic[NSFontAttributeName] = Font12;
        CGRect contentRect = [contentStr boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil];
        _contentLbl.frame = (CGRect){{contentX, contentY}, contentRect.size};
        _contentLbl.text = contentStr;
//    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    UIImageView *imgView  = [self.arr_viewImg objectAtIndex:self.currentPage-1];
    
    if (imgView.frame.size.width > WIDTH  && imgView.frame.size.height > Height126) {
        
        scrollView.contentSize = CGSizeMake(imgView.frame.size.width, imgView.frame.size.height);
        
    }else if (imgView.frame.size.width > WIDTH && imgView.frame.size.height <= Height126 ){
        
        scrollView.contentSize = CGSizeMake(imgView.frame.size.width, Height126 );
        
    }else if (imgView.frame.size.width <= WIDTH && imgView.frame.size.height > Height126 ){
        
        scrollView.contentSize = CGSizeMake( WIDTH , imgView.frame.size.height);
    }else if (imgView.frame.size.width <= WIDTH && imgView.frame.size.height <= Height126 ){
        
        scrollView.contentSize = CGSizeMake( WIDTH , Height126 );
    }else{
        NSArray *arr1 = [scrollView subviews];
        
        UIScrollView *scro = [arr1 objectAtIndex:self.currentPage-1];
        scro.contentSize = CGSizeMake( WIDTH , Height126 );
    }
    imgView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    UIImageView *imgView  = [self.arr_viewImg objectAtIndex:self.currentPage-1];
    UIImageView *noscaView = [self.arr_imgF objectAtIndex:self.currentPage-1];
    if (imgView.frame.size.width <= WIDTH && imgView.frame.size.height <= Height126){
        scrollView.contentSize = CGSizeMake( WIDTH , Height126 );
        imgView.frame = noscaView.frame;
    }
}

//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    UIImageView *imgView;
    NSLog(@"%lu---%d", scrollView.tag, _currentPage);
    if(scrollView.tag == _currentPage){
        //取出 当前缩放图 的 未缩放的frame
         imgView = [self.arr_viewImg objectAtIndex:_currentPage-1];
        
    }
    
    return imgView;
//    return nil;
}

- (void)hiddenPics:(UITapGestureRecognizer *)tap{
    
    [_scBack removeFromSuperview];
    [_pageLbl removeFromSuperview];
    [_botomView removeFromSuperview];
    
    [self.arr_scro removeAllObjects];
    [self.arr_imgF removeAllObjects];
    [self.arr_viewImg removeAllObjects];

}

#pragma mark --- UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"----发送请求的网址%@", requestString);
    return YES;
   
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    // 过0.75秒后消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 加载完成后消失
//    [SVProgressHUD dismiss];
    NSLog(@"加载完成...");
// 能够缩小、放大网页
//     [webView stringByEvaluatingJavaScriptFromString:@"var element = document.createElement('meta');  element.name = \"viewport\";  element.content = \"width=device-width,initial-scale=1.0,minimum-scale=0.5,maximum-scale=3,user-scalable=1\"; var head = document.getElementsByTagName('head')[0]; head.appendChild(element);"];
    
    
    // 用户判断登录后是否是同一个cookie
//    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    for (NSHTTPCookie * cookie in cookies) {
//        NSString * name = [cookie name];
//        NSLog(@"---name---%@", name);
//        
//    }

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
     [SVProgressHUD showErrorWithStatus:@"加载失败"];
}

//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
//   
//}
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
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if (cookieName || wxData) {
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
        [self addAlertViewWithMessage:@"请在登录后进行操作"];
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
//    backView.backgroundColor = [UIColor colorWithRed:288 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.5];
    // 当前顶层窗口
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    // 添加到灰色的背景图
    [window addSubview:backView];
    _backView = backView;
    // 添加评论视图
    CommentView * commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, Margin242 * IPHONE6_H_SCALE)];
    _commentView = commentView;
    // 对键盘添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    commentView.delegate = self;
    [commentView.textView becomeFirstResponder];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    commentView.userInteractionEnabled = YES;
    [commentView addGestureRecognizer:tap];
    commentView.backgroundColor = Color239;
//    commentView.backgroundColor = [UIColor redColor];
    [window addSubview:commentView];
    
    
//    NSLog(@"%@", _commentView);
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
            [self collectOrCancelCollect];
            [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
            
        }
        _bottomView.collectionBtn.selected = !_bottomView.collectionBtn.selected;
    } else  // 如果没有登录
    {
        [self addAlertViewWithMessage:@"请在登录后进行操作"];
    }
  
    
}

#pragma mark --- 收藏或取消收藏
- (void)collectOrCancelCollect{
    NSString * url = [CollectionURL stringByAppendingString:[NSString stringWithFormat:@"/%@", _model.iD]];
    //            NSLog(@"进行收藏的接口----%@", url);
    [DataTool getCollectWithStr:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"收藏返回的数据%@", responseObject);
        NSLog(@"%@", responseObject[@"content"]);
        
    } failure:^(NSError * error) {
        
        NSLog(@"收藏的错误信息--%@", error);
    }];
}

#pragma mark --- 添加登录的alertView
- (void)addAlertViewWithMessage:(NSString *)message{
    LSAlertView * alertView = [[LSAlertView alloc] init];
    alertView.delegate = self;
    
    // 提示框上的提示信息
    alertView.messageLbl.text = message;
    
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
//    NSLog(@"img:%@", img);
    if (!img) {
        img = [UIImage imageNamed:@"shareLogo"];
    }
    
    [UMSocialData defaultData].extConfig.title = _model.title;
    
    // 友盟分享代码，复制、粘贴
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55556bc8e0f55a56230001d8"
                                      shareText:[NSString stringWithFormat:@"%@",_model.descriptioN]
                                     shareImage:img
                                shareToSnsNames:@[UMShareToSina ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,@"CustomPlatform"]
                                       delegate:self]; // 分享到朋友圈、微信好友、QQ空间、QQ好友
    
    // 分享到各个平台的内容  如果没有下面的代码就会跳到友盟首页（自己设置的URL）
    NSString * wapurl = [_wapurl stringByAppendingString:@"?isshare=1"];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = wapurl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = wapurl;
    [UMSocialData defaultData].extConfig.qqData.url = wapurl;
    [UMSocialData defaultData].extConfig.qzoneData.url = wapurl;
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:wapurl];
    
//     [UMSocialData defaultData].extConfig.qqData.title = _model.title;
    [UMSocialData defaultData].extConfig.qqData.shareImage = img;
    [UMSocialData defaultData].extConfig.qzoneData.shareImage = img;
//    [UMSocialData defaultData].extConfig.qqData.shareText = _model.descriptioN;
//     [UMSocialData defaultData].extConfig.qzoneData.title = _model.title;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
