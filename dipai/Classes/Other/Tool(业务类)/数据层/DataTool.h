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
// 获取直播中的相关
+ (void)getRelationInLiveWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

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

/********专题********/
// 获取专题
+ (void)getSpecialDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取专辑详情页数据
+ (void)getSpecialDetailDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;


/*********************社区页******************/
// 获取论坛首页
+ (void)getCommunityDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取帖子列表
+ (void)getPostsDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 获取帖子详情页数据
+(void) getPostDetailDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取帖子详情页中更多的回帖
+ (void)GetMoreReplyOfPostWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 获取圈子页数据
+ (void)getGroupDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;


/************************我的********************/
// 获取个人中心的数据
+ (void)getPersonDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取收藏的数据
+ (void)getCollectionDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 获取我的帖子
+ (void)getMyPostsDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取我的回复的数据
+ (void)getMyReplysDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取我收到的评论的数据
+ (void)getMyReceiveDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 删除收藏
+ (void)deleteMyCollectionWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取个人账户信息
+ (void)getAccountDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 手机注册获取验证码
+ (void)getSecurityCodeWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

//  向服务器发送获取的微信code
+ (void)sendCodeWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 获取我的牌谱
+ (void)getMyPokersWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

// 删除牌谱
+ (void)deletePokerWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;


/************************会员中心********************/
// 获取会员中心首页数据
+ (void)getMemberCenterDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取会员等级页面数据
+ (void)getMemberLevelDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取等级详情数据
+ (void)getDetailLevelDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取礼遇详情页
+ (void)getBenefitDetailDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取全部礼遇
+ (void)getAllBenefitsDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取积分支出／收入详情
+ (void)getDetailNumberDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

/************************积分商城********************/
// 获取商城首页数据
+ (void)getShoppingMallDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取更多商品数据
+ (void)getMoreGoodsDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取商品详细数据
+ (void)getGoodsDetailMessageWIthStr:(NSString * )URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取确认订单页面数据
+ (void)getOrderSureDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取所有地址列表数据
+ (void)getAllAddressDataWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 提交地址
+ (void)postAddressWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 添加默认地址
+ (void)addDefaultAddWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 提交订单
+ (void)submitOrderWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
// 获取我的订单数据
+ (void)getMyOrdersWithStr:(NSString *)URLString parameters:(id)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;
@end
