//
//  MyReceiveModel.h
//  dipai
//
//  Created by 梁森 on 16/7/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface MyReceiveModel : NSObject<MJKeyValue>
/*
 addtime = "2016-07-05";
 content = "J\U808c\U5065\U5065\U5eb7\U5eb7\U5f00\U53e3";
 id = 66;
 "p_title" = M;
 "p_userid" = 22;
 type = 1;
 username = Nick;
 userurl = "
 wapurl = "
 */

/**
 *  添加时间
 */
@property (nonatomic, copy) NSString * addtime;
/**
 *  内容
 */
@property (nonatomic, copy) NSString * content;
/**
 *  收到的评论的ID
 */
@property (nonatomic, copy) NSString * iD;
/**
 *  标题
 */
@property (nonatomic, copy) NSString * p_title;
/**
 *  <#Description#>
 */
@property (nonatomic, copy) NSString * p_userid;
/**
 *  0:帖子  1:回复
 */
@property (nonatomic, copy) NSString * type;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString * username;
/**
 *  用户地址
 */
@property (nonatomic, copy) NSString * userurl;
@property (nonatomic, copy) NSString * wapurl;
@end
