//
//  MatchingModel.h
//  dipai
//
//  Created by 梁森 on 16/6/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface MatchingModel : NSObject<MJKeyValue>
/*
 {
 "id":"5092",
 "title":"赛事赛事赛事赛事",
 "type":"5",
 "match_state":"ddddd",
 "blind":"dddd",
 "score":"9999",
 "player":"999",
 "app_live":[
 {
 "name":"asd",
 "wapurl":"http://dipaiapp.replays.net/app/club/live/5092/4"
 },
 Object{...}
 ],
 "comment":"http://dipaiapp.replays.net/app/list_comment/5092/5",
 "relation":"http://dipaiapp.replays.net/app/club/rel/5/5092"
 }
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
 *  赛事状态
 */
@property (nonatomic, copy) NSString * match_state;
/**
 *  当前盲注
 */
@property (nonatomic, copy) NSString * blind;
/**
 *  平均记分
 */
@property (nonatomic, copy) NSString * score;
/**
 *  剩余选手
 */
@property (nonatomic, copy) NSString * player;
/**
 *  直播信息
 */
@property (nonatomic, copy) NSArray * app_live;
/**
 *  评论列表
 */
@property (nonatomic, copy) NSString * comment;
/**
 *  文章关联列表
 */
@property (nonatomic, copy) NSString * relation;
@end
