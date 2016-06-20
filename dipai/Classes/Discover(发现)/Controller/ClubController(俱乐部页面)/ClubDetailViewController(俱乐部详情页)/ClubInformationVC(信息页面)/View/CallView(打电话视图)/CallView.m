//
//  CallView.m
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CallView.h"

#import "Masonry.h"
@interface CallView()


@end

@implementation CallView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        // 设置子控件
        [self setUpChildControl];
    }
    
    return self;
}
#pragma mark --- 设置子控件
- (void)setUpChildControl{
    
    // 呼叫
    UILabel * callLbl = [[UILabel alloc] init];
//    callLbl.backgroundColor = [UIColor redColor];
    callLbl.textAlignment = NSTextAlignmentCenter;
    callLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    callLbl.text = @"呼叫";
    [self addSubview:callLbl];
    _callLbl = callLbl;
    
    // 电话号码
    UILabel * numLbl = [[UILabel alloc] init];
//    numLbl.backgroundColor = [UIColor redColor];
    numLbl.text = @"18730602439";
    numLbl.textAlignment = NSTextAlignmentCenter;
    numLbl.font = Font20;
    [self addSubview:numLbl];
    _numLbl = numLbl;
    
    // 是按钮
    UIButton * yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yesBtn setImage:[UIImage imageNamed:@"dianhuakuang_shi"] forState:UIControlStateNormal];
    [self addSubview:yesBtn];
    _yesBtn = yesBtn;
    
    // 否按钮
    UIButton * noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [noBtn setImage:[UIImage imageNamed:@"dianhuakuang_fou"] forState:UIControlStateNormal];
    [self addSubview:noBtn];
    _noBtn = noBtn;
}

#pragma mark --- 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 呼叫
   [_callLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.mas_top).offset(Margin40 * IPHONE6_H_SCALE);
       make.centerX.equalTo(self.mas_centerX);
       make.width.equalTo(@(self.width));
       make.height.equalTo(@(19 * IPHONE6_H_SCALE));
   }];
    
    // 电话号码
   [_numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(_callLbl.mas_bottom).offset(34*0.5*IPHONE6_H_SCALE);
       make.left.equalTo(self.mas_left);
       make.width.equalTo(@(self.width));
       make.height.equalTo(@(17 * IPHONE6_H_SCALE));
   }];
    
    // 是按钮
    CGFloat yesX = 44 * 0.5 * IPHONE6_W_SCALE;
    CGFloat yesY = CGRectGetMaxY(_numLbl.frame) + 45 * 0.5 * IPHONE6_H_SCALE;
    CGFloat yesW = 104 * IPHONE6_W_SCALE;
    CGFloat yesH = 29 * IPHONE6_H_SCALE;
    _yesBtn.frame = CGRectMake(yesX, yesY, yesW, yesH);
    
    // 否按钮
    CGFloat noX = CGRectGetMaxX(_yesBtn.frame) + 38 * 0.5 * IPHONE6_W_SCALE;
    CGFloat noY = yesY;
    CGFloat noW = yesW;
    CGFloat noH = yesH;
    _noBtn.frame = CGRectMake(noX, noY, noW, noH);
}
@end
