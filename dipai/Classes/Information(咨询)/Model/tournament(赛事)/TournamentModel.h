//
//  TournamentModel.h
//  dipai
//
//  Created by 梁森 on 16/5/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface TournamentModel : NSObject<MJKeyValue>
/**
 *  赛事图片
 */
@property (nonatomic, copy) NSString * cover;
/**
 *  文章标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  文章ID
 */
@property (nonatomic, copy) NSString * iD;
/**
 *  文章详情网址
 */
@property (nonatomic, copy) NSString * lurl;


@end
