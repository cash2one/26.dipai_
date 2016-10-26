//
//  ShopBannerModel.h
//  dipai
//
//  Created by 梁森 on 16/10/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface ShopBannerModel : NSObject<MJKeyValue>
/*
 "id":"1",
 "name":"黑寡妇离开家",
 "picname":"http://dipaiadmin.replays.net1",
 "address":"1",
 "sort":"1",
 "wapurl":
 */

@property (nonatomic, copy) NSString * iD;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * picname;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * sort;
@property (nonatomic, copy) NSString * wapurl;
@end
