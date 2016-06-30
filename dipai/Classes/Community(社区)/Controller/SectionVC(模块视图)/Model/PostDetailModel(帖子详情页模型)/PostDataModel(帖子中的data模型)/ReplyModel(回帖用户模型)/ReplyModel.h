//
//  ReplyModel.h
//  dipai
//
//  Created by 梁森 on 16/6/28.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyModel : NSObject
/*
 "userid":"25",
	                "username":"Nick",
	                "face":"",
	                "comment_id":"133",
	                "lid":"17",
	                "content":"v盖茨v干",
	                "addtime":"2016-06-29 19:21:59",
	                "picname":null,
	                "reply":{
	                    "username":"Nick",
	                    "content":"该嘉年华健健康康看看看看"
	                },
                 "userurl":
 */
/*
 {
 "userid":"22",
 "username":"Liangsen226",
 "face":"",
 "comment_id":"117",
 "content":"1",
 "addtime":"2016-06-28 10:57:27",
 "picname":"",
 "reply":null,
 "userurl":"http://dipaiapp.replays.net/app/user_space/22"
 },
 */

/**
*  不知什么ID
*/
@property (nonatomic, copy) NSString * lid;

/**
*  回帖用户ID
*/
@property (nonatomic, copy) NSString * userid;
/**
 *  回帖用户名
 */
@property (nonatomic, copy) NSString * username;
/**
 *  回帖用户头像
 */
@property (nonatomic, copy) NSString * face;
/**
 *  回帖ID
 */
@property (nonatomic, copy) NSString * comment_id;
/**
 *  回帖内容
 */
@property (nonatomic, copy) NSString * content;
/**
 *  回帖时间
 */
@property (nonatomic, copy) NSString * addtime;
/**
 *  回帖的图片
 */
@property (nonatomic, copy) NSArray * picname;
/**
 *  对回帖的回复
 */
@property (nonatomic, copy) NSDictionary * reply;
/**
 *  回帖用户的详情页
 */
@property (nonatomic, copy) NSString * userurl;

@end
