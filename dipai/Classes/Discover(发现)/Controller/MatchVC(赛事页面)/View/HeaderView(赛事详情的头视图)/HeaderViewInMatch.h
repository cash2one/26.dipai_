//
//  HeaderViewInMatch.h
//  dipai
//
//  Created by 梁森 on 16/6/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EndMatchModel;
@class NoLiveModel;
@class MatchingModel;
@interface HeaderViewInMatch : UIView
/**
 *  赛事标识：0:进行中  1:即将开始  2:已结束
 */
@property (nonatomic, assign) int flag;
/**
 *  赛事模型
 */
@property (nonatomic, strong) MatchingModel * matchModel;

@end
