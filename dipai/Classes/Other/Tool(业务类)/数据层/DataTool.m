//
//  DataTool.m
//  dipai
//
//  Created by 梁森 on 16/5/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "DataTool.h"
#import "HttpTool.h"
// 资讯模型
#import "InfomationModel.h"
// 首页的三个模型
#import "bannerModel.h"
#import "TournamentModel.h"
#import "NewsListModel.h"

// 网页数据模型
#import "WebDetailModel.h"

@implementation DataTool
#pragma mark --- 首页下拉刷新
+ (void)getNewDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) { // block是一个参数
        // 轮播页
        NSArray * bannerArr = responseObject[@"banner"];
        // 通过一个字典数组创建一个模型数组
        NSArray * bannerModelArr = [bannerModel objectArrayWithKeyValuesArray:bannerArr];
        // 赛事
        NSArray * tournamentArr = responseObject[@"rc"];
        NSArray * tournamentModelArr = [TournamentModel objectArrayWithKeyValuesArray:tournamentArr];
        // 列表
        NSArray * newsListArr = responseObject[@"newslist"];
        NSArray * newsListModelArr = [NewsListModel objectArrayWithKeyValuesArray:newsListArr];
        
        
        NSMutableArray * modelArr = [NSMutableArray array];
        [modelArr addObject:bannerModelArr];
        [modelArr addObject:tournamentModelArr];
        [modelArr addObject:newsListModelArr];
        
        if (success) {
            // block传递参数
            success(modelArr);
        }
        
        // 刷新表格
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}
#pragma mark --- 首页上拉加载
+ (void)getMoreDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) { // block是一个参数
        
        NSMutableArray * array = [NSMutableArray array];
        NSString * page = responseObject[@"page"];
        
        [array addObject:page];
        
        NSArray * newsListArr = responseObject[@"newslist"];
        NSArray * newsListModelArr = [NewsListModel objectArrayWithKeyValuesArray:newsListArr];
        [array addObject:newsListModelArr];

        if (success) {
            // block传递参数
            success(array);
        }
        
        // 刷新表格
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

+ (void)getDataInWebViewWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
\
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) { // block是一个参数
        
        NSDictionary * dic = responseObject[@"content"];
        // 字典转模型
        WebDetailModel * webDetailModel = [WebDetailModel objectWithKeyValues:dic];
        
        if (success) {
            // block传递参数
            success(webDetailModel);
        }
        
        // 刷新表格
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}
@end
