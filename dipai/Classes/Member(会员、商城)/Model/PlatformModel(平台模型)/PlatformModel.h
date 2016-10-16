//
//  PlatformModel.h
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlatformModel : NSObject
/*
 "name": "13123123", //平台名称
 "picname": "http://dipaiadmin.replays.net/public/upload/platform/147461011970028.jpg", //图片
 "weburl": "http://dipaiapp.replays.net/member/platform_address/1"	//绑定地址
 */

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * picname;

@property (nonatomic, copy) NSString * weburl;
@end
