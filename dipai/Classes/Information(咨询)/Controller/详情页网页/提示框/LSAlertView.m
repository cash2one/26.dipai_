//
//  LSAlertView.m
//  dipai
//
//  Created by 梁森 on 16/5/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "LSAlertView.h"

@interface LSAlertView()

/**
 *  取消按钮
 */
@property (nonatomic, strong) UIButton * cancelBtn;
/**
 *  确定按钮
 */
@property (nonatomic, strong) UIButton * sureBtn;
/**
 *  横线
 */
@property (nonatomic, strong) UIView * horizontalLine;
/**
 *  竖线
 */
@property (nonatomic, strong) UIView * verticalLine;

@end

@implementation LSAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 设置子控件
        [self setUpChildControl];
    }
    
    return self;
}

#pragma mark --- 设置子控件

- (void)setUpChildControl
{
    // 提示信息
    UILabel * messageLbl = [[UILabel alloc] init];
    messageLbl.font = Font17;
    messageLbl.text = @"请先登录后再发表";
    messageLbl.textAlignment = NSTextAlignmentCenter;
    [messageLbl sizeToFit];
    [self addSubview:messageLbl];
    _messageLbl = messageLbl;
    // 取消按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = Font17;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:ColorBlue forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
    _cancelBtn = cancelBtn;
    // 确定按钮
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.titleLabel.font = Font17;
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:ColorBlue forState:UIControlStateNormal];
    [sureBtn setTitle:@"去登录" forState:UIControlStateNormal];
    [self addSubview:sureBtn];
    _sureBtn = sureBtn;
    // 横线
    UIView * horizontalLine = [[UIView alloc] init];
    horizontalLine.backgroundColor = Color237;
    [self addSubview:horizontalLine];
    _horizontalLine = horizontalLine;
    // 竖线
    UIView * verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = Color237;
    [self addSubview:verticalLine];
    _verticalLine = verticalLine;
    
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setMessageLbl:(UILabel *)messageLbl{
    _messageLbl = messageLbl;
    _messageLbl.text = messageLbl.text;
}

#pragma mark --- 取消事件
- (void)cancelAction
{
    if ([self.delegate respondsToSelector:@selector(lsAlertView:sure:)]) {
        [self.delegate lsAlertView:self cancel:nil];
    } else
    {
        NSLog(@"LSAlertView的代理没有响应...");
    }
}
#pragma mark --- 确定事件
- (void)sureAction
{
    if ([self.delegate respondsToSelector:@selector(lsAlertView:sure:)]) {
        [self.delegate lsAlertView:self sure:nil];
    } else
    {
        NSLog(@"LSAlertView的代理没有响应...");
    }
}
#pragma mark --- 对子控件进行布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 提示信息
    CGFloat messageX = Margin101 * IPHONE6_W_SCALE;
    CGFloat messageY = Margin45 * IPHONE6_H_SCALE;
    CGFloat messageW = self.width - 2 * messageX;
    CGFloat messageH = Margin34 * IPHONE6_H_SCALE;
    _messageLbl.frame = CGRectMake(messageX, messageY, messageW, messageH);
    // 横线
    CGFloat horizontalLineX = 0;
    CGFloat horizontalLineY = Margin119 * IPHONE6_H_SCALE;
    CGFloat horizontalLineW = self.width;
    CGFloat horizontalLineH = 0.5;
    _horizontalLine.frame = CGRectMake(horizontalLineX, horizontalLineY, horizontalLineW, horizontalLineH);
    // 竖线
    CGFloat verticalLineX = Margin270 * IPHONE6_W_SCALE;
    CGFloat verticalLineY = CGRectGetMaxY(_horizontalLine.frame);
    CGFloat verticalLineW = 0.5;
    CGFloat verticalLineH = Margin88 * IPHONE6_H_SCALE;
    _verticalLine.frame = CGRectMake(verticalLineX, verticalLineY, verticalLineW, verticalLineH);
    // 取消按钮
    CGFloat cancelX = 0;
    CGFloat cancelY = CGRectGetMaxY(_horizontalLine.frame);
    CGFloat cancelW = self.width / 2;
    CGFloat cancelH = Margin88 * IPHONE6_H_SCALE;
    _cancelBtn.frame = CGRectMake(cancelX, cancelY, cancelW, cancelH);
    // 确定按钮
    CGFloat sureBtnX = CGRectGetMaxX(_verticalLine.frame);
    CGFloat sureBtnY = cancelY;
    CGFloat sureBtnW = cancelW;
    CGFloat sureBtnH = cancelH;
    _sureBtn.frame = CGRectMake(sureBtnX, sureBtnY, sureBtnW, sureBtnH);
}
@end











