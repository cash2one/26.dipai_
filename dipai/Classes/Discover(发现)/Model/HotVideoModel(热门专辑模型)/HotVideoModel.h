//
//  HotVideoModel.h
//  dipai
//
//  Created by 梁森 on 16/6/12.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface HotVideoModel : NSObject<MJKeyValue>
/*
"id":"5102",
 
"type":"10",
 
"title":"啊实打实的1111",
 
"picname":
 
"wapurl":
 */
/**
*  视频ID
*/
@property (nonatomic, copy) NSString * iD;
/**
 *  视频类型
 */
@property (nonatomic, copy) NSString * type;
/**
 *  视频标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  视频封面图片
 */
@property (nonatomic, copy) NSString * picname;
/**
 *  跳转接口
 */
@property (nonatomic, copy) NSString * wapurl;

@end
