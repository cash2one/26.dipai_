//
//  NumberDetailModel.h
//  dipai
//
//  Created by 梁森 on 16/10/28.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface NumberDetailModel : NSObject<MJKeyValue>

/*
 "type": "商城支出",		//类型 （获得积分）
 "extcredits1": "1",		//支出或者进账
 "extcredits2": "0",   	//余额
 "datetime": "2016-10-26",   //时间
 "content": "123"
 */

@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * extcredits1;
@property (nonatomic, copy) NSString * extcredits2;
@property (nonatomic, copy) NSString * datetime;
@property (nonatomic, copy) NSString * content;

@end
