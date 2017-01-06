//
//  ClubDetailViewController.h
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationHiddenVC.h"
@interface ClubDetailViewController : NavigationHiddenVC
/**
 *  俱乐部名称
 */
@property (nonatomic, copy) NSString * title;
/**
 *  详情页接口
 */
@property (nonatomic, copy) NSString * wapurl;

@end
