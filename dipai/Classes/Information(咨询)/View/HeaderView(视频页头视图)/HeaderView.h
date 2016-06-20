//
//  HeaderView.h
//  dipai
//
//  Created by 梁森 on 16/6/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

/**
 *  描述
 */
@property (nonatomic, strong) UILabel * descriptionLbl;
/**
 *  详细描述
 */
@property (nonatomic, strong) UILabel * summaryLbl;
/**
 *  展开图片
 */
@property (nonatomic, strong) UIImageView * openImage;
/**
 *  展开按钮
 */
@property (nonatomic, strong) UIButton * openBtn;

@property (nonatomic, copy) NSString * des;

@property (nonatomic, copy) NSString * summary;

@property (nonatomic, assign) CGFloat height;

- (void)setDes:(NSString *)des andSummary:(NSString *)summary;

@end
