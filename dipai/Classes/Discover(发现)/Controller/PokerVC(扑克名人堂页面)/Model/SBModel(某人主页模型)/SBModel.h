//
//  SBModel.h
//  dipai
//
//  Created by 梁森 on 16/6/30.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface SBModel : NSObject<MJKeyValue>
/*
 "is_follow":"0",
 "info":Object{...},
 "certified":Object{...},
 "app_my":Array[10],
 "comment":null,
 "relevant":null
 */

/**
 *  用户ID
 */
@property (nonatomic, copy) NSString * userid;
/**
*  我的发帖
*/
@property (nonatomic, strong) NSArray * app_my;
/**
 *  我的回复
 */
@property (nonatomic, strong) NSArray * comment;
/**
 *  名人数据
 */
@property (nonatomic, strong) NSDictionary * data;
@end
