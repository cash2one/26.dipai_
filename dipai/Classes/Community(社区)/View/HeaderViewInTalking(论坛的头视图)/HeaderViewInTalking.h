//
//  HeaderViewInTalking.h
//  dipai
//
//  Created by 梁森 on 16/6/22.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
// 论坛模型
@class ForumModel;
@class SectionModel;

@protocol HeaderViewInTalkingDelegate <NSObject>
// 跳转到某个版块
- (void)turnPageToSomeSectionWithURL:(NSString *)url andSectionModel:(SectionModel *)model;

@end

@interface HeaderViewInTalking : UIView

@property (nonatomic, assign) id <HeaderViewInTalkingDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame WithModel:(ForumModel *)model;

/**
 *  论坛模型
 */
@property (nonatomic, strong) ForumModel * forumModel;

@end
