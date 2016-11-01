//
//  OrderModel.h
//  dipai
//
//  Created by 梁森 on 16/10/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface OrderModel : NSObject<MJKeyValue>
/*
 "order_id": "1",		//id
 "discount": "A4545555555",	//订单号
 "shipping_status": "1",   //状态 （0未发货,1已发货2.确认完成）
 "goods_name": "大师的", //商品名称
 "shop_price":"12", //积分
 "goods_img":
 */

@property (nonatomic, copy) NSString * order_id;
@property (nonatomic, copy) NSString * discount;
@property (nonatomic, copy) NSString * shipping_status;
@property (nonatomic, copy) NSString * goods_name;
@property (nonatomic, copy) NSString * shop_price;
@property (nonatomic, copy) NSString * goods_img;

@end
