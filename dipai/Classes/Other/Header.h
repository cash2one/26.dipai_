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
#define InformationURL @"http://10.0.0.14:8080/app/index/0/0/0"
// 注册接口
#define RegisterURL @"http://192.168.1.102:8080/app/register"

#define UserName @"username"
#define PassWord @"password"

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
#define Font9 [UIFont systemFontOfSize:9*IPHONE6_W_SCALE]
#define Font10 [UIFont systemFontOfSize:10*IPHONE6_W_SCALE]
#define Font11 [UIFont systemFontOfSize:11*IPHONE6_W_SCALE]
#define Font13 [UIFont systemFontOfSize:13*IPHONE6_W_SCALE]
#define Font14 [UIFont systemFontOfSize:14*IPHONE6_W_SCALE]
#define Font16 [UIFont systemFontOfSize:16*IPHONE6_W_SCALE]

// 颜色
#define ColorBlue [UIColor colorWithRed:0 / 255.f green:122 / 255.f blue:255 / 255.f alpha:0.6]
#define ColorBlack60 [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.6]
#define ColorBlack30 [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.3]
#define Color123 [UIColor colorWithRed:123 / 255.f green:123 / 255.f blue:123 / 255.f alpha:1]
#define Color153 [UIColor colorWithRed:153 / 255.f green:153 / 255.f blue:153 / 255.f alpha:1]
#define Color216 [UIColor colorWithRed:216 / 255.f green:216 / 255.f blue:216 / 255.f alpha:1]
#define Color237 [UIColor colorWithRed:237 / 255.f green:237 / 255.f blue:237 / 255.f alpha:1]
#define Color238 [UIColor colorWithRed:238 / 255.f green:238 / 255.f blue:238 / 255.f alpha:1]
#define Color239 [UIColor colorWithRed:239 / 255.f green:239 / 255.f blue:239 / 255.f alpha:1]
#define Color178 [UIColor colorWithRed:178 / 255.f green:178 / 255.f blue:178 / 255.f alpha:1]
#define Color183 [UIColor colorWithRed:183 / 255.f green:183 / 255.f blue:183 / 255.f alpha:1]
#define Color255 [UIColor colorWithRed:255 / 255.f green:255 / 255.f blue:255 / 255.f alpha:1]

// 单元格上图片距离边距
#define InfoCellPicLeft 10
#define InfoCellPicTop 14
#define InfoCellPicWidth 186 / 2
#define InfoCellPicHeight 140 / 2
// 距离
#define Margin10 10 / 2
#define Margin14 14 / 2
#define Margin15 15 / 2
#define Margin16 16 / 2
#define Margin19 19 / 2
#define Margin20 20 / 2
#define Margin22 22 / 2
#define Margin23 23 / 2
#define Margin24 24 / 2
#define Margin25 25 / 2
#define Margin26 26 / 2
#define Margin27 27 / 2
#define Margin28 28 / 2
#define Margin30 30 / 2
#define Margin32 32 / 2
#define Margin33 33 / 2
#define Margin34 34 / 2
#define Margin35 35 / 2
#define Margin36 36 / 2
#define Margin39 39 / 2
#define Margin40 40 / 2
#define Margin42 42 / 2
#define Margin45 45 / 2
#define Margin46 46 / 2
#define Margin52 52 / 2
#define Margin58 58 / 2
#define Margin60 60 / 2
#define Margin64 64 / 2
#define Margin66 66 / 2
#define Margin70 70 / 2
#define Margin88 88 / 2
#define Margin92 92 / 2
#define Margin90 90 / 2
#define Margin109 109 / 2
#define Margin100 100 / 2
#define Margin101 101 / 2
#define Margin105 105 / 2
#define Margin118 118 / 2
#define Margin119 119 / 2
#define Margin156 156 / 2
#define Margin196 196 / 2
#define Margin168 168 / 2
#define Margin169 169 / 2
#define Margin188 188 / 2
#define Margin208 208 / 2
#define Margin224 224 / 2
#define Margin242 242 / 2
#define Margin270 270 / 2
#define Margin302 302 / 2
#define Margin306 306 / 2
#define Margin321 321 / 2
#define Margin376 376 / 2
#define Margin430 430 / 2
#define Margin460 460 / 2
#define Margin540 540 / 2
#define Margin574 574 / 2


#endif /* Header_h */
