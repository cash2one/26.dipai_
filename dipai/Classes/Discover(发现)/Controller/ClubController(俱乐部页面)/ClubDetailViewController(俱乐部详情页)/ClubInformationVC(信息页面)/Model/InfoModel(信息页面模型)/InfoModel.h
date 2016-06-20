//
//  InfoModel.h
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface InfoModel : NSObject<MJKeyValue>
/*
 "id":"1981",
 "type":"8",
 "title":"北京扑克联盟",
 "shorttitle":"",
 "picname":"http://10.0.0.14:8081/uploads/picname/2015/10/1445400341WFt.jpg",
 "address":"北京市海淀区西四环八里庄中海商厦四层",
 "business_hours":"14：00—5：00",
 "telephone":"4008-321-331",
 "imgs":Array[14],
 "imgs_totalresult":14,
 "tags":Array[7],
 "rcd":"http://10.0.0.14:8080/app/club/rcd/8/1981",
 "comment":"http://10.0.0.14:8080/app/list_comment/1981/8",
 "relation":"http://10.0.0.14:8080/app/club/rel/8/1981"
 */
/**
*  俱乐部ID
*/
@property (nonatomic, copy) NSString * iD;
/**
 *  类型
 */
@property (nonatomic, copy) NSString * type;
/**
 *  俱乐部名称
 */
@property (nonatomic, copy) NSString * title;
/**
 *  <#Description#>
 */
@property (nonatomic, copy) NSString * shorttitle;
/**
 *  封面图
 */
@property (nonatomic, copy) NSString * picname;
/**
 *  地址
 */
@property (nonatomic, copy) NSString * address;
/**
 *  时间
 */
@property (nonatomic, copy) NSString * business_hours;
/**
 *  电话
 */
@property (nonatomic, copy) NSString * telephone;
/**
 *  图集中的图片
 */
@property (nonatomic, strong) NSArray * imgs;
/**
 *  图集中的图片数
 */
@property (nonatomic, copy) NSString * imgs_totalresult;
/**
 *   俱乐部的标签
 */
@property (nonatomic, strong) NSArray * tags;
/**
 *  推荐接口
 */
@property (nonatomic, copy) NSString * rcd;
/**
 *  评论接口
 */
@property (nonatomic, copy) NSString * comment;
/**
 *  新闻接口
 */
@property (nonatomic, copy) NSString * relation;
@end
