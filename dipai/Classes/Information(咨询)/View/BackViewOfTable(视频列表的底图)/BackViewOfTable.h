//
//  BackViewOfTable.h
//  dipai
//
//  Created by 梁森 on 16/6/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackViewOfTable : UIView

@property (nonatomic, strong) UIView * contenView;

// 展示菜单，此菜单的大小是不固定的，因此需要传递rect
+ (instancetype)showWithRect:(CGRect)rect;
// 隐藏
+ (void)hide;
@end
