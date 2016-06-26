//
//  PostsModel.h
//  dipai
//
//  Created by 梁森 on 16/6/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface PostsModel : NSObject<MJKeyValue>
/*
 "userid":"22",
 "username":"Liangsen226",
 "face":"",
 "title":"1",
 "id":"10",
 "introduction":" 1",
 "picname":[
 "/public/upload/user_forum/22/20160624/1466738158922mim.jpeg",
 "/public/upload/user_forum/22/20160624/1466738158322mim.jpeg"
 ],
 "addtime":"2016-06-24",
 "comment":"0",
 "wapurl":"http://dipaiapp.replays.net/app/forum/view/10",
 "userurl":
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
 *  帖子标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  帖子ID
 */
@property (nonatomic, copy) NSString * iD;
/**
 *  帖子内容简介
 */
@property (nonatomic, copy) NSString * introduction;
/**
 *  帖子图片的缩略图数组
 */
@property (nonatomic, strong) NSMutableArray * picname;
/**
 *  添加时间
 */
@property (nonatomic, copy) NSString * addtime;
/**
 *  评论数
 */
@property (nonatomic, copy) NSString * comment;
/**
 *  详情页接口
 */
@property (nonatomic, copy) NSString * wapurl;
/**
 *  用户页接口
 */
@property (nonatomic, copy) NSString * userurl;
@end
