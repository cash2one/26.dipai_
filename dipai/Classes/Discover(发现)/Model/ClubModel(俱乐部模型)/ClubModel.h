//
//  ClubModel.h
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface ClubModel : NSObject<MJKeyValue>
/*
 "id":"1981",
 "title":"北京扑克联盟",
 "type":"8",
 "picname":"http://10.0.0.14:8081/uploads/picname/2015/10/1445400341WFt.jpg",
 "address":"北京市海淀区西四环八里庄中海商厦四层",
 "wapurl":"
 */
/**
*  俱乐部ID
*/
@property (nonatomic, copy) NSString * iD;
/**
 *  俱乐部名称
 */
@property (nonatomic, copy) NSString * title;
/**
 *  类型
 */
@property (nonatomic, copy) NSString * type;
/**
 *  俱乐部封面图
 */
@property (nonatomic, copy) NSString * picname;
/**
 *  俱乐部地址
 */
@property (nonatomic, copy) NSString * address;
/**
 *  俱乐部详细内容接口
 */
@property (nonatomic, copy) NSString * wapurl;
@end
