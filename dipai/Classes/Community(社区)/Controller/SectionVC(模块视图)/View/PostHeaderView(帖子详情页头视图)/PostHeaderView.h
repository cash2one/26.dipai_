//
//  PostHeaderView.h
//  dipai
//
//  Created by 梁森 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PostDaraModel;
@interface PostHeaderView : UIView

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) PostDaraModel * dataModel;

@property (nonatomic, copy) void (^changeTitleBlock) (CGFloat height);

- (instancetype)initWithArray:(NSArray *)array;
@end
