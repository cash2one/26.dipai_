//
//  ClubRecommendVC.m
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ClubRecommendVC.h"

#import "SVProgressHUD.h"

#import "Masonry.h"

#import <JavaScriptCore/JavaScriptCore.h>
@interface ClubRecommendVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;
// 没有内容的提示图
@property (nonatomic, strong) UIImageView * imageV;

@end

@implementation ClubRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

- (void)setUpUI{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    NSURL * URL = [NSURL URLWithString:self.wapurl];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
     [webView loadRequest:request];
    JSContext *context = [_webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"image_add_i"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        
        for (JSValue *jsVal in args) {
            NSLog(@"－－%@", jsVal);
        }
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
    };
    
    context[@"image_show_i"] = ^() {
        NSArray *args = [JSContext currentArguments];
        //        NSLog(@"%@", args);
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
            // 展示图片
        }
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
    };
    
    UIImageView * imageV = [[UIImageView alloc] init];
    [self.view addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"meiyouxiangguanneirong"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(289 * 0.5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(246 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(187 * 0.5 * IPHONE6_W_SCALE));
    }];
    _imageV = imageV;
    _imageV.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}


#pragma mark --- UIWebViewDelegate
// 开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"加载中..."];
}
// 加载结束
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    if (self.wapurl && self.wapurl.length > 0) {
        _imageV.hidden = YES;
    }else{
        _imageV.hidden = NO;
    }
}
// 加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
