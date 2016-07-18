//
//  CommentsView.h
//  dipai
//
//  Created by 梁森 on 16/6/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>



@class CommentsFrame;

@protocol CommentsViewDelegate <NSObject>
/**
 *  显示回复按钮
 */
- (void)showReplyBtnAndCheckBtn;
/**
 *  点击头像
 */
- (void)didClickFace;

@end

@interface CommentsView : UIView

@property (nonatomic, strong) CommentsFrame * commentsFrame;

@property (nonatomic, assign) id<CommentsViewDelegate> delegate;

@end
