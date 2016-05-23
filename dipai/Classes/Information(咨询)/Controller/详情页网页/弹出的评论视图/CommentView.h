//
//  CommentView.h
//  dipai
//
//  Created by 梁森 on 16/5/19.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTextView.h"
@class CommentView;
@protocol CommentViewDelegate <NSObject>

- (void)commnetView:(CommentView *)commentView sendMessage:(NSString *)message;

@end

@interface CommentView : UIView
/**
 *  评论框
 */
@property (nonatomic, strong) LSTextView * textView;
/**
 *  发表按钮
 */
@property (nonatomic, strong) UIButton * sendBtn;
/**
 *  
 */
@property (nonatomic, assign) id <CommentViewDelegate> delegate;

@end
