//
//  NewsListModel.m
//  dipai
//
//  Created by 梁森 on 16/5/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NewsListModel.h"

#import "PhotoModel.h"
@implementation NewsListModel
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
//+ (NSDictionary *)objectClassInArray
//{
//    return @{@"picname":[PhotoModel class]};
//}

// 解决字典中key和关键字同名的问题
+ (NSDictionary *)replacedKeyFromPropertyName

{
    
    return @{@"iD" : @"id", @"descriptioN":@"description"};
    
}
@end
