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

/********************发现页***************/
// 发现页模型
#import "FindModel.h"
// 发现页轮播页模型
#import "FindBannerModel.h"
// (模块)Navigation模型
#import "NavigationModel.h"
// 评论列表中的模型
#import "CommentsModel.h"
// 城市模型
#import "CityModel.h"
// 城市中的俱乐部模型
#import "ClubsInCityModel.h"
// 俱乐部信息页模型
#import "InfoModel.h"
// 类似WSOP视频专辑的模型
#import "WSOPModel.h"
// 俱乐部新闻页模型
#import "NewsModel.h"
// 赛事模型
#import "MatchModel.h"
// 结束的赛事模型
#import "EndMatchModel.h"
// 进行中比赛模型（详情页）
#import "MatchingModel.h"
// 直播信息模型
#import "LiveInfoModel.h"


// 扑克名人列表模型
#import "PokerListModel.h"
// 更多名人列表模型
#import "MorePokersModel.h"
// 名人主页模型
#import "SBModel.h"
// 回帖用户模型
#import "ReplyModel.h"
// 我的回复模型
#import "MyReplyModel.h"
/*****专题页模型*****/
#import "SpecialModel.h"
// 专题详情页模型
#import "SpecialDetailModel.h"

/******************社区*****************/
// 论坛模型
#import "ForumModel.h"
// 帖子模型
#import "PostsModel.h"
// 加了type的帖子模型
#import "TypePostModel.h"
// 帖子详情页模型
#import "PostDetailModel.h"

// 圈子模型
#import "GroupModel.h"
// 圈子返回数据模型
#import "CircleModel.h"

/*****************我的页*****************/
// 用户模型
#import "UserModel.h"
// 我收到的评论模型
#import "MyReceiveModel.h"
// 我的收藏模型
#import "MyCollectionModel.h"
// 账户模型
#import "AccountModel.h"



// 网页数据模型
#import "WebDetailModel.h"
// 视频页数据模型
#import "VideoModel.h"
// 热门专辑视频模型
#import "HotVideoModel.h"
// 视频专辑页面模型
#import "AlbumVideoModel.h"
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
        if (bannerModelArr != nil && tournamentModelArr != nil && newsListModelArr != nil) {
            [modelArr addObject:bannerModelArr];
            [modelArr addObject:tournamentModelArr];
            [modelArr addObject:newsListModelArr];
        }
        
        
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

+ (void)getDataInWebViewWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id ))success failure:(void (^)(NSError *))failure
{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) { // block是一个参数
        
        NSDictionary * dic = responseObject[@"content"];
        NSString * type = responseObject[@"type"];
        // 字典转模型
        WebDetailModel * webDetailModel = [WebDetailModel objectWithKeyValues:dic];
        
        NSMutableArray * arr = [NSMutableArray array];
        [arr addObject:webDetailModel];
        [arr addObject:type];
        
        if (success) {
            // block传递参数
            success(arr);
        }
        
        // 刷新表格
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

+ (void)postWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool POST:URLString parameters:parameters success:^(id responseObject) {
        
//        NSLog(@"%@", responseObject);
//        NSString * content = responseObject[@"content"];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取登录页面的数据
+ (void)getDataInLoginPageWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取评论列表的数据
+ (void)getCommentsListWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        
//        NSLog(@"%@", responseObject);
        
        NSArray * dataArr = [responseObject objectForKey:@"data"];
        // 字典数组转模型数据
        NSArray * commentsArr = [CommentsModel objectArrayWithKeyValuesArray:dataArr];
        
//        NSLog(@"%@",commentsArr);
        if (success) {
            success(commentsArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取视频的数据
+ (void)getVideoDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        // 要字典转模型
        NSDictionary * contentDic = [responseObject objectForKey:@"content"];
        // 将字典转成模型
        VideoModel * videoModel = [VideoModel objectWithKeyValues:contentDic];
        if (success) {
            success(videoModel);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 进行收藏
+ (void)getCollectWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

/***********************发现页接口**********************/
+ (void)getFindPageDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        // 轮播页的数组
        NSArray * bannerArr = [responseObject objectForKey:@"banner"];
        // 将字典数组转换成模型数组
        NSArray * bannerModelArr = [bannerModel objectArrayWithKeyValuesArray:bannerArr];
        
        // navigation(模块)
        NSDictionary * navigation = [responseObject objectForKey:@"Navigation"];
        // 字典转模型
//        NavigationModel * navigationModel = [NavigationModel objectWithKeyValues:navigation];
        
        // album
        NSMutableDictionary * albumDic = [NSMutableDictionary dictionary];
        albumDic = [responseObject objectForKey:@"Album"];
        
        // video   是一个数组，数组中装了各个视频专辑
        NSMutableArray * videoArr = [NSMutableArray array];
        videoArr = [responseObject objectForKey:@"video"];
        // 字典数组转模型数组
        NSArray * wsopModelArr = [WSOPModel objectArrayWithKeyValuesArray:videoArr];
        
        FindModel * findModel = [[FindModel alloc] init];
        // 轮播页
        findModel.banner = bannerModelArr;
        // 模块
        findModel.navigation = navigation;
        // 热门视频
        findModel.Album = albumDic;
        // WSOP视频(传递的应该是模型数组)
        findModel.videoArr = wsopModelArr;
        if (success) {
            success(findModel);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 获取更多内容页面的数据
+ (void)getMoreVideosWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
//        NSLog(@"获取更多内容页面:%@", responseObject);
        
        // 字典数组转模型数组
        NSArray * albumArr = [HotVideoModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if (success) {
            success(albumArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 获取更多内容页面的更多专辑数据
//+ (void)getMoreAlbumsInMorePageWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
//    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
//        
//        NSLog(@"获取更多内容页面:%@", responseObject);
//        
//        NSArray * array = responseObject;
//        
//        // 字典数组转模型数组
//        NSArray * albumArr = [HotVideoModel objectArrayWithKeyValuesArray:array];
//        
//        if (success) {
//            success(albumArr);
//        }
//    } failure:^(NSError *error) {
//        
//        if (failure) {
//            failure(error);
//        }
//    }];
//}

// 获取视频专辑页面的数据
+ (void)getAlbumDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        
//        NSLog(@"%@", responseObject);
        
        // 字典
        NSDictionary * albumDic = responseObject[@"album"];
        // 数组
        NSArray * videoArr = responseObject[@"video"];
        // 字典数组转模型数组
        NSArray * modelArr = [HotVideoModel objectArrayWithKeyValuesArray:videoArr];
        
//        NSLog(@"%@", modelArr);
        
        AlbumVideoModel * model = [[AlbumVideoModel alloc] init];
        model.albumDic = albumDic;
        model.videoArr = modelArr;
        
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 获取WSOP视频专辑中的视频
//+ (void)getWSOPDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
//    
//    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
//        
//        
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSError *error) {
//        
//        if (failure) {
//            failure(error);
//        }
//    }];
//}

// 获取视频专辑页面的数据
+ (void)getVideosInAlbumPageWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取城市数据
+ (void)getCitysDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        // 获取到的是一个城市数组
//        NSLog(@"%@", responseObject);
        NSArray * cityArr = responseObject[@"data"];
        // 字典数组转模型数组
        NSArray * cityModelArr = [CityModel objectArrayWithKeyValuesArray:cityArr];
        
        if (success) {
            success(cityModelArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取某市的所有俱乐部
+ (void)getClubsInCityWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        // 字典数组转模型数组
        NSArray * clubsModelArr = [ClubsInCityModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if (success) {
            success(clubsModelArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取某个俱乐部信息
+ (void)getClubInfoWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {

        
//        NSLog(@"%@", responseObject);
        // 字典转模型
        InfoModel * infoModel = [InfoModel objectWithKeyValues:responseObject[@"data"]];
        
        if (success) {
            success(infoModel);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 获取俱乐部新闻页数据
+ (void)getClubNewsDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        // 字典数组转模型数据
        NSArray * newsModelArr = [NewsModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (success) {
            success(newsModelArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取赛事列表
+ (void)getMatchDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        
//        NSLog(@"%@", responseObject);
        // 字典数组转模型数组
        NSArray * matchModelArr = [MatchModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        
        if (success) {
            success(matchModelArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取结束赛事列表
+ (void)getEndMatchDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        // 字典数组转模型数组
        NSArray * matchModelArr = [EndMatchModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if (success) {
            success(matchModelArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取赛事详情页数据
+ (void)getMatchDataInDetailWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
//        NSLog(@"%@", responseObject);
        // 字典转模型
        MatchingModel * model = [MatchingModel objectWithKeyValues:responseObject[@"data"]];
        
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取直播信息
+ (void)getLiveDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        // 字典数组转模型数组
        NSArray * modelArr = [LiveInfoModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (success) {
            success(modelArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 获取直播中的相关数据
+ (void)getRelationInLiveWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        // 字典数组转模型数组
        NSArray * modelArr = [NewsListModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (success) {
            success(modelArr);
        }
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
    }];
}


// 获取扑克名人堂列表数据
+ (void)getPokerListDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
//    NSLog(@"%@", URLString);
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSNull class]]) {
            if (success) {
                success(@"没有数据");
            }
        }else{
            NSArray * listArr = responseObject[@"data"][@"list"];
            
            NSArray * pokerListModelArr = [PokerListModel objectArrayWithKeyValuesArray:listArr];
            // 字典数组转模型数组
            if (success) {
                success(pokerListModelArr);
            }
        }
        
       
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 获取更多扑克名人数据
+ (void)getMorePokerDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        
        NSArray * dataArr = responseObject[@"data"];
        
        // 字典数组转模型数组
        NSArray * morePokersModelArr = [MorePokersModel objectArrayWithKeyValuesArray:dataArr];
        
        
        if (success) {
            success(morePokersModelArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 关注某人或取消对某人的关注
+ (void)PayAttentionOrCancleWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        // 字典数组转模型数组
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 获取某人主页数据
+ (void)getSBDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        // 发帖数组
        NSArray * app_myArr = responseObject[@"data"][@"app_my"];
        NSArray * comment = responseObject[@"data"][@"comment"];
        NSDictionary * data = responseObject[@"data"];
        NSString * userid = responseObject[@"userid"];
        // 字典数组转模型数组
        NSArray * postsModelArr = [PostsModel objectArrayWithKeyValuesArray:app_myArr];
        NSArray * replyModelArr = [ReplyModel objectArrayWithKeyValuesArray:comment];
        
        SBModel * sbModel = [[SBModel alloc] init];
        sbModel.app_my = postsModelArr;
        sbModel.comment = replyModelArr;
        sbModel.data = data;
        sbModel.userid = userid;
        
        if (success) {
            success(sbModel);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 获取更多帖子数据
+ (void)GetMorePostsDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
//        NSLog(@"%@", responseObject);
        
        // 发帖数组
        NSArray * app_myArr = responseObject[@"data"];
        // 字典数组转模型数组
        NSArray * postsModelArr = [PostsModel objectArrayWithKeyValuesArray:app_myArr];
                
        SBModel * sbModel = [[SBModel alloc] init];
        sbModel.app_my = postsModelArr;
        
        if (success) {
            success(sbModel);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取更多回复的数据
+ (void)getMoreReplysDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        // 发帖数组
        NSArray * replyArr = responseObject[@"data"];
        // 字典数组转模型数组
        NSArray * myReplyModelArr = [MyReplyModel objectArrayWithKeyValuesArray:replyArr];
        
        
        if (success) {
            success(myReplyModelArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

/******获取专题页数据*****/
+ (void)getSpecialDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
//        NSLog(@"%@", responseObject);
        NSArray * dataArr = responseObject[@"data"];
        
//        NSLog(@"%@", dataArr);
        
        // 字典数组转模型数组
        NSArray * specailModelArr = [SpecialModel objectArrayWithKeyValuesArray:dataArr];
        
//        NSLog(@"%@", specailModelArr);
        
        if (success) {
            success(specailModelArr);
        }
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
    }];
}
// 获取专辑详情页数据
+ (void)getSpecialDetailDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        
        NSArray * dateArr = responseObject[@"data"];
        // 字典数组转模型数组
        NSArray * speDeModelArr = [SpecialDetailModel objectArrayWithKeyValuesArray:dateArr];
        
        if (success) {
            success(speDeModelArr);
        }
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
    }];
}

/*******************论坛页***********************/
// 论坛首页
+ (void)getCommunityDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
//        NSLog(@"%@", responseObject);
        
        // 字典转模型
        ForumModel * forumModel = [ForumModel objectWithKeyValues:responseObject];
        if (success) {
            success(forumModel);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

//  获取评论列表
+ (void)getPostsDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        // 类型
        NSString * type = responseObject[@"type"];
        // 失败成功的标识
        NSString * state = responseObject[@"state"];
        
        // 帖子内容
        NSArray * dataArr = responseObject [@"data"];
        // 字典数组转模型数组
        NSArray * postsModelArr = [PostsModel objectArrayWithKeyValuesArray:dataArr];
        
        // 字典转模型
        TypePostModel * typePostModel = [[TypePostModel alloc] init];
        typePostModel.type = type;
        typePostModel.state = state;
        typePostModel.data = postsModelArr;
        typePostModel.forum_section = responseObject[@"forum_section"];
        
        if (success) {
            success(typePostModel);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 获取帖子详情页
+ (void)getPostDetailDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        
//        NSLog(@"%@", URLString);
//        NSLog(@"%@", responseObject);
        // 字典转模型
        PostDetailModel * detailModel = [PostDetailModel objectWithKeyValues:responseObject];
        if (success) {
            success(detailModel);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 获取帖子详情页中更多的回帖
+ (void)GetMoreReplyOfPostWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{

    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        // 字典数组转模型数组
        NSArray * modelArr = [ReplyModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (success) {
            success(modelArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取圈子页数据
+ (void)getGroupDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        CircleModel * cirModel = [[CircleModel alloc] init];
        
        // 字典数组转模型数组
        NSArray * dicArr = responseObject[@"data"];
        
        NSString * page = responseObject[@"page"];
//        NSLog(@"%@", dicArr);
        
        NSArray * groupModelArr = [GroupModel objectArrayWithKeyValuesArray:dicArr];
        
        cirModel.modelArr = groupModelArr;
        cirModel.page = page;
        
        if (success) {
            success(cirModel);
        }
        
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
    }];
}

/***************************我的页*******************/
// 获取个人中心的数据
+ (void)getPersonDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        
        NSLog(@"获取个人中心获取到的数据：%@", responseObject);
        // 字典转模型
        UserModel * userModel = [UserModel objectWithKeyValues:responseObject];
        
        if (success) {
            success(userModel);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
// 获取收藏的数据
+ (void)getCollectionDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
//        NSLog(@"%@", responseObject);
//        NSLog(@"%@", URLString);
//        NSLog(@"获取到收藏的数据：%@", responseObject);
        
        // 字典数组转模型数组
        NSArray * collectModelArr = [MyCollectionModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
//        NSMutableArray * arr = [NSMutableArray array];
//        [arr addObject:collectModelArr];
//        NSString * page = responseObject[@"page"];
//        [arr addObject:page];
        if (success) {
            success(collectModelArr);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

// 获取我的帖子
+ (void)getMyPostsDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{

    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        NSArray * dataArr = responseObject[@"data"];
        
        // 字典数组转模型数组
        NSArray * postModelArr = [PostsModel objectArrayWithKeyValuesArray:dataArr];
        
        if (success) {
            success(postModelArr);
        }
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
    }];
    
}
// 获取我的回复
+ (void)getMyReplysDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        NSLog(@"获取到回复的数据：%@", responseObject);
        // 发帖数组
        NSArray * replyArr = responseObject[@"data"];
        // 字典数组转模型数组
        NSArray * myReplyModelArr = [MyReplyModel objectArrayWithKeyValuesArray:replyArr];
        
        
        if (success) {
            success(myReplyModelArr);
        }
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
    }];
}

// 获取我收到的评论的数据
+ (void)getMyReceiveDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        // 字典数组转模型数组
       NSArray * receiveModelArr = [MyReceiveModel objectArrayWithKeyValuesArray:responseObject[@"data"]]  ;
        
        if (success) {
            success(receiveModelArr);
        }
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
    }];
}
// 删除收藏
+ (void)deleteMyCollectionWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{

    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
    }];
}
// 获取个人账户信息
+ (void)getAccountDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        
        NSLog(@"---%@", responseObject);
        
        // 字典转模型
        AccountModel * accountModel = [AccountModel objectWithKeyValues:responseObject[@"data"]];
        if (success) {
            success(accountModel);
        }
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
    }];
}

// 手机注册获取验证码
+ (void)getSecurityCodeWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        NSLog(@"%@", responseObject[@"content"]);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
    }];
}

// 向服务器发送获取的微信code
+ (void)sendCodeWithStr:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{

//    NSLog(@"%@", URLString);
    [HttpTool GET:URLString parameters:parameters success:^(id responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
    }];
}
@end











