//
//  Header.h
//  dipai
//
//  Created by 梁森 on 16/4/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#ifndef Header_h
#define Header_h
/******************资讯页接口********************/
// http://10.0.0.14:8080
#define InformationURL @"http://dipaiapp.replays.net/app/index/0/0/0"
//#define InformationURL @"http://10.0.0.14:8080/app/index/0/0/0"
// 注册接口
#define RegisterURL @"http://dipaiapp.replays.net/app/register"
//#define RegisterURL @"http://10.0.0.14:8080/app/register"
// 登录接口
#define LoginURL @"http://dipaiapp.replays.net/app/login"
//#define LoginURL @"http://10.0.0.14:8080/app/login"
// 评论列表接口
#define CommentsURL @"http://dipaiapp.replays.net/app/list_comment"
//#define CommentsURL @"http://10.0.0.14:8080/app/list_comment"
// 发表评论接口
#define SendComment @"http://dipaiapp.replays.net/app/add_comment"
//#define SendComment @"http://10.0.0.14:8080/app/add_comment"
// 收藏接口
#define CollectionURL @"http://dipaiapp.replays.net/app/collection"
//#define CollectionURL @"http://10.0.0.14:8080/app/collection"

/********************发现页接口********************/
// 发现首页接口
#define FindURL @"http://dipaiapp.replays.net/app/find"
//#define FindURL @"http://10.0.0.14:8080/app/find"
// 热门专辑中获取更多专辑的接口
#define MoreVideosURL @"http://dipaiapp.replays.net/app/hot/album/list"
//#define MoreVideosURL @"http://10.0.0.14:8080/app/hot/album/list"
// 专辑页面获取更多视频
#define AlbumURL @"http://dipaiapp.replays.net/app/album/list"
//#define AlbumURL @"http://10.0.0.14:8080/app/album/list"
/***俱乐部***/
// 获取所有城市接口
#define CityURL @"http://dipaiapp.replays.net/app/club/list/7"
//#define CityURL @"http://10.0.0.14:8080/app/club/list/7"
// 获取城市的所有俱乐部的接口
#define ClubsInCity @"http://dipaiapp.replays.net/app/club/list/8"
//#define ClubsInCity @"http://10.0.0.14:8080/app/club/list/8"


//#define UserName @"username"
//#define PassWord @"password"
#define Cookie @"cookie"
#define VideoUrl @"videourl"
#define User @"userModel"

// 判断设备型号
#define IS_IPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector: @selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE6_W_SCALE [UIScreen mainScreen].bounds.size.width / 375.0
#define IPHONE6_H_SCALE [UIScreen mainScreen].bounds.size.height / 667.0
//#define IPHONE6_H_SCALE IPHONE6_W_SCALE

// 屏幕的宽高
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define SPWidth WIDTH / 37.5
#define Height126  HEIGHT/1.26

#define LSKeyWindow [UIApplication sharedApplication].keyWindow

// tabBar
#define TabBarItemSelectedColor [UIColor colorWithRed:228 / 255.f green:0 / 255.f blue:0 / 255.f alpha:1]
#define TabBarItemSelectedFont [UIFont systemFontOfSize:10]
#define TabBarItemNormalColor [UIColor colorWithRed:255 / 255.f green:255 / 255.f blue:255 / 255.f alpha:1]
#define TabBarItemNormalFont [UIFont systemFontOfSize:10]
#define TabBarBackGroundColor [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.79]

// navigationBar
#define NavigationBarTitleColor [UIColor colorWithRed:255 / 255.f green:255 / 255.f blue:255 / 255.f alpha:1]
#define NavigationBarTitleFont [UIFont systemFontOfSize:18]

// 轮播页的高度
#define HeaderViewHeight 370 * 0.5
// 轮播页上label的高度
#define LabelHeight 64 * 0.5
// 轮播页上按钮的tag值
#define ButtonTag 100
#define ImageViewTag 200

// 字体大小 运用了字体的适配
#define Font8 [UIFont systemFontOfSize:8*IPHONE6_W_SCALE]
#define Font9 [UIFont systemFontOfSize:9*IPHONE6_W_SCALE]
#define Font10 [UIFont systemFontOfSize:10*IPHONE6_W_SCALE]
#define Font11 [UIFont systemFontOfSize:11*IPHONE6_W_SCALE]
#define Font12 [UIFont systemFontOfSize:12*IPHONE6_W_SCALE]
#define Font13 [UIFont systemFontOfSize:13*IPHONE6_W_SCALE]
#define Font14 [UIFont systemFontOfSize:14*IPHONE6_W_SCALE]
#define Font15 [UIFont systemFontOfSize:15*IPHONE6_W_SCALE]
#define Font16 [UIFont systemFontOfSize:16*IPHONE6_W_SCALE]
#define Font17 [UIFont systemFontOfSize:17*IPHONE6_W_SCALE]
#define Font20 [UIFont systemFontOfSize:20*IPHONE6_W_SCALE]

// 颜色
#define ColorBlue [UIColor colorWithRed:0 / 255.f green:122 / 255.f blue:255 / 255.f alpha:0.6]
#define ColorBlack60 [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.6]
#define ColorBlack30 [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.3]
#define Color102 [UIColor colorWithRed:102 / 255.f green:102 / 255.f blue:102 / 255.f alpha:1]
#define Color123 [UIColor colorWithRed:123 / 255.f green:123 / 255.f blue:123 / 255.f alpha:1]
#define Color153 [UIColor colorWithRed:153 / 255.f green:153 / 255.f blue:153 / 255.f alpha:1]
#define Color216 [UIColor colorWithRed:216 / 255.f green:216 / 255.f blue:216 / 255.f alpha:1]
#define Color237 [UIColor colorWithRed:237 / 255.f green:237 / 255.f blue:237 / 255.f alpha:1]
#define Color238 [UIColor colorWithRed:238 / 255.f green:238 / 255.f blue:238 / 255.f alpha:1]
#define Color239 [UIColor colorWithRed:239 / 255.f green:239 / 255.f blue:239 / 255.f alpha:1]
#define Color178 [UIColor colorWithRed:178 / 255.f green:178 / 255.f blue:178 / 255.f alpha:1]
#define Color183 [UIColor colorWithRed:183 / 255.f green:183 / 255.f blue:183 / 255.f alpha:1]
#define Color229 [UIColor colorWithRed:229 / 255.f green:229 / 255.f blue:229 / 255.f alpha:1]
#define Color255 [UIColor colorWithRed:255 / 255.f green:255 / 255.f blue:255 / 255.f alpha:1]
#define Color248 [UIColor colorWithRed:248 / 255.f green:248 / 255.f blue:248 / 255.f alpha:1]

// 单元格上图片距离边距
#define InfoCellPicLeft 10
#define InfoCellPicTop 14
#define InfoCellPicWidth 186 * 0.5
#define InfoCellPicHeight 140 * 0.5
// 距离
#define Margin10 10 * 0.5
#define Margin14 14 * 0.5
#define Margin15 15 * 0.5
#define Margin16 16 * 0.5
#define Margin19 19 * 0.5
#define Margin20 20 * 0.5
#define Margin22 22 * 0.5
#define Margin23 23 * 0.5
#define Margin24 24 * 0.5
#define Margin25 25 * 0.5
#define Margin26 26 * 0.5
#define Margin27 27 * 0.5
#define Margin28 28 * 0.5
#define Margin30 30 * 0.5
#define Margin32 32 / 2
#define Margin33 33 * 0.5
#define Margin34 34 * 0.5
#define Margin35 35 * 0.5
#define Margin36 36 * 0.5
#define Margin39 39 * 0.5
#define Margin40 40 * 0.5
#define Margin42 42 * 0.5
#define Margin45 45 * 0.5
#define Margin46 46 * 0.5
#define Margin52 52 * 0.5
#define Margin58 58 * 0.5
#define Margin60 60 * 0.5
#define Margin64 64 * 0.5
#define Margin66 66 * 0.5
#define Margin70 70 * 0.5
#define Margin88 88 * 0.5
#define Margin92 92 * 0.5
#define Margin90 90 * 0.5
#define Margin109 109 * 0.5
#define Margin100 100 * 0.5
#define Margin101 101 * 0.5
#define Margin105 105 * 0.5
#define Margin118 118 * 0.5
#define Margin119 119 * 0.5
#define Margin156 156 * 0.5
#define Margin196 196 * 0.5
#define Margin168 168 * 0.5
#define Margin169 169 * 0.5
#define Margin188 188 * 0.5
#define Margin208 208 * 0.5
#define Margin224 224 * 0.5
#define Margin242 242 * 0.5
#define Margin270 270 * 0.5
#define Margin302 302 * 0.5
#define Margin306 306 * 0.5
#define Margin321 321 * 0.5
#define Margin376 376 * 0.5
#define Margin430 430 * 0.5
#define Margin460 460 * 0.5
#define Margin540 540 * 0.5
#define Margin574 574 * 0.5


#endif /* Header_h */
