//
//  NavigationBarV.m
//  dipai
//
//  Created by 梁森 on 16/9/6.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NavigationBarV.h"

#import "Masonry.h"
@implementation NavigationBarV

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpChildControl];
    }
    
    return self;
}


// 设置子控件
- (void)setUpChildControl{
    
    // 返回按钮的图片
    CGFloat popVX = 15 * IPHONE6_W_SCALE;
    CGFloat popVY = 34;
    CGFloat popVW = 10 * IPHONE6_W_SCALE;
    CGFloat popVH = 19 * IPHONE6_W_SCALE;
    UIImageView * popV = [[UIImageView alloc] initWithFrame:CGRectMake(popVX, popVY, popVW, popVH)];
    popV.hidden = YES;
    popV.image = [UIImage imageNamed:@"houtui_baise"];
    [self addSubview:popV];
    // 返回按钮
    UIButton * popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:popBtn];
    [popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(popV.mas_right).offset(100);
    }];
    
    // 左侧按钮标题
    UILabel * leftLbl = [[UILabel alloc] init];
    leftLbl.font = Font15;
    leftLbl.text = @"取消";
    leftLbl.textColor = [UIColor whiteColor];
    leftLbl.hidden = YES;
    [self addSubview:leftLbl];
    [leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top).offset(20);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(100));
    }];
    _leftLbl = leftLbl;
    
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.text = @"牌谱";
    titleLbl.font = Font18;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(20);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(100 * IPHONE6_W_SCALE));
    }];
    _titleLbl = titleLbl;
    
    // 新建按钮标题
    UILabel * newLbl = [[UILabel alloc] init];
//    newLbl.text = @"新建";
    newLbl.font = Font15;
    newLbl.textColor = [UIColor whiteColor];
    newLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:newLbl];
    newLbl.hidden = YES;
    [newLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(- 15 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top).offset(20);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(100 * IPHONE6_W_SCALE));
    }];
    
    // 新建按钮
    UIButton * newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:newBtn];
    [newBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(newLbl.mas_left).offset(-10);
    }];
    
    
    _popBtn = popBtn;
    _popV = popV;
    _rightBtn = newBtn;
    _rightLbl = newLbl;
}

- (void)setRightStr:(NSString *)rightStr{
    
    _rightLbl.text = rightStr;
    if (rightStr.length > 0) {
        _rightLbl.hidden = NO;
    }else{
        _rightLbl.hidden = YES;
    }
}
- (void)setLeftStr:(NSString *)leftStr{
    
    if (leftStr.length > 0) {
        _popV.hidden = YES;
        _leftLbl.hidden = NO;
    }else{
        _popV.hidden = NO;
        _leftLbl.hidden = YES;
    }
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleLbl.text = titleStr;
    
}

- (void)setColor:(UIColor *)color{
    
    _leftLbl.textColor = color;
    _rightLbl.textColor = color;
    _titleLbl.textColor = color;
}

@end
