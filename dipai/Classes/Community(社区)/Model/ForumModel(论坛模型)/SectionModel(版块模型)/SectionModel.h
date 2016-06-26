//
//  SectionModel.h
//  dipai
//
//  Created by 梁森 on 16/6/22.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface SectionModel : NSObject<MJKeyValue>
/*
 "id":"3",
 "name":"自由",
 "picname":"",
 "wapurl":"
 */
/**
*  版块ID
*/
@property (nonatomic, copy) NSString * iD;
/**
 *  版块名称
 */
@property (nonatomic, copy) NSString * name;
/**
 *  版块图片
 */
@property (nonatomic, copy) NSString * picname;
/**
 *  版块详情链接
 */
@property (nonatomic, copy) NSString * wapurl;
@end
