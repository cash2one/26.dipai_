//
//  MemberDataModel.m
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MemberDataModel.h"
#import "PlatformModel.h"
@implementation MemberDataModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list":[PlatformModel class]};
}

@end
