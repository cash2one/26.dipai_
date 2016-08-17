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
 "wapurl":"
 },
 Object{...}
 ],
 "comment"
 "relation":"
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
//@property (nonatomic, copy) NSString * type;

/**
 *  直播信息（无直播返回NULL）
 */
@property (nonatomic, copy) NSArray * app_live;
/**
 *  无直播（有直播返回NULL）
 */
@property (nonatomic, copy) NSDictionary * match;
/**
 *  评论列表
 */
@property (nonatomic, copy) NSString * comment;
/**
 *  文章关联列表
 */
@property (nonatomic, copy) NSString * relation;
@end
