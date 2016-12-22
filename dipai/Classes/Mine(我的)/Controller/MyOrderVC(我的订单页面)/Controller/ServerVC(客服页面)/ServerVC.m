//
//  ServerVC.m
//  dipai
//
//  Created by 梁森 on 16/10/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ServerVC.h"
#import "Masonry.h"

#import "NextServerVC.h"

#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface ServerVC ()<WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;

@property (nonatomic, strong) UIProgressView * progressV;

@property (nonatomic, strong) UIButton * backBtn;
@end

@implementation ServerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SeparateColor;
    [self setNavigationBar];
    [self setUpUI];
    
}

- (void)setNavigationBar{
    
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    self.naviBar.titleStr = @"常见问题";
}
- (void)setUpUI{
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    // 设置偏好设置
//    config.preferences = [[WKPreferences alloc] init];
//    // 默认为0
//    config.preferences.minimumFontSize = 10;
//    // 默认认为YES
//    config.preferences.javaScriptEnabled = YES;
//    // 在iOS上默认为NO，表示不能自动通过窗口打开
//    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
//    config.processPool = [[WKProcessPool alloc] init];
//    
//    // 通过JS与webview内容交互
//    config.userContentController = [[WKUserContentController alloc] init];
    
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    //    [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
//    CGRect rect = CGRectMake(0, 64, WIDTH, HEIGHT - 64);
//    WKWebView * webView  = [[WKWebView alloc] initWithFrame:rect
//                                      configuration:config];
//    webView.backgroundColor = [UIColor redColor];
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.naviBar.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
//    webView.UIDelegate = self;
//    webView.navigationDelegate = self;
    if (self.weburl.length > 0) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.weburl]]];
    }else{
        NSString * url = nil;
        if ([ServiceURL hasPrefix:@"http"]) {
            url = ServiceURL;
        }else{
            url = [NSString stringWithFormat:@"%@%@", DipaiBaseURL, ServiceURL];
        }
         [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
   
//    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView = webView;
    
    // UIWebView与JS的交互
    JSContext *context = [self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSLog(@"%@", context);
    context[@"getPhoneNum"] = ^() { // 通过block回调获得h5传来的数据
    
        NSArray *args = [JSContext currentArguments];
//        NSLog(@"%@", args);
        NSString * phoneNum = [args firstObject];
        NSLog(@"phoneNum:%@", phoneNum);
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    };
    
    context[@"getURL"] = ^() { // 通过block回调获得h5传来的数据
        
        NSArray *args = [JSContext currentArguments];
//        NSLog(@"%@", args);
        JSValue * value = [args firstObject];
        NSLog(@"url:%@", value.toString);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ServerVC * serVC = [[ServerVC alloc] init];
            serVC.weburl = value.toString;
            [self.navigationController pushViewController:serVC animated:YES];
            
        });
        
       
    };
    
    
//    UIProgressView * progressV = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 8)];
//    progressV.backgroundColor = [UIColor blueColor];
//    progressV.tintColor = [UIColor redColor];
//    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.5f);
//    progressV.transform = transform;//设定宽高
//    [self.view addSubview:progressV];
//    self.progressV = progressV;
    
    
    // 返回按钮和前进按钮
//    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     [self.view addSubview:backBtn];
//    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(10);
//        make.top.equalTo(self.naviBar.mas_bottom);
//        make.width.equalTo(@(30));
//        make.height.equalTo(@(30));
//    }];
//    backBtn.backgroundColor = [UIColor redColor];
//    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.hidden = YES;
//    self.backBtn = backBtn;

//    UIButton * forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     [self.view addSubview:forwardBtn];
//    [forwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).offset(-10);
//        make.top.equalTo(self.naviBar.mas_bottom);
//        make.width.equalTo(@(30));
//        make.height.equalTo(@(30));
//    }];
//    forwardBtn.backgroundColor = [UIColor redColor];
//    [forwardBtn addTarget:self action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];

//    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
//    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    //
}

// 返回事件
- (void)backAction{
    
    [self.webView goBack];

}
// 前进事件
- (void)forwardAction{
    [self.webView goForward];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    
//    self.progressV.progress = self.webView.estimatedProgress;
//    self.progressV.hidden = self.webView.estimatedProgress >= 1;
//    if ([self.webView canGoBack]) {
//        self.backBtn.hidden = NO;
//    }else{
//        self.backBtn.hidden = YES;
//    }
//}

//- (void)dealloc{
//    
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
//    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
//    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
//}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
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
//    decisionHandler(WKNavigationResponsePolicyCancel);
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
//    NSString * phoneNum = message;
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
//    NSURL * url = [NSURL URLWithString:str];
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
//            if (success) {
//                NSLog(@"%@", url);
//            }
//        }];
//    }else{
//        
//        NSLog(@"不能打电话");
//    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
