//
//  GroupModel.h
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface GroupModel : NSObject<MJKeyValue>

/*
 "type": "0", (帖子)
 "userid": "22",  （用户id）
 "username": "Liangsen226", （用户姓名）
 "face": "",	（头像）
 "id": "66",	（帖子id）
 "title": "1",	（帖子标题）
 "introduction": "1",（前言，介绍）
 "picname": [
 ""
 ],
 "addtime": "2016-02-22",（发布时间）
 "comment": "10",（评论数量）
 "wapurl": ,（帖子详细页）
 "userurl": （用户空间）
 */

/*
 "type": "1", (回复或评论)
 "content": "1",（评论内容）
 "reply": null,
 */

// 类型（是帖子还是回复）
/**
 *  0:帖子   1:回复或评论
 */
@property (nonatomic, copy) NSString * type;
// 评论内容
@property (nonatomic, copy) NSString * content;
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
 *  帖子ID
 */
@property (nonatomic, copy) NSString * iD;
/**
 *  帖子标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString * introduction;

/**
 *  评论时间
 */
@property (nonatomic, copy) NSString * addtime;
@property (nonatomic, copy) NSString * comment;
/**
 *  帖子详情页
 */
@property (nonatomic, copy) NSString * wapurl;
/**
 *  用户空间
 */
@property (nonatomic, copy) NSString * userurl;

/**
 *  回复（包括用户名和回复内容）
 */
@property (nonatomic, strong) NSDictionary * reply;

@end
