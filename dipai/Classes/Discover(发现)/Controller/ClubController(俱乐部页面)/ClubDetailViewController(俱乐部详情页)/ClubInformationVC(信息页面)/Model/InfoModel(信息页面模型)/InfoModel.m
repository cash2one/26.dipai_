//
//  InfoModel.m
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "InfoModel.h"
// 图集模型
#import "ImageModel.h"
// 标签模型
#import "labelModel.h"
@implementation InfoModel
// 解决字典中key和关键字同名的问题
+ (NSDictionary *)replacedKeyFromPropertyName

{
    
    return @{@"iD" : @"id"};
    
}// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"imgs":[ImageModel class],@"tags":[labelModel class] };
}
@end
