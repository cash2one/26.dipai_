//
//  AssociatedModel.m
//  dipai
//
//  Created by 梁森 on 16/6/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AssociatedModel.h"

@implementation AssociatedModel

// 解决字典中key和关键字同名的问题
+ (NSDictionary *)replacedKeyFromPropertyName

{
    
    return @{@"iD" : @"id", @"descriptioN":@"description"};
    
}
@end
