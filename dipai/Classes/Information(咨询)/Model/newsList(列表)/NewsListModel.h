//
//  NewsListModel.h
//  dipai
//
//  Created by 梁森 on 16/5/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"
@interface NewsListModel : NSObject<MJKeyValue>
/*
 "id": "5043",
 "type": "4",
 "title": "添加图集测试标题2",
 "description": "/public/upload/atlas/146189595570024.jpeg",
 "comment": 12,
 "url": "http://xxx.xxx/a/a",
 "picname": [
 "192.168.1.111/public/upload/atlas/146189595570024.jpeg",
 "/public/upload/atlas/146189594660024.jpg",
 "/public/upload/atlas/146189596190024.jpg"
 ]
 */
//
/**
 *  文章ID
 */
@property (nonatomic, copy) NSString * iD;
/**
 *  文章类型
    2:资讯
    4:图集
    11:视频
 */
@property (nonatomic, copy) NSString * type;
/**
 *  文章标题
 */
@property (nonatomic, copy) NSString * title;
/**
 *  文章的短标题
 */
@property (nonatomic, copy) NSString * shorttitle;
/**
 *  评论数
 */
@property (nonatomic, copy) NSString * commentNumber;
/**
 *  文章的描述
 */
@property (nonatomic, copy) NSString * descriptioN;
/**
 *  小图片
 */
@property (nonatomic, strong) NSMutableDictionary * covers;
/**
 *  跳转后页面接口
 */
@property (nonatomic, copy) NSString * url;


@end
