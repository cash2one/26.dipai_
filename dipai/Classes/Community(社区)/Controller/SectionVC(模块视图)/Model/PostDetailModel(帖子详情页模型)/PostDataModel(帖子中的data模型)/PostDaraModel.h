//
//  PostDaraModel.h
//  dipai
//
//  Created by 梁森 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface PostDaraModel : NSObject<MJKeyValue>
/*
 "userid":"22",
 "username":"Liangsen226",
 "face":"http://dipaiadmin.replays.net",
 "title":"1",
 "content":"2",
 "addtime":"2016-06-26",
 "comment":null,
 "imgs":[
 "/public/upload/user_forum/22/20160626/1466928223322.jpeg",
 "/public/upload/user_forum/22/20160626/1466928223822.jpeg"
 ],
 "is_user":"-1"
 is_collection
 */
/**
*  用户ID
*/
@property (nonatomic, copy) NSString * userid;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString * username;
/**
 *  头像
 */
@property (nonatomic, copy) NSString * face;
/**
 *  帖子ID
 */
@property (nonatomic, copy) NSString * iD;

/**
 *  标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  内容
 */
@property (nonatomic, copy) NSString * content;
/**
 *  添加时间
 */
@property (nonatomic, copy) NSString * addtime;
/**
 *  评论
 */
@property (nonatomic, copy) NSArray * comment;  //  数组中是字典
/**
 *  图片
 */
@property (nonatomic, copy) NSArray * imgs;
/**
 *  是否是登录用户发的帖子的标识
 */
@property (nonatomic, copy) NSString * is_user;

/**
 *  是否被收藏的标识
 */
@property (nonatomic, copy) NSString * is_collection;

/**
 *  分享链接
 */
@property (nonatomic, copy) NSString * wapurl;

@end
