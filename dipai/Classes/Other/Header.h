//
//  Header.h
//  dipai
//
//  Created by 梁森 on 16/4/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#ifndef Header_h
#define Header_h
// 接口
#define InformationURL @"http://192.168.1.111:8080/app/index/0/10/1"

#define IPHONE6_W_SCALE [UIScreen mainScreen].bounds.size.width / 375
#define IPHONE6_H_SCALE [UIScreen mainScreen].bounds.size.height / 667
//#define IPHONE6P_W_SCALE [UIScreen mainScreen].bounds.size.width / 414
//#define IPHONE6P_H_SCALE [UIScreen mainScreen].bounds.size.height / 736
// 屏幕的宽高
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

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
#define HeaderViewHeight 370 / 2
// 轮播页上label的高度
#define LabelHeight 64 / 2
// 轮播页上按钮的tag值
#define ButtonTag 100
#define ImageViewTag 200

// 字体大小 运用了字体的适配
#define Font16 [UIFont systemFontOfSize:16*IPHONE6_W_SCALE]
#define Font13 [UIFont systemFontOfSize:13*IPHONE6_W_SCALE]
#define Font10 [UIFont systemFontOfSize:10*IPHONE6_W_SCALE]

// 颜色
#define Color123 [UIColor colorWithRed:123 / 255.f green:123 / 255.f blue:123 / 255.f alpha:1]
#define Color238 [UIColor colorWithRed:238 / 255.f green:238 / 255.f blue:238 / 255.f alpha:1]
#define Color178 [UIColor colorWithRed:178 / 255.f green:178 / 255.f blue:178 / 255.f alpha:1]

// 单元格上图片距离边距
#define InfoCellPicLeft 10
#define InfoCellPicTop 14
#define InfoCellPicWidth 186 / 2
#define InfoCellPicHeight 140 / 2
// 距离
#define Margin10 10 / 2
#define Margin14 14 / 2
#define Margin19 19 / 2
#define Margin20 20 / 2
#define Margin24 24 / 2
#define Margin28 28 / 2
#define Margin30 30 / 2
#define Margin33 33 / 2
#define Margin36 36 / 2
#define Margin58 58 / 2
#define Margin196 196 / 2
#define Margin168 168 / 2
#define Margin224 224 / 2
#define Margin321 321 / 2


#endif /* Header_h */