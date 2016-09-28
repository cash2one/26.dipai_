//
//  MatchingHeader.h
//  dipai
//
//  Created by 梁森 on 16/6/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchingHeader : UIView
/**
 *  赛事状态
 */
@property (nonatomic, strong) UILabel * stateLbl;
/**
 *  赛事标题
 */
@property (nonatomic, strong) UILabel * titleLbl;
/**
 *  分割线
 */
@property (nonatomic, strong) UIView * separateView;
/**
 *  盲注数
 */
@property (nonatomic, strong) UILabel * blindNum;
/**
 *  ante数
 */
@property (nonatomic, strong) UILabel * anteLbl;

/**
 *  平均记分数
 */
@property (nonatomic, strong) UILabel * score;
/**
 *  剩余选手数
 */
@property (nonatomic, strong) UILabel * players;
@end
