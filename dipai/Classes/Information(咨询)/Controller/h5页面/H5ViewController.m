//
//  H5ViewController.m
//  dipai
//
//  Created by 梁森 on 16/12/12.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "H5ViewController.h"
#import <WebKit/WebKit.h>
#import "LoginViewController.h"
@interface H5ViewController ()<WKUIDelegate, WKNavigationDelegate>

@end

@implementation H5ViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
//    [self.webView reload];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    [self reload];
}

- (void)reload{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if (cookieName  || wxData) {
        NSLog(@"已登录..");
    }else{
        // 清除cookie
        NSLog(@"未登录..");
        if ([[[UIDevice currentDevice] systemVersion] intValue ] > 8) {
            NSLog(@"iOS版本大于8.。。");
            WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
            [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                             completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                                 for (WKWebsiteDataRecord *record  in records)
                                 {
                                     [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                               forDataRecords:@[record]
                                                                            completionHandler:^{
                                                                                NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                            }];
                                 }
                             }];
        }
        
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        WKWebsiteDataTypeDiskCache,
                                                        //                                                        WKWebsiteDataTypeOfflineWebApplicationCache,
                                                        WKWebsiteDataTypeMemoryCache,
                                                        //                                                        WKWebsiteDataTypeLocalStorage,
                                                        WKWebsiteDataTypeCookies,
                                                        WKWebsiteDataTypeSessionStorage,
                                                        //                                                        WKWebsiteDataTypeIndexedDBDatabases,
                                                        //                                                        WKWebsiteDataTypeWebSQLDatabases
                                                        ]];
        //你可以选择性的删除一些你需要删除的文件 or 也可以直接全部删除所有缓存的type
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                   modifiedSince:dateFrom completionHandler:^{
                                                       // code
                                                   }];
    }
    
    if (self.wapurl) {
        // 在请求中添加cookie
        // 在此处获取返回的cookie
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
        NSLog(@"%@", cookieValue);
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.wapurl]];
        [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
        NSLog(@"添加cookie");
        [self.webView loadRequest:request];
        
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
   
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showWebView{
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.wapurl]]];
}


#pragma mark - WKNavigationDelegate
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
