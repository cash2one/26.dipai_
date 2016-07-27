//
//  SpecialDetailModel.h
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface SpecialDetailModel : NSObject<MJKeyValue>
/*
 "id": "4380",
 "title": "如何在大型比赛中保护个人权益？《肆》",(标题)
 "shorttitle": "如何在大型赛事保护个人权益《肆》",（短标题）
 "commentNumber": "0",（评论数量）
 "picname": "http://dipaiadmin.replays.net/uploads/picname/2015/06/1434614353pRu.png",（图片）
 "description": "神秘人物No Name，他是谁？",（介绍）
 "url":
 */

/**
*  文章ID
*/
@property (nonatomic, copy) NSString * iD;
/**
 *  文章标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  文章短标题
 */
@property (nonatomic, copy) NSString * shorttitle;
/**
 *  文章评论数
 */
@property (nonatomic, copy) NSString * commentNumber;
/**
 *  文章的图片
 */
@property (nonatomic, copy) NSString * picname;
// 文章图片
@property (nonatomic, strong) NSDictionary * covers;
/**
 *  文章详情页链接
 */
@property (nonatomic, copy) NSString * url;
@end
