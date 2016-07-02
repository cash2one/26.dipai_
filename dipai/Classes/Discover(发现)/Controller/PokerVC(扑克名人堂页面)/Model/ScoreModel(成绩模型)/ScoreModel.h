//
//  ScoreModel.h
//  dipai
//
//  Created by 梁森 on 16/7/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface ScoreModel : NSObject<MJKeyValue>
/*
 "year":"2016/11/22",
 "Content":"啊实打实大"
 */

/**
*  时间
*/
@property (nonatomic, copy) NSString * year;
/**
 *  成绩
 */
@property (nonatomic, copy) NSString * Content;
@end
