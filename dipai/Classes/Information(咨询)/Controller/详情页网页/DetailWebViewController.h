//
//  DetailWebViewController.h
//  dipai
//
//  Created by 梁森 on 16/5/3.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationHiddenVC.h"
@class NewsListModel;
@interface DetailWebViewController : NavigationHiddenVC
/**
 *  传递过来的一个模型
 */
@property (nonatomic, strong) NewsListModel * newsModel;

/**
 *  传递过来的跳转链接
 */
@property (nonatomic, copy) NSString * url;
// 加载网页链接
@property (nonatomic, copy) NSString * weburl;
// 传递过来的请求数据
@property (nonatomic, strong) NSDictionary * responseObject;

@end
