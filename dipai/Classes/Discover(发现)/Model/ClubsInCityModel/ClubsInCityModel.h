//
//  ClubsInCityModel.h
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface ClubsInCityModel : NSObject<MJKeyValue>
/*
 "name":"北京",
 "eid":"1696",
 "rows":Array[4],
 "count":4
 */
/**
*  城市名称
*/
@property (nonatomic, copy) NSString * name;
/**
 *  城市ID
 */
@property (nonatomic, copy) NSString * eid;
/**
 *  城市中的俱乐部
 */
@property (nonatomic, strong) NSArray * rows;
/**
 *  俱乐部个数
 */
@property (nonatomic, copy) NSString * count;
@end
