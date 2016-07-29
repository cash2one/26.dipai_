//
//  DataLiveModel.h
//  dipai
//
//  Created by 梁森 on 16/7/27.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataLiveModel : NSObject
/**
 *  牌局信息
 */
@property (nonatomic, strong) NSArray * data;
/**
 *  赛事头信息
 */
@property (nonatomic, strong) NSDictionary * live;

@end
