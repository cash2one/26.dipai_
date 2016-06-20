//
//  MatchModel.h
//  dipai
//
//  Created by 梁森 on 16/6/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface MatchModel : NSObject<MJKeyValue>
/*
 "name":3,
 "rows":[
 {
 "id":"4917",
 "title":"跑跑扑克俱乐部周年庆典赛",
 "type":"5",
 "picname":"http://dipaiadmin.replays.net/uploads/picname/2016/03/1458704885VdQ.jpg",
 "start_time":"03.24",
 "end_time":"10.07",
 "place":"北京",
 "prize_pool":"688K",
 "entry_fee":"1.8K积分",
 "wapurl":"http://dipaiapp.replays.net/app/club/view/5/4917"
 }
 ]
 */
/**
*  月份
*/
@property (nonatomic, copy) NSString * name;
/**
 *  装所有赛事的一个数组
 */
@property (nonatomic, strong) NSArray * rows;
@end
