//
//  LiveModel.h
//  dipai
//
//  Created by 梁森 on 16/7/9.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface LiveModel : NSObject<MJKeyValue>
/*
                 "pid":"48",// 赛况ID
 
                 "name":"asd",// 赛况
 
                 "match_state":" 开始 ",// 赛况状态
 
                 "blind":" 111 ",// 当前盲注
 
                 "score":"111",// 平均记分牌
 
                 "player":"111",// 剩余选手

 */

/**
 *  赛况ID
 */
@property (nonatomic, copy) NSString * pid;
/**
 *  赛况
 */
@property (nonatomic, copy) NSString * name;
/**
 *  赛况状态
 */
@property (nonatomic, copy) NSString * match_state;
/**
 *  当前盲注
 */
@property (nonatomic, copy) NSString * blind;
/**
 *  平均记分牌
 */
@property (nonatomic, copy) NSString * score;
/**
 *  剩余选手
 */
@property (nonatomic, copy) NSString * player;
/**
 *  赛事直播接口
 */
@property (nonatomic, copy) NSString * wapurl;
@end












