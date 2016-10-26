//
//  ShopMallModel.h
//  dipai
//
//  Created by 梁森 on 16/10/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface ShopMallModel : NSObject<MJKeyValue>

/**
 banner":Array[1],
 "list":
 */

// banner 图
@property (nonatomic, strong) NSArray * banner;
// 列表
@property (nonatomic, strong) NSArray * list;
@end
