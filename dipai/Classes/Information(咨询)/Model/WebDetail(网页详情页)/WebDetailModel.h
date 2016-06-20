//
//  WebDetailModel.h
//  dipai
//
//  Created by 梁森 on 16/5/5.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
// 第三方
#import "MJExtension.h"
@interface WebDetailModel : NSObject<MJKeyValue>
/*
 "id":"5099",
 "title":"资讯资讯资讯资讯资讯资讯",
 "description":"分享描述分享描述分享描述分享描述分享描述分享描述",
 "commentNumber":"0",
 "picname":"http://10.0.0.14:8081",
 "wapurl":"http://10.0.0.14:8080/app/art/view/html/2/5099",
 "is_collection":"0"
 */
/**
*  ID 文章的唯一标识
*/
@property (nonatomic, copy) NSString * iD;
/**
 *  文章标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  文章描述
 */
@property (nonatomic, copy) NSString * descriptioN;
/**
 *  评论数
 */
@property (nonatomic, assign) NSString * commentNumber;
/**
 *   图片
 */
@property (nonatomic, copy) NSString * picname;
/**
 *  网页链接
 */
@property (nonatomic, copy) NSString * wapurl;
/**
 *  文章类型
 */
@property (nonatomic, copy) NSString * type;
/**
 *  判读是否收藏
 */
@property (nonatomic, copy) NSString * is_collection;

@end
