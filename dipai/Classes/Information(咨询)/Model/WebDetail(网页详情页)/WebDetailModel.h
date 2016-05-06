//
//  WebDetailModel.h
//  dipai
//
//  Created by 梁森 on 16/5/5.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
// 第三方
#import "MJExtension.h"
@interface WebDetailModel : NSObject<MJKeyValue>
/*
 "id":5060,
 "title":"测试添加图集标题",
 "description":"测试图集描述",
 "comment":12,
 "picname":"/uploads/picname/2016/01/1453700760Iwh.png",
 "wapurl":"192.168.1.111:8080/app/art/view/html/4/5060"
 */
/**
*  ID 文章的唯一标识
*/
@property (nonatomic, strong) NSNumber * iD;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * descriptioN;
@property (nonatomic, assign) NSNumber * comment;
@property (nonatomic, copy) NSString * picname;
@property (nonatomic, copy) NSString * wapurl;
@end
