//
//  AssociatedModel.h
//  dipai
//
//  Created by 梁森 on 16/6/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface AssociatedModel : NSObject<MJKeyValue>
/*
 "id":"5097",
 "type":"11",
 "title":"优酷",
 "commentNumber":"0",
 "covers":"/public/upload/video/146347763440025.png",
 "description":
 */
/**
 *  视频ID
 */
@property (nonatomic, copy) NSString * iD;
/**
 *  类型
 */
@property (nonatomic, copy) NSString * type;
/**
 *  标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  评论数
 */
@property (nonatomic, copy) NSString * commentNumber;
/**
 *  图片
 */
@property (nonatomic, copy) NSString * covers;
/**
 *  描述
 */
@property (nonatomic, copy) NSString * descriptioN;
/**
 *  视频播放地址
 */
@property (nonatomic, copy) NSString * videourl;
/**
 *  视频接口
 */
@property (nonatomic, copy) NSString * video_url;
@end
