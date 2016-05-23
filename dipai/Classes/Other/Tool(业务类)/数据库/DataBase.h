//
//  DataBase.h
//  dipai
//
//  Created by 梁森 on 16/5/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDetailModel.h"
@class NewsListModel;
@interface DataBase : NSObject

//初始化
+(void)setUpMagicalRecord;

//保存数据
+(void)saveLocation:(NewsListModel *)model;

//查询全部
+(NSArray *)findAllTracks;

//查询某个模型
+ (NSArray *)findTheTracks:(NSString *)uid;;

//删除数据.
+(void)deleteTreacks:(NSString *)uid;

@end
