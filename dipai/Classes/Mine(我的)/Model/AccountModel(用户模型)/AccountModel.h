//
//  AccountModel.h
//  dipai
//
//  Created by 梁森 on 16/7/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface AccountModel : NSObject<MJKeyValue>
/*
 face = "";
 phone = 18730602430;
 userid = 22;
 username = Liangsen226;
 */
/**
*  头像
*/
@property (nonatomic, copy) NSString * face;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString * phone;
/**
 *  用户ID
 */
@property (nonatomic, copy) NSString * userid;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString * username;
/**
 *  判断用户是否可以修改名称 0:不可以  1:可以修改
 */
@property (nonatomic, copy) NSString * up_state;
@end
