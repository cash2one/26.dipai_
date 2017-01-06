//
//  ServerVC.m
//  dipai
//
//  Created by 梁森 on 16/10/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ServerVC.h"
@interface ServerVC ()


@end

@implementation ServerVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self loadWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SeparateColor;
    [self setNavigationBar];
//    [self loadWebView];

}

- (void)setNavigationBar{
    
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    self.naviBar.titleStr = @"常见问题";
}
- (void)loadWebView{
    
    
    if (self.weburl.length > 0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.weburl]]];
    }else{
        NSString * url = nil;
        if ([ServiceURL hasPrefix:@"http"]) {
            url = ServiceURL;
        }else{
            url = [NSString stringWithFormat:@"%@%@", DipaiBaseURL, ServiceURL];
        }
         [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [SVProgressHUD dismiss];
    JSContext *context = [self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 打开内部网页
    context[@"getURL"] = ^() { // 通过block回调获得h5传来的数据
        NSArray *args = [JSContext currentArguments];
        JSValue * value = [args firstObject];
        NSLog(@"url:%@", value.toString);
        dispatch_async(dispatch_get_main_queue(), ^{
            ServerVC * serVC = [[ServerVC alloc] init];
            serVC.weburl = value.toString;
            [self.navigationController pushViewController:serVC animated:YES];
            
        });
        
    };
    
    context[@"getPhoneNum"] = ^() { // 通过block回调获得h5传来的数据
        NSArray *args = [JSContext currentArguments];
        NSLog(@"%@", args);
        NSString * phoneNum = [args firstObject];
        NSLog(@"phoneNum:%@", phoneNum);
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
