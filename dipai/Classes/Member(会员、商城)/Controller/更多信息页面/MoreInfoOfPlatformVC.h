//
//  MoreInfoOfPlatformVC.h
//  dipai
//
//  Created by 梁森 on 16/11/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NavigationHiddenVC.h"
#import "DPWKWebView.h"
@interface MoreInfoOfPlatformVC : DPWKWebView
// 状态码1:正常  2:假页面
@property (nonatomic, copy) NSString * stype;
// 平台绑定地址
@property (nonatomic, copy) NSString * url;

@end
