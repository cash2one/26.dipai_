//
//  FindBannerModel.m
//  dipai
//
//  Created by 梁森 on 16/6/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "FindBannerModel.h"

@implementation FindBannerModel

// 解决字典中key和关键字同名的问题
+ (NSDictionary *)replacedKeyFromPropertyName

{
    
    return @{@"iD" : @"id"};
    
}
@end
