//
//  CustomCollectionCell.m
//  UICollectionViewCell的复用
//
//  Created by 梁森 on 16/10/18.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CustomCollectionCell.h"

#import "Masonry.h"
@implementation CustomCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        [self setUpChildControl];
    }
    
    return self;
}

- (void)setUpChildControl{
    
    self.backgroundColor = [UIColor greenColor];
    UIImageView * picV = [[UIImageView alloc] init];
    picV.backgroundColor = [UIColor blueColor];
    [self addSubview:picV];
    
    [picV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(690*0.5*0.5 * IPHONE6_W_SCALE));
    }];
    _picV = picV;
    
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"gengduoxinxi"] forState:UIControlStateNormal];
//    [moreBtn setBackgroundImage:[UIImage imageNamed:@"gengduoxinxi"] forState:UIControlStateNormal];
    [self addSubview:moreBtn];
    
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(picV.mas_bottom).offset(7 * IPHONE6_H_SCALE);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(234 * 0.5 * IPHONE6_W_SCALE /2));
        make.height.equalTo(@(56 * 0.5 * IPHONE6_H_SCALE /2));
    }];
    moreBtn.layer.cornerRadius = 7 * IPHONE6_W_SCALE;
    moreBtn.layer.masksToBounds = YES;
    _moreBtn = moreBtn;
}

@end
