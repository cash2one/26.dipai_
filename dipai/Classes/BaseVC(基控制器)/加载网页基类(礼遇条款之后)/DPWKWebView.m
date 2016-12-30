//
//  DPWKWebView.m
//  dipai
//
//  Created by 梁森 on 16/12/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "DPWKWebView.h"
#import "H5ViewController.h"
// 登录页面
#import "LoginViewController.h"
@interface DPWKWebView ()
@end

@implementation DPWKWebView


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    /*
     
     WKWebsiteDataTypeDiskCache,
     
     WKWebsiteDataTypeOfflineWebApplicationCache,
     
     WKWebsiteDataTypeMemoryCache,
     
     WKWebsiteDataTypeLocalStorage,
     
     WKWebsiteDataTypeCookies,
     
     WKWebsiteDataTypeSessionStorage,
     
     WKWebsiteDataTypeIndexedDBDatabases,
     
     WKWebsiteDataTypeWebSQLDatabases
     
     */
    
    NSArray * types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];
    NSSet *websiteDataTypes = [NSSet setWithArray:types];
    
    //// All kinds of data
    
    //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    //// Date from
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    //// Execute
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
        // Done
        
    }];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviBar.titleStr = @"";
    [self addWebView];
    [self addProgressView];
}

- (void)addWebView{
    
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
    [config.userContentController addScriptMessageHandler:self name:@"downloadApp"];    // 打开外部链接
    [config.userContentController addScriptMessageHandler:self name:@"getPhoneNum"];    // 打电话
    [config.userContentController addScriptMessageHandler:self name:@"getURL"]; // 打开内部网页
    [config.userContentController addScriptMessageHandler:self name:@"openHTML"];   // 打开另一个HTML
    [config.userContentController addScriptMessageHandler:self name:@"login"];   // 登录
    CGRect rect = CGRectMake(0, 64, WIDTH, HEIGHT - 64);
    WKWebView * webView  = [[WKWebView alloc] initWithFrame:rect configuration:config];
    [self.view addSubview:webView];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView = webView;
}
- (void)addProgressView{

    UIProgressView * progressV = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 8)];
    progressV.backgroundColor = [UIColor blueColor];
    progressV.tintColor = [UIColor redColor];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    progressV.transform = transform;//设定宽高
    [self.view addSubview:progressV];
    self.progressV = progressV;
    
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    //
    completionHandler();
    NSLog(@"3-----%@",message);
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertV show];
//    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alertVC addAction:OK];
//    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"body:%@", message.body);
    NSDictionary * dic = message.body;
    NSString * urlStr = dic[@"body"];
    if ([message.name isEqualToString:@"downloadApp"]) {    // 打开外部链接
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"%@",urlStr];
        NSURL * url = [NSURL URLWithString:str];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            // 在9上不能运行
        }else{
            
            NSLog(@"不能打开网页");
        }
    }
    if ([message.name isEqualToString:@"getPhoneNum"]) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",urlStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    if ([message.name isEqualToString:@"getURL"]) {
        
    }
    if ([message.name isEqualToString:@"openHTML"]) {
        [HttpTool GET:urlStr parameters:nil success:^(id responseObject) {
            NSString * type = responseObject[@"type"];
            NSString * wapurl = responseObject[@"content"];
            if ([type isEqualToString:@"201"]) {
                // 打开H5页面
                H5ViewController * h5VC = [[H5ViewController alloc] init];
                h5VC.wapurl = wapurl;
                [self.navigationController pushViewController:h5VC animated:YES];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    if ([message.name isEqualToString:@"login"]) {
        NSLog(@"login....");
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * cookieName = [defaults objectForKey:Cookie];
        NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
        if (cookieName  || wxData) {
            NSLog(@"已登录...");
        }else{
            NSLog(@"未登录....");
            //
            
            LoginViewController * loginVC = [[LoginViewController alloc] init];
            UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:loginNav animated:YES completion:nil];        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
