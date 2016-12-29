//
//  DPWebView.h
//  dipai
//
//  Created by 梁森 on 16/12/23.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NavigationHiddenVC.h"
#import "Masonry.h"
#import "H5ViewController.h"
#import "HttpTool.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface DPWebView : NavigationHiddenVC

@property (nonatomic, strong) UIWebView * webView;
// 网页地址
@property (nonatomic, copy) NSString * weburl;

@property (nonatomic, strong) JSContext *context;
@end
