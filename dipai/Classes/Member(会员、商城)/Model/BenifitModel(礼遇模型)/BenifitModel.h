//
//  BenifitModel.h
//  dipai
//
//  Created by 梁森 on 16/10/19.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface BenifitModel : NSObject<MJKeyValue>

/*
 "id": "1",
 "name": "大巴接送11", 礼遇名称
 "picname": "http://dipaiadmin.replays.net/public/upload/courtesy/147444980890028.jpg", 礼遇图标
 "wapurl": "http://dipaiapp.replays.net/app/view/courtesy/0/1"  礼遇详细地址
 */

@property (nonatomic, copy) NSString * iD;

@property (nonatomic, copy) NSString * name;
/*
 *礼遇图标
 */
@property (nonatomic, copy) NSString * picname;

@property (nonatomic, copy) NSString * wapurl;

@end
