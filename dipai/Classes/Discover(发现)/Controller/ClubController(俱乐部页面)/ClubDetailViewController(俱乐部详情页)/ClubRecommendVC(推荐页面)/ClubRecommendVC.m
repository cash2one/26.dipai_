//
//  ClubRecommendVC.m
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ClubRecommendVC.h"

#import "SVProgressHUD.h"
@interface ClubRecommendVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;

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
