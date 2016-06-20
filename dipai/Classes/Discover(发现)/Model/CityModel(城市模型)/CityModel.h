//
//  CityModel.h
//  dipai
//
//  Created by 梁森 on 16/6/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface CityModel : NSObject<MJKeyValue>
/*
 "id":"1696",
 "title":"北京"
 */
/**
*  城市ID
*/
@property (nonatomic, copy) NSString * iD;
/**
 *  城市名称
 */
@property (nonatomic, copy) NSString * title;
@end
