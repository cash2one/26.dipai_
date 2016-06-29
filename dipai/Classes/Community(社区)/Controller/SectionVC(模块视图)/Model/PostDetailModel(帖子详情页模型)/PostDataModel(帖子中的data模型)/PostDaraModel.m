//
//  PostDaraModel.m
//  dipai
//
//  Created by 梁森 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "PostDaraModel.h"
#import "ReplyModel.h"
@implementation PostDaraModel
// 解决字典中key和关键字同名的问题
+ (NSDictionary *)replacedKeyFromPropertyName

{
    
    return @{@"iD" : @"id"};
    
}

+ (NSDictionary *)objectClassInArray{
    return @{@"comment":[ReplyModel class]};
}
@end
