//
//  SettingCell.m
//  dipai
//
//  Created by 梁森 on 16/5/31.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "SettingCell.h"

#import "Masonry.h"
@implementation SettingCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpChildControl];
    }
    return self;
}

#pragma mark --- 设置子控件
- (void)setUpChildControl{
    self.backgroundColor = [UIColor whiteColor];
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
//    titleLbl.backgroundColor = [UIColor redColor];
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    // accessView
    UIImageView * accessView = [[UIImageView alloc] init];
    accessView.image = [UIImage imageNamed:@"qianjin"];
    [self addSubview:accessView];
    _accessView = accessView;
    
    // 版本号
    UILabel * versionLbl = [[UILabel alloc] init];
    versionLbl.textAlignment = NSTextAlignmentRight;
    versionLbl.textColor = Color153;
    versionLbl.font = Font14;
    [self addSubview:versionLbl];
    _versionLbl = versionLbl;
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
    [self addSubview:line];
    _line = line;
    
    // 按钮
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [self addSubview:btn];
    _btn = btn;
    
}
#pragma mark --- 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 标题
    CGFloat titleX = Margin30 * IPHONE6_W_SCALE;
    CGFloat titleY = 0;
    CGFloat titleH = self.frame.size.height - 0.5;
    CGFloat titleW = 150  * IPHONE6_W_SCALE;
    _titleLbl.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    
    _line.frame = CGRectMake(0, titleH, WIDTH, 0.5);
    
    // accessView
    [_accessView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-30 / 2 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top).offset(34 / 2 * IPHONE6_H_SCALE);
        make.height.equalTo(@(Margin30 * IPHONE6_H_SCALE));
        make.width.equalTo(@(Margin16 * IPHONE6_W_SCALE));
    }];
    
    // 版本号
    [_versionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-Margin30 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(titleH));
        make.width.equalTo(@(150/2*IPHONE6_W_SCALE));
    }];
    
    // 按钮
    _btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


@end
