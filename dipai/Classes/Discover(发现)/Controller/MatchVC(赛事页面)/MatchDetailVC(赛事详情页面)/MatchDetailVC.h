//
//  MatchDetailVC.h
//  dipai
//
//  Created by 梁森 on 16/6/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationHiddenVC.h"
@class EndMatchModel;
@interface MatchDetailVC : NavigationHiddenVC

@property (nonatomic, strong) EndMatchModel * matchModel;

/**
 *  跳转链接
 */
@property (nonatomic, copy) NSString * wapurl;
/**
 *  比赛的标识：1:即将开始
 */
@property (nonatomic, assign) int flag;
@end
