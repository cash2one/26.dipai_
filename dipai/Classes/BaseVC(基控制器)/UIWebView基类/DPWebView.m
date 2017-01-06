//
//  DPWebView.m
//  dipai
//
//  Created by 梁森 on 16/12/23.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "DPWebView.h"

@interface DPWebView ()< UIWebViewDelegate>
{
    NSString * _firstIn;
}
@end

@implementation DPWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void)setUpUI{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.naviBar.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    _webView = webView;
    
    // UIWebView与JS的交互
    JSContext *context = [_webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 打电话
    context[@"getPhoneNum"] = ^() { // 通过block回调获得h5传来的数据
        NSArray *args = [JSContext currentArguments];
        NSLog(@"%@", args);
        NSString * phoneNum = [args firstObject];
        NSLog(@"phoneNum:%@", phoneNum);
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    };
    // 打开内部网页
    //    context[@"getURL"] = ^() { // 通过block回调获得h5传来的数据
    //        NSArray *args = [JSContext currentArguments];
    //        JSValue * value = [args firstObject];
    //        NSLog(@"url:%@", value.toString);
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            DPWebView * serVC = [[DPWebView alloc] init];
    //            serVC.weburl = value.toString;
    //            [self.navigationController pushViewController:serVC animated:YES];
    //
    //        });
    //
    //    };
    
    // 打开另外的H5页面
    context[@"openHTML"] = ^() { // 通过block回调获得h5传来的数据
        NSArray *args = [JSContext currentArguments];
        JSValue * value = [args firstObject];
        NSString * url = value.toString;
        [HttpTool GET:url parameters:nil success:^(id responseObject) {
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
        
    };
    // 打开外部链接
    context[@"openBrowser"] = ^() { // 通过block回调获得h5传来的数据
        NSArray *args = [JSContext currentArguments];
        JSValue * value = [args firstObject];
        NSString * urlStr = value.toString;
        NSURL * url = [NSURL URLWithString:urlStr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            NSLog(@"无法打开外部链接");
        }
        
    };
    // 登录事件
    context[@"login"] = ^() { // 通过block回调获得h5传来的数据
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * cookieName = [defaults objectForKey:Cookie];
        NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
        if (cookieName  || wxData) {
            
        }else{
            
            LoginViewController * loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    };

    
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"%s", __func__);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    // UIWebView与JS的交互
    JSContext *context = [_webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 打电话
    context[@"getPhoneNum"] = ^() { // 通过block回调获得h5传来的数据
        NSArray *args = [JSContext currentArguments];
        NSLog(@"%@", args);
        NSString * phoneNum = [args firstObject];
        NSLog(@"phoneNum:%@", phoneNum);
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    };
    // 打开内部网页
    //    context[@"getURL"] = ^() { // 通过block回调获得h5传来的数据
    //        NSArray *args = [JSContext currentArguments];
    //        JSValue * value = [args firstObject];
    //        NSLog(@"url:%@", value.toString);
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            DPWebView * serVC = [[DPWebView alloc] init];
    //            serVC.weburl = value.toString;
    //            [self.navigationController pushViewController:serVC animated:YES];
    //
    //        });
    //
    //    };
    
    // 打开另外的H5页面
    context[@"openHTML"] = ^() { // 通过block回调获得h5传来的数据
        NSArray *args = [JSContext currentArguments];
        JSValue * value = [args firstObject];
        NSString * url = value.toString;
        [HttpTool GET:url parameters:nil success:^(id responseObject) {
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
        
    };
    // 打开外部链接
    context[@"openBrowser"] = ^() { // 通过block回调获得h5传来的数据
        NSArray *args = [JSContext currentArguments];
        JSValue * value = [args firstObject];
        NSString * urlStr = value.toString;
        NSURL * url = [NSURL URLWithString:urlStr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            NSLog(@"无法打开外部链接");
        }
        
    };
    // 登录事件
    context[@"login"] = ^() { // 通过block回调获得h5传来的数据
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * cookieName = [defaults objectForKey:Cookie];
        NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
        if (cookieName  || wxData) {
            
        }else{
            
            LoginViewController * loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    };
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
