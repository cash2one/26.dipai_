//
//  WSOPModel.h
//  dipai
//
//  Created by 梁森 on 16/6/17.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface WSOPModel : NSObject<MJKeyValue>
/*
 "label":"发现首页",
 "data":Array[1]
 */

/**
*  视频专辑的标题
*/
@property (nonatomic, copy) NSString * label;
/**
 *  视频专辑中的视频
 */
@property (nonatomic, strong) NSArray * data;
@end
