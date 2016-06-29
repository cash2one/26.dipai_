//
//  PokerListModel.h
//  dipai
//
//  Created by 梁森 on 16/6/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface PokerListModel : NSObject<MJKeyValue>
/*
 "cover":"http://dipaiadmin.replays.net/public/upload/atlas/146685507130025.jpg",
                 "userurl"
 */
/**
*  封面图
*/
@property (nonatomic, strong) NSString * cover;
/**
 *  用户详情页
 */
@property (nonatomic, strong) NSString * userurl;
@end
