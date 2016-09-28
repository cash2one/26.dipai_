//
//  ModelOfPoker.h
//  dipai
//
//  Created by 梁森 on 16/9/9.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface ModelOfPoker : NSObject<MJKeyValue>

/**
 *  牌谱的上传日期
 */
@property (nonatomic, copy) NSString * name;
/**
 *  某个日期下的牌谱信息
 */
@property (nonatomic, strong) NSArray * rows;


@end
