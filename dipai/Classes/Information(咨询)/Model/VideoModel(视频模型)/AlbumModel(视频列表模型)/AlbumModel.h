//
//  AlbumModel.h
//  dipai
//
//  Created by 梁森 on 16/6/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface AlbumModel : NSObject<MJKeyValue>
/*
 "id":"4410",
 "title":"鲨鱼笼第二季01",
 "picname":"http://10.0.0.14:8081/uploads/picname/2016/01/1453807053frz.png",
 "wapurl":"http://10.0.0.14:8080/app/art/view/11/4410"
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
 *  图片
 */
@property (nonatomic, copy) NSString * picname;
/**
 *  视频播放地址
 */
@property (nonatomic, copy) NSString * videourl;
/**
 *  视频接口
 */
@property (nonatomic, copy) NSString * video_url;

@end
