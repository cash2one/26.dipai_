//
//  ViewForHeader.m
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ViewForHeader.h"

#import "Masonry.h"
@interface ViewForHeader()
/**
 *  城市名称
 */
@property (nonatomic, strong) UILabel * cityLbl;
/**
 *  俱乐部个数
 */
@property (nonatomic, strong) UILabel * numLbl;

@end

@implementation ViewForHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // 设置子控件
        [self setUpChildControl];
        
        self.backgroundColor = Color248;
    }
    return self;
}

#pragma mark --- 设置子控件
- (void)setUpChildControl{
    
    // 城市名称
    UILabel * cityLbl = [[UILabel alloc] init];
//    cityLbl.backgroundColor = [UIColor redColor];
    cityLbl.font = Font16;
    cityLbl.textColor = [UIColor blackColor];
    [self addSubview:cityLbl];
    self.cityLbl = cityLbl;
    
    // 俱乐部个数
    UILabel * numLbl = [[UILabel alloc] init];
//    numLbl.backgroundColor = [UIColor redColor];
    numLbl.textAlignment = NSTextAlignmentRight;
    numLbl.font = Font11;
    numLbl.textColor = Color153;
    [self addSubview:numLbl];
    self.numLbl = numLbl;
    
}

- (void)setName:(NSString *)name{
    self.cityLbl.text = name;
}

- (void)setNum:(NSString *)num{
    self.numLbl.text = [NSString stringWithFormat:@"%@家俱乐部", num];
}

#pragma mark --- 设置子控件的frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 城市名称
    CGFloat cityX = Margin40 * IPHONE6_W_SCALE;
    CGFloat cityY = 0;
    CGFloat cityW = 100;
    CGFloat cityH = 33 * IPHONE6_H_SCALE;
    self.cityLbl.frame = CGRectMake(cityX, cityY, cityW, cityH);
    
    // 俱乐部个数
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-Margin40 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@100);
    }];
}

@end
