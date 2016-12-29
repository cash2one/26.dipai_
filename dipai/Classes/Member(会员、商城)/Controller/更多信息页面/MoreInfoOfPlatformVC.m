//
//  MoreInfoOfPlatformVC.m
//  dipai
//
//  Created by 梁森 on 16/11/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MoreInfoOfPlatformVC.h"

@interface MoreInfoOfPlatformVC ()


@end

@implementation MoreInfoOfPlatformVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    [self loadWebView];
}

- (void)loadWebView{
    
    NSString * url = @"";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * xcDic = [defaults objectForKey:WXUser];
    NSDictionary * phoneDic = [defaults objectForKey:User];
    
    NSLog(@"%@", self.url);
    if (xcDic != nil) {
        url = xcDic[@"userid"];
        self.url =  [self.url stringByAppendingString:[NSString stringWithFormat:@"?userid=%@", url]];
    }else if(phoneDic != nil){
        url = phoneDic[@"userid"];
        self.url = [self.url stringByAppendingString:[NSString stringWithFormat:@"?userid=%@", url]];
    }else{
        self.url = [self.url stringByAppendingString:url];
    }
    NSLog(@"加载网址：---%@", self.url);
    [HttpTool GET:self.url parameters:nil success:^(id responseObject) {
        NSLog(@"加载网址返回的数据：%@", responseObject);
        
    } failure:^(NSError *error) {
        
    }];
//    if ([self.stype isEqualToString:@"1"]) {
    
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
    NSLog(@"添加cookie");
    [self.webView loadRequest:request];
//    }else{  // 假数据
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dpapp.replays.net/html/liyu.html"]]];
        // http://dipaiapp.replays.net/html/zp/index.html
        //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dipaiapp.replays.net/html/zp/index.html"]]];
//    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
//    [self loadWKWebView];
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"平台详情";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
   
}

- (void)loadWKWebView{

    NSString * url = @"";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * xcDic = [defaults objectForKey:WXUser];
    NSDictionary * phoneDic = [defaults objectForKey:User];

    NSLog(@"%@", self.url);
    if (xcDic != nil) {
        url = xcDic[@"userid"];
        self.url =  [self.url stringByAppendingString:[NSString stringWithFormat:@"?userid=%@", url]];
    }else if(phoneDic != nil){
        url = phoneDic[@"userid"];
         self.url = [self.url stringByAppendingString:[NSString stringWithFormat:@"?userid=%@", url]];
    }else{
        self.url = [self.url stringByAppendingString:url];
    }
    
}

#pragma mark - WKUIDelegate


#pragma mark - WKScriptMessageHandler



@end
