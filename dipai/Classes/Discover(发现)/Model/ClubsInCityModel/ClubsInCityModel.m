//
//  ClubsInCityModel.m
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ClubsInCityModel.h"
#import "ClubModel.h"
@implementation ClubsInCityModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"rows":[ClubModel class]};
}

@end
