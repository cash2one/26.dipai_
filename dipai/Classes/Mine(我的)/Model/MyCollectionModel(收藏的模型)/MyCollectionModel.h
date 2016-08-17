//
//  MyCollectionModel.h
//  dipai
//
//  Created by 梁森 on 16/7/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface MyCollectionModel : NSObject<MJKeyValue>
/*
 commentNumber = 0;
 covers =             {
 cover1 =
 cover2 =
 };
 description = e;
 face = "";
 id = 101765;
 shorttitle = Liangsen226;
 title = 3;
 type = 17;
 url = "
 userurl =
 */
/**
 *  某个收藏的评论数
 */
@property (nonatomic, copy) NSString * commentNumber;
/**
 *  某个收藏的图片
 */
// 应该是数组
@property (nonatomic, copy) NSDictionary * covers;
/**
 *  某个收藏的描述
 */
@property (nonatomic, copy) NSString * descriptioN;
/**
 *  收藏帖子的用户头像
 */
@property (nonatomic, copy) NSString * face;
/**
 *  某个收藏的ID
 */
@property (nonatomic, copy) NSString * iD;
/**
 *  收藏帖子的用户名
 */
@property (nonatomic, copy) NSString * shorttitle;
/**
 *  标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  不知道的什么类型
 */
@property (nonatomic, copy) NSString * type;
/**
 *  某个收藏的跳转链接
 */
@property (nonatomic, copy) NSString * url;
/**
 *  收藏帖子的用户主页
 */
@property (nonatomic, copy) NSString * userurl;

@end
