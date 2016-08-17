//
//  UserModel.h
//  dipai
//
//  Created by 梁森 on 16/6/19.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface UserModel : NSObject<MJKeyValue>
/*
 "count_follow" = 0;
 "count_followed" = 0;
 face = "";
 userid = 22;
 username = Liangsen226;
 */
/*
 "comment_num" = 0;
 face = "";
 follow = 0;
 row = 1;
 userid = 24;
 username
 */
// 测试一下如果模型中的属性多余请求返回到的数据会怎样
@property (nonatomic, copy) NSString * count_follow;
@property (nonatomic, copy) NSString * count_followed;
/**
 *  用户头像
 */
@property (nonatomic, copy) NSString * face;
/**
 *  大头像
 */
@property (nonatomic, copy) NSString * max_face;
/**
 *  用户ID
 */
@property (nonatomic, copy) NSString * userid;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString * username;
/**
 *  收到的评论数
 */
@property (nonatomic, copy) NSString * comment_num;
/**
 *  粉丝数
 */
@property (nonatomic, copy) NSString * follow;
/**
 *  关注数
 */
@property (nonatomic, copy) NSString * row;
/**
 *  绑定的标识1：未绑定手机 2：未绑定微信 0：都绑定
 */
@property (nonatomic, copy) NSString * binding;
@end
