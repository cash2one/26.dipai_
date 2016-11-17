//
//  MemberLevelModel.h
//  dipai
//
//  Created by 梁森 on 16/10/19.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface MemberLevelModel : NSObject<MJKeyValue>
/*
 "face": "http://dipaiapp.replays.net/public/cache/user/14719214875620025_300.jpeg",
 "rolename": "V0",      用户等级
 "count_integral": "0",  用户目前积分
 "score_end": "1000"   等级最高积分数
 */

@property (nonatomic, copy) NSString * face;

@property (nonatomic, copy) NSString * rolename;

@property (nonatomic, copy) NSString * count_integral;

@property (nonatomic, copy) NSString * score_end;
@end
