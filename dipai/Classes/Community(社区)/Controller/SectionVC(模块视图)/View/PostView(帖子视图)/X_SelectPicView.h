//
//  X_SelectPicView.h
//  dipai
//
//  Created by 梁森 on 16/6/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol X_SelectPicViewDelegate;

@interface X_SelectPicView : UIView

@property (nonatomic, weak) id<X_SelectPicViewDelegate>delegate;
/**
 *  数据源
 */
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) void(^Commplete)(void);

@property (nonatomic, copy) void(^GetMyPoker)(void);

+ (X_SelectPicView *)shareSelectPicView;

@end
@protocol X_SelectPicViewDelegate <NSObject>

- (void)didSelectPicView:(X_SelectPicView *)view atIndex:(NSInteger)index;

- (void)deletePicView:(X_SelectPicView *)view atIndex:(NSInteger)index;

- (void)didSelectPoker:(X_SelectPicView *)view;
// 图片位置发生变化的时候触发此方法
- (void)indexOfPicsChanged:(NSMutableArray *)imageArr;

@end