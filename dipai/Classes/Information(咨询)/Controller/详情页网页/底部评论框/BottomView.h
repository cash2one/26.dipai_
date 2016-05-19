//
//  BottomView.h
//  dipai
//
//  Created by 梁森 on 16/5/19.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>
/**
 *  写评论
 */
- (void)commentAction;
/**
 *  查看评论
 */
- (void)lookCommentsAction;
/**
 *  收藏
 */
- (void)collectionAction;
/**
 *  分享
 */
- (void)shareAction;

@end

@interface BottomView : UIView

/**
 *  评论数标签
 */
@property (nonatomic, strong) UILabel * commentsLbl;

/**
 *  收藏按钮
 */
@property (nonatomic, strong) UIButton * collectionBtn;

@property (nonatomic, assign) id <BottomViewDelegate> delegate;

@end







