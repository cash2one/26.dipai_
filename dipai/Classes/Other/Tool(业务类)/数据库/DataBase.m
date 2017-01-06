//
//  DataBase.m
//  dipai
//
//  Created by 梁森 on 16/5/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "DataBase.h"

#import "CoreData+MagicalRecord.h"
#import "NewsList.h"
#import "NewsListModel.h"
@implementation DataBase
+(void)setUpMagicalRecord
{
    // 对magicalRecord进行初始化
//    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"mydatabase.sqlite"];
}

//保存数据
+(void)saveLocation:(NewsListModel *)model
{
    // 创建一个实体
    NewsList * news = [NewsList MR_createEntity];
    news.iD = model.iD;
    news.type = model.type;
    news.title = model.title;
    news.shorttitle = model.shorttitle;
    news.commentNumber = model.commentNumber;
    news.covers = model.covers;
    news.url = model.url;
    // 存储
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

//查询全部
+(NSArray *)findAllTracks
{
    NSArray *arr = [NewsList MR_findAll];
    
    return arr;
}

//查询某个模型
+ (NSArray *)findTheTracks:(NSString *)uid
{
    NSArray * arr = [NewsList MR_findByAttribute:@"iD" withValue:uid];
    
    return arr;
}

//删除数据.
+(void)deleteTreacks:(NSString *)uid
{
    NSArray * arr = [NewsList MR_findByAttribute:@"iD" withValue:uid];
    for (NewsList *rec in arr) {
        [rec MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
