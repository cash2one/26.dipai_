//
//  MemberDataModel.h
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface MemberDataModel : NSObject<MJKeyValue>
/**
 *  会员信息
 */
@property (nonatomic, strong) NSDictionary * user_info;

/**
 *  平台列表
 */
@property (nonatomic, strong) NSArray * list;
// 为了绕过苹果审核添加的状态码
@property (nonatomic, copy) NSString * stype;

@end
