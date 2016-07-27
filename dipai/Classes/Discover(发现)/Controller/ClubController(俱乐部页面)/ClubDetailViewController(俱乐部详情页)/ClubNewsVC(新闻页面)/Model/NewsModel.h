//
//  NewsModel.h
//  dipai
//
//  Created by 梁森 on 16/6/17.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface NewsModel : NSObject<MJKeyValue>
/*
 "id":"4900",
 "title":"北京扑克联盟“冠军杯”落下帷幕",
 "shorttitle":"北京扑克联盟“冠军杯”落下帷幕",
 "commentNumber":"0",
 "description":"会员“杰瑞”最终摘得桂冠并获得150,000积分的奖励",
 "picname":"http://10.0.0.14:8081/uploads/picname/2015/10/1445400341WFt.jpg",
 "wapurl":"
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
 *  文章标题
 */
@property (nonatomic, copy) NSString * shorttitle;
/**
 *  评论数
 */
@property (nonatomic, copy) NSString * commentNumber;
/**
 *  长标题
 */
@property (nonatomic, copy) NSString * descriptioN;
/**
 *  图片
 */
@property (nonatomic, copy) NSString * picname;
/**
 *  字典图片
 */
@property (nonatomic, strong) NSDictionary * covers;
/**
 *  跳转链接
 */
@property (nonatomic, copy) NSString * url;
@end
