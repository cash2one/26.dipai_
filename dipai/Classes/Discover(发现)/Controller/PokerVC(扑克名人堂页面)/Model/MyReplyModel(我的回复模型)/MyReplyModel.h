//
//  MyReplyModel.h
//  dipai
//
//  Created by 梁森 on 16/7/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface MyReplyModel : NSObject<MJKeyValue>
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
 "userurl":"http://dipaiapp.replays.net/app/forum/view/62"
 },
 */

/**
*  不知道什么ID
*/
@property (nonatomic, copy) NSString * lid;
/**
 *  回复的图片
 */
@property (nonatomic, strong) NSArray * picname;

/**
*  用户ID
*/
@property (nonatomic, copy) NSString * userid;

@property (nonatomic, copy) NSString * username;

@property (nonatomic, copy) NSString * face;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString * content;

/**
 *  评论ID 
 */
@property (nonatomic, copy) NSString * comment_id;
/**
 *  评论时间
 */
@property (nonatomic, copy) NSString * addtime;
/**
 *  回复（包括用户名和回复内容）
 */
@property (nonatomic, strong) NSDictionary * reply;
/**
 *  用户地址
 */
@property (nonatomic, copy) NSString * wapurl;

@end
