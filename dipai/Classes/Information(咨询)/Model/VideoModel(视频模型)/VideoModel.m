//
//  VideoModel.m
//  dipai
//
//  Created by 梁森 on 16/6/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "VideoModel.h"

#import "AssociatedModel.h"
#import "AlbumModel.h"
@implementation VideoModel

// 解决字典中key和关键字同名的问题
+ (NSDictionary *)replacedKeyFromPropertyName

{
    
    return @{@"iD" : @"id", @"descriptioN":@"description"};
    
}
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"associated":[AssociatedModel class], @"album":[AlbumModel class]};
}
@end
