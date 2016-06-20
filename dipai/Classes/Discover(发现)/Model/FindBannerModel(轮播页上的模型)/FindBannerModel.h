//
//  FindBannerModel.h
//  dipai
//
//  Created by 梁森 on 16/6/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface FindBannerModel : NSObject<MJKeyValue>
/*
 "picname":"http://dipaiadmin.replays.net/uploads/imgs/2016/03/1458289601xMM.jpg",
 "type":"11",
 "id":"4892",
 "title":"EPT11蒙特卡洛年终总决赛01",
 "wapurl":"
 */

/**
 *  封面图片
 */
@property (nonatomic, copy) NSString * picname;
/**
 *  文章类型
 */
@property (nonatomic, copy) NSString * type;
/**
 *  文章ID
 */
@property (nonatomic, copy) NSString * iD;
/**
 *  文章标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  文章详情页接口
 */
@property (nonatomic, copy) NSString * wapurl;

@end
