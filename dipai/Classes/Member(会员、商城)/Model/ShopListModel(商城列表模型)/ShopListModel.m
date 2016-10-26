//
//  ShopListModel.m
//  dipai
//
//  Created by 梁森 on 16/10/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ShopListModel.h"
#import "ShopGoodsModel.h"
@implementation ShopListModel

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"data":[ShopGoodsModel class]};
}


@end
