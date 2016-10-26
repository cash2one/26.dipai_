//
//  PICircularProgressView.h
//  PICircularProgressView
//
//  Created by Dominik Alexander on 11.06.13.
//  Copyright (c) 2013 Dominik Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ProgressViewDelegate<NSObject>

-(void)startTouch;

@end

@interface PICircularProgressView : UIView

@property (nonatomic, assign) id<ProgressViewDelegate> delegate;

@property (nonatomic) double progress;
@property (nonatomic) int heart;

// Should be BOOLs, but iOS doesn't allow BOOL as UI_APPEARANCE_SELECTOR
@property (nonatomic) NSInteger showText UI_APPEARANCE_SELECTOR;
@property (nonatomic) NSInteger roundedHead UI_APPEARANCE_SELECTOR;
@property (nonatomic) NSInteger showShadow UI_APPEARANCE_SELECTOR;

@property (nonatomic) CGFloat thicknessRatio UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *innerBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *outerBackgroundColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *progressFillColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *progressTopGradientColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *progressBottomGradientColor UI_APPEARANCE_SELECTOR;

@property (nonatomic,strong) UIImageView *touchview;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIButton *startButton;


@property (nonatomic,strong) UILabel *healthLabel;//健康指数
@property (nonatomic,strong) UIImageView *triangleImageView;//下三角标志
@property (nonatomic,strong) UILabel *triangleLabel;//比较指数
@property (nonatomic,strong) UILabel *pointLabel;//分


@end
