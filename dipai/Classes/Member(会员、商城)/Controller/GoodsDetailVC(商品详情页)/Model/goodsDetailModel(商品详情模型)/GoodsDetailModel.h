//
//  GoodsDetailModel.h
//  dipai
//
//  Created by 梁森 on 16/10/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailModel : NSObject
/*
 "goods_id":"1",
	        "goods_name":"123",	// 商品标题
	        "shop_price":"1",	// 商品价格
	        "goods_desc":"123123123",	// 商品描述
	        "goods_img":"http://dipaiadmin.replays.net/public/upload/picname/147677177040028.png",
         "atlas":[
 */

@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * goods_name;
@property (nonatomic, copy) NSString * shop_price;
@property (nonatomic, copy) NSString * goods_desc;
@property (nonatomic, copy) NSString * goods_img;
@property (nonatomic, strong) NSArray * atlas;

// 会员价格
@property (nonatomic, copy) NSString * vip_price;
@end
