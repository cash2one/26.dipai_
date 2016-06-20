//
//  VideoModel.h
//  dipai
//
//  Created by 梁森 on 16/6/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"
@interface VideoModel : NSObject<MJKeyValue>
/*
 "id":"5098",
 "title":"爱奇艺",
 "description":"爱奇艺",
 "summary":"爱奇艺",
 "commentNumber":"0",
 "picname":"http://10.0.0.14:8081/public/upload/video/146347787040025.png",
 "wapurl":null,
 "videourl":"http://200001916.vod.myqcloud.com/200001916_36e17000271d11e68b8d95dfe8e23354.f230.av.m3u8 ",
 "is_collection":"0",
 "associated":Array[2],
 "album"
 */
/**
*  视频ID
*/
@property (nonatomic, copy) NSString * iD;
/**
 *  视频标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  视频描述
 */
@property (nonatomic, copy) NSString * descriptioN;
/**
 *  视频详细描述
 */
@property (nonatomic, copy) NSString * summary;
/**
 *  评论数
 */
@property (nonatomic, copy) NSString * commentNumber;
/**
 *  图片
 */
@property (nonatomic, copy) NSString * picname;
/**
 *  <#Description#>
 */
@property (nonatomic, copy) NSString * wapurl;
/**
 *  视频播放地址
 */
@property (nonatomic, copy) NSString * videourl;
/**
 *  判断是否收藏 0:没有收藏 1:收藏
 */
@property (nonatomic, copy) NSString * is_collection;
/**
 *  相关视频
 */
@property (nonatomic, strong) NSArray * associated;
/**
 *  视频列表
 */
@property (nonatomic, strong) NSArray * album;
@end
