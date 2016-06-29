//
//  TypePostModel.h
//  dipai
//
//  Created by 梁森 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface TypePostModel : NSObject<MJKeyValue>
/*
 "type":"171",
 "state":"1",
 "data"
 */
/**
 *  版块类型
 */
@property (nonatomic, copy) NSString * type;
/**
 *  成功失败的标识
 */
@property (nonatomic, copy) NSString * state;
/**
 *  版块名称
 */
@property (nonatomic, copy) NSString * forum_section;
/**
 *  所有的帖子
 */
@property (nonatomic, strong) NSArray * data;
@end
