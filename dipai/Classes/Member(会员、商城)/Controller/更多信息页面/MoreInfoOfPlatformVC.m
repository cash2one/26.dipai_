//
//  MoreInfoOfPlatformVC.m
//  dipai
//
//  Created by 梁森 on 16/11/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MoreInfoOfPlatformVC.h"
#import "Masonry.h"

#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface MoreInfoOfPlatformVC ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) UIProgressView * progressV;

@end

@implementation MoreInfoOfPlatformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"平台详情";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
     [self showView];
    UIProgressView * progressV = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 8)];
    progressV.backgroundColor = [UIColor blueColor];
    progressV.tintColor = [UIColor redColor];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    progressV.transform = transform;//设定宽高
    [self.view addSubview:progressV];
    self.progressV = progressV;
   
}

- (void)showView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.processPool = [[WKProcessPool alloc] init];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    //    [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
    
    CGRect rect = CGRectMake(0, 64, WIDTH, HEIGHT - 64);
    WKWebView * webView  = [[WKWebView alloc] initWithFrame:rect configuration:config];
//    webView.backgroundColor = [UIColor redColor];
    [self.view addSubview:webView];
//    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.top.equalTo(self.naviBar.mas_bottom);
//        make.bottom.equalTo(self.view);
//    }];
    NSString * url = @"";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * xcDic = [defaults objectForKey:WXUser];
    NSDictionary * phoneDic = [defaults objectForKey:User];

    if (xcDic != nil) {
        url = xcDic[@"userid"];
        self.url =  [self.url stringByAppendingString:[NSString stringWithFormat:@"?userid=%@", url]];
    }else if(phoneDic != nil){
        url = phoneDic[@"userid"];
         self.url = [self.url stringByAppendingString:[NSString stringWithFormat:@"?userid=%@", url]];
    }else{
        self.url = [self.url stringByAppendingString:url];
    }
    NSLog(@"---%@", self.url);
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView = webView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    self.progressV.progress = self.webView.estimatedProgress;
    self.progressV.hidden = self.webView.estimatedProgress >= 1;
}

- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"失败...");
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"www");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"1------%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"2------%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
//    decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
    
    NSLog(@"－－－－－%@", prompt);
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
    NSLog(@"-----%@",message);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    completionHandler();
    NSLog(@"3-----%@",message);
    NSString * phoneNum = message;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"%@",phoneNum];
    NSURL * url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"%@", url);
            }
        }];
    }else{
        
        NSLog(@"不能打开网页");
    }
    
}

@end
