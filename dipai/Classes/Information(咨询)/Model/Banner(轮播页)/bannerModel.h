//
//  bannerModel.h
//  dipai
//
//  Created by 梁森 on 16/5/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface bannerModel : NSObject<MJKeyValue>
/**
*  轮播页上的图片
*/
@property (nonatomic, copy) NSString * picname;
/**
 *  轮播页的标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  跳转链接
 */
@property (nonatomic, copy) NSString * url;
@end
