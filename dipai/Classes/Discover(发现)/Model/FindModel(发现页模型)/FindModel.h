//
//  FindModel.h
//  dipai
//
//  Created by 梁森 on 16/6/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindModel : NSObject

/*
 banner":Array[4],
 "Navigation":Object{...},
 "Album":Object{...},
 "video":Object{...}
 }
 */
/**
*  轮播页
*/
@property (nonatomic, strong) NSArray * banner;
/**
 *  模块
 */
@property (nonatomic, strong) NSDictionary * navigation;
/**
 *  更多视频专辑
 */
@property (nonatomic, strong) NSDictionary * Album;
/**
 *  (WSOP)视频专辑
 */
@property (nonatomic, strong) NSArray * videoArr;

@end
