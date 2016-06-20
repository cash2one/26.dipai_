//
//  EndMatchModel.h
//  dipai
//
//  Created by 梁森 on 16/6/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface EndMatchModel : NSObject<MJKeyValue>
/*
 id":"5110",
         "title":"2016CPG中国冠军赛",
         "type":"5",
         "picname":"http://dipaiadmin.replays.net/public/upload/picname/146640925920025.jpg",
         "start_time":"01.01",
         "end_time":"01.01",
         "place":"三亚",
         "prize_pool":"8M+",
         "entry_fee":"10K",
         "wapurl":"http://dipaiapp.replays.net/app/club/view/5/5110"
 */

/**
*  赛事ID
*/
@property (nonatomic, copy) NSString * iD;
/**
 *  赛事标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  赛事类型
 */
@property (nonatomic, copy) NSString * type;
/**
 *  封面图片
 */
@property (nonatomic, copy) NSString * picname;
/**
 *   开始时间
 */
@property (nonatomic, copy) NSString * start_time;
/**
 *  结束时间
 */
@property (nonatomic, copy) NSString * end_time;
/**
 *  赛事地点
 */
@property (nonatomic, copy) NSString * place;
/**
 *  主奖池
 */
@property (nonatomic, copy) NSString * prize_pool;
/**
 *  报名费
 */
@property (nonatomic, copy) NSString * entry_fee;
/**
 *  跳转的接口
 */
@property (nonatomic, copy) NSString * wapurl;
@end
