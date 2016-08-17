//
//  LiveInfoModel.h
//  dipai
//
//  Created by 梁森 on 16/7/9.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveInfoModel : NSObject
/*
             "id":"7820",	// 直播ID
             "username":"laoma123",	// 直播员名字
             "imgs":{	// 图片
                 "pimg":"/public/upload/picname/146795544130025.jpg",
                 "pimg1":"/public/upload/picname/146795544130025.jpg",
                 "pimg2":"/public/upload/picname/146795544130025.jpg"
             },
 
             "body":"赛事赛事赛事赛事",// 内容
 
             "title":"赛事",// 标题
 
             "wapurl":

 */
/**
*  直播ID
*/
@property (nonatomic, copy) NSString * iD;
/**
 *  直播员姓名
 */
@property (nonatomic, copy) NSString * username;
/**
 *  大小图
 */
@property (nonatomic, copy) NSDictionary * imgs;
/**
 *  直播体
 */
@property (nonatomic, copy) NSString * body;
/**
 *  直播标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  分享链接
 */
@property (nonatomic, copy) NSString * wapurl;
@end




