//
//  PostDetailModel.h
//  dipai
//
//  Created by 梁森 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface PostDetailModel : NSObject<MJKeyValue>
/*
 "type":"172",
 "state":"1",
 "data":{
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
 }
 */
/**
*  模块类型
*/
@property (nonatomic, copy) NSString * type;
/**
 *  成功失败的标识
 */
@property (nonatomic, copy) NSString * state;
/**
 *  帖子＋评论
 */
@property (nonatomic, copy) NSDictionary * data;
@end
