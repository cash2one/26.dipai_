//
//  MatchingModel.m
//  dipai
//
//  Created by 梁森 on 16/6/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MatchingModel.h"
#import "LiveModel.h"
@implementation MatchingModel
// 解决字典中key和关键字同名的问题
+ (NSDictionary *)replacedKeyFromPropertyName

{
    
    return @{@"iD" : @"id"};
    
}
+ (NSDictionary *)objectClassInArray
{
    return @{@"app_live":[LiveModel class]};
}
@end
