//
//  InfoPara.h
//  dipai
//
//  Created by 梁森 on 16/5/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoPara : NSObject
/**
 *  请求的起始页
 */
@property (nonatomic, assign) int begain;
/**
 *  每页请求的页数
 */
@property (nonatomic, assign) int perpage;
/**
 *  版本号
 */
@property (nonatomic, copy) NSString * version;

@end
