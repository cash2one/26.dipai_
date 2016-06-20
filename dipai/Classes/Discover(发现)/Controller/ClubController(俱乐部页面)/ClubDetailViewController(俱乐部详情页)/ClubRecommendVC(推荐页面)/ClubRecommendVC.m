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
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    [self.view addSubview:webView];
    _webView = webView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

- (void)setWapurl:(NSString *)wapurl{
    _wapurl = wapurl;
    NSLog(@"%@", _wapurl);
    
    NSURL * URL = [NSURL URLWithString:_wapurl];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    [_webView loadRequest:request];
}

#pragma mark --- UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
