//
//  ModelInPoker.h
//  dipai
//
//  Created by 梁森 on 16/9/9.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface ModelInPoker : NSObject<MJKeyValue>

/**
 *  牌谱ID
 */
@property (nonatomic, copy) NSString * iD;
/**
 *  牌谱地址
 */
@property (nonatomic, copy) NSString * picname;

@end
