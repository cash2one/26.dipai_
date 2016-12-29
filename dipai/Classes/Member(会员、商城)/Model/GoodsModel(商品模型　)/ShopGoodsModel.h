//
//  ShopGoodsModel.h
//  dipai
//
//  Created by 梁森 on 16/10/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface ShopGoodsModel : NSObject<MJKeyValue>
/*
 "goods_id":"1",
 "goods_name":"电饭锅电饭锅",
 "shop_price":"1",
 "goods_img":"http://dipaiadmin.replays.net/public/upload/picname/147677177040028.png",
 "wapurl":
 */

@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * goods_name;
@property (nonatomic, copy) NSString * shop_price;
@property (nonatomic, copy) NSString * goods_img;
@property (nonatomic, copy) NSString * wapurl;
// 会员价格
@property (nonatomic, copy) NSString * vip_price;
@end
