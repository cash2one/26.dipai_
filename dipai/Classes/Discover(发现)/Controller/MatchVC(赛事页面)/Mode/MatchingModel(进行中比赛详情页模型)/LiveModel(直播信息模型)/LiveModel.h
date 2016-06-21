//
//  LiveModel.h
//  dipai
//
//  Created by 梁森 on 16/6/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface LiveModel : NSObject<MJKeyValue>
/*
             "name":"asd",	// 状态
             "wapurl":"http://dipaiapp.replays.net/app/club/live/5092/4"	// 直播接口

 */

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * wapurl;
@end
