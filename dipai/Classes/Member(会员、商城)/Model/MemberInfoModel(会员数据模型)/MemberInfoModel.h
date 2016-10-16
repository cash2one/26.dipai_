//
//  MemberInfoModel.h
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberInfoModel : NSObject

/*
 "username": "孙悟空",	//用户名
 "face": "http://dipaiapp.replays.net/public/cache/user/14719214875620025_300.jpeg", //头像
 "count_integral": "0",  //积分总数
 */

@property (nonatomic, copy) NSString * username;

@property (nonatomic, copy) NSString * face;

@property (nonatomic, copy) NSString * count_integral;
@end
