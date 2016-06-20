//
//  CommentsModel.h
//  dipai
//
//  Created by 梁森 on 16/6/6.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface CommentsModel : NSObject<MJKeyValue>
/*
 "userid":"20",
 "username":"Liangsen",
 "face":"",
 "content":"very ",
 "addtime":"2016-06-06 04:15:33",
 "reply":null,
 "wapurl":
 */
/**
*  用户id
*/
@property (nonatomic, copy) NSString * userid;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString * username;
/**
 *  用户头像
 */
@property (nonatomic, copy) NSString * face;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString * content;
/**
 *  评论的ID
 */
@property (nonatomic, copy) NSString * comment_id;
/**
 *  评论时间
 */
@property (nonatomic, copy) NSString * addtime;
/**
 *  回复（包括用户名和回复内容）
 */
@property (nonatomic, copy) NSMutableDictionary * reply;
/**
 *  用户地址
 */
@property (nonatomic, copy) NSString * wapurl;

@end
