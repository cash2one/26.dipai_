//
//  DPWKWebView.h
//  dipai
//
//  Created by 梁森 on 16/12/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NavigationHiddenVC.h"
#import <WebKit/WebKit.h>
@interface DPWKWebView : NavigationHiddenVC
@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) UIProgressView * progressV;
@end
