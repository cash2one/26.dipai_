//
//  MatchModel.m
//  dipai
//
//  Created by 梁森 on 16/6/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MatchModel.h"
#import "EndMatchModel.h"
@implementation MatchModel
// 解决字典中key和关键字同名的问题
+ (NSDictionary *)replacedKeyFromPropertyName

{
    
    return @{@"iD" : @"id"};
    
}
+ (NSDictionary *)objectClassInArray
{
    return @{@"rows":[EndMatchModel class]};
}

@end
