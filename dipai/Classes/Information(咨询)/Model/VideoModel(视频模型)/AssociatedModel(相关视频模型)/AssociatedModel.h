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
 
 
 "id":"7983",
 "type":"11",
 "title":"月坛杯决赛桌E06",
 "commentNumber":"0",
 "covers":"huploads/picname/2016/07/1469087790xgU.jpg",
 "description":"牌桌上还是四位选手，战斗依然激烈，不是你捅我一下，就是我给你一刀。比如大熊猫与林俭：ATs对KK,KK胜；KT与T9，KT胜，彼此你来我往",
 "videourl":"http://200001916.vod.myqcloud.com/200001916_fb3e72e84f1511e6840bb1a6d352044b.f230.av.m3u8",
 "url":"http://app.dipai.tv/app/art/view/11/7983"
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
//@property (nonatomic, copy) NSString * video_url;
@property (nonatomic, copy) NSString * url;
@end
