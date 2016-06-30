//
//  DataTool.h
//  dipai
//
//  Created by 梁森 on 16/5/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataTool : NSObject
// 首页获取数据
// 获取新的数据
+ (void)getNewDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
// 获取更多数据
+ (void)getMoreDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

// 网页获取数据
+ (void)getDataInWebViewWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id ))success failure:(void (^)(NSError *))failure;

// 用户注册
+ (void)postWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

// 登录界面获取数据
+ (void)getDataInLoginPageWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 获取评论列表的数据
+ (void)getCommentsListWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 获取视频数据
+ (void)getVideoDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 进行收藏
+ (void)getCollectWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;


/***********************发现页接口**********************/
// 获取发现页首页数据
+ (void)getFindPageDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取更多内容页面的数据
+ (void)getMoreVideosWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 更多内容页面获取更多专辑的数据
+ (void)getMoreAlbumsInMorePageWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取某个视频专辑页面的数据
+ (void)getAlbumDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取WSOP视频专辑中的视频
+ (void)getWSOPDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取专辑页面下的数据
+ (void)getVideosInAlbumPageWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

/***俱乐部***/
// 获取城市数据
+ (void)getCitysDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取城市的所有俱乐部
+ (void)getClubsInCityWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取某个俱乐部的信息
+ (void)getClubInfoWithStr:(NSString * )URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 获取俱乐部新闻页的数据
+ (void)getClubNewsDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
/***赛事***/
// 获取赛事列表
+ (void)getMatchDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取结束的赛事列表
+ (void)getEndMatchDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取赛事详情页
+ (void)getMatchDataInDetailWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;


// 获取直播信息
+ (void)getLiveDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 获取扑克名人堂数据
+ (void)getPokerListDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取所有扑克名人堂数据
+ (void)getMorePokerDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 关注或取消关注某人
+ (void)PayAttentionOrCancleWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取用户的主页、发帖、回复等信息数据
+ (void)getSBDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取更多帖子数据
+ (void)GetMorePostsDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取更多回复的数据
+ (void)getMoreReplysDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

/*********************社区页******************/
// 获取论坛首页
+ (void)getCommunityDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取帖子列表
+ (void)getPostsDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 获取帖子详情页数据
+(void) getPostDetailDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;


/************************我的********************/
// 获取个人中心的数据
+ (void)getPersonDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取收藏的数据
+ (void)getCollectionDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
@end
