//
//  NoLiveModel.h
//  dipai
//
//  Created by 梁森 on 16/7/9.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface NoLiveModel : NSObject<MJKeyValue>
/*
 "id":"4917",
             "type":"5",
             "place":"北京",
 // 地址
             "start_time":"03-24",
 // 开始时间
             "end_time":"10-07",
 // 结束时间
             "prize_pool":"688K",
 // 主奖池
             "entry_fee":"1.8K积分"

 */

@property (nonatomic, copy) NSString * iD;
@property (nonatomic, copy) NSString * type;
/**
 *  赛事地点
 */
@property (nonatomic, copy) NSString * place;
/**
 *  开始时间
 */
@property (nonatomic, copy) NSString * start_time;
/**
 *  结束时间
 */
@property (nonatomic, copy) NSString * end_time;
/**
 *  主奖池
 */
@property (nonatomic, copy) NSString * prize_pool;
/**
 *  报名费
 */
@property (nonatomic, copy) NSString * entry_fee;
@end





