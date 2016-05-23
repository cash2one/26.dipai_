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
 "id":5060,
 "title":"测试添加图集标题",
 "description":"测试图集描述",
 "comment":12,
 "picname":"/uploads/picname/2016/01/1453700760Iwh.png",
 "wapurl":"192.168.1.111:8080/app/art/view/html/4/5060"
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


@end
