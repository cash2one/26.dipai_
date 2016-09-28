//
//  ModelOfPoker.m
//  dipai
//
//  Created by 梁森 on 16/9/9.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ModelOfPoker.h"
#import "ModelInPoker.h"
@implementation ModelOfPoker

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"rows":[ModelInPoker class]};
}

@end
