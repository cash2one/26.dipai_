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
@property (nonatomic, assign) int iD;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * descriptioN;
@property (nonatomic, assign) int comment;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, strong) NSArray * picname;

@end
