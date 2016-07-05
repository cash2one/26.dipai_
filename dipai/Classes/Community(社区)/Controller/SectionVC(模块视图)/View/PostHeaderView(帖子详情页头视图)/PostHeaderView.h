//
//  PostHeaderView.h
//  dipai
//
//  Created by 梁森 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PostDaraModel;

@class PostHeaderView;
@protocol PostHeaderViewDelegate <NSObject>
// 点击头像的点击事件
- (void)PostHeaderView:(PostHeaderView *)headerView didClickFaceWith:(PostDaraModel *)model;

@end

@interface PostHeaderView : UIView

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) PostDaraModel * dataModel;

@property (nonatomic, copy) void (^changeTitleBlock) (CGFloat height);

@property (nonatomic, assign) id <PostHeaderViewDelegate> delegate;

- (instancetype)initWithArray:(NSArray *)array;
@end
