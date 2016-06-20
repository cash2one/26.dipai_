//
//  HotVideoModel.m
//  dipai
//
//  Created by 梁森 on 16/6/12.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "HotVideoModel.h"

@implementation HotVideoModel
// 解决字典中key和关键字同名的问题
+ (NSDictionary *)replacedKeyFromPropertyName

{
    
    return @{@"iD" : @"id"};
    
}
@end
