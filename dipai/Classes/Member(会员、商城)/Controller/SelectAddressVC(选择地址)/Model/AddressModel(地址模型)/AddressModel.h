//
//  AddressModel.h
//  dipai
//
//  Created by 梁森 on 16/10/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface AddressModel : NSObject<MJKeyValue>
/*
 "address_id": "1",		//id
 "address_name": "电饭锅电饭锅",	//名字
 "district": "北京",   		//区
 "address": "插上大师的", //详细地址
 "mobile": "1323132323"	//手机号
 "default":1, //1默认 0不选中
 */

@property (nonatomic, copy) NSString * address_id;
@property (nonatomic, copy) NSString * address_name;
@property (nonatomic, copy) NSString * district;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * defaultS;
@end
