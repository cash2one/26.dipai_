//
//  MorePokersModel.h
//  dipai
//
//  Created by 梁森 on 16/6/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface MorePokersModel : NSObject<MJKeyValue>
/*
             "userid":"25",
 
             "username":"Nick",
 
             "face":"http://dipaiadmin.replays.net",
 
             "title":"NickNickNick",
 
             "brief":"NickNickNickNick",
 
             "relation":"0",
 
             "userurl":"http://dipaiapp.replays.net/app/user_space/25"

 */
/**
*  名人ID
*/
@property (nonatomic, copy) NSString * userid;
/**
 *  名人名字
 */
@property (nonatomic, copy) NSString * username;
/**
 *  名人头像
 */
@property (nonatomic, copy) NSString * face;
/**
 *  名人标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  名人简介
 */
@property (nonatomic, copy) NSString * brief;
/**
 *  0:未关注／1:已关注/2:互相关注
 */
@property (nonatomic, copy) NSString * relation;
/**
 *  名人页接口
 */
@property (nonatomic, copy) NSString * userurl;
@end
