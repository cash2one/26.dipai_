//
//  CustomCollectionCell.m
//  UICollectionViewCell的复用
//
//  Created by 梁森 on 16/10/18.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CustomCollectionCell.h"

#import "Masonry.h"
#import "PlatformModel.h"
@implementation CustomCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        [self setUpChildControl];
    }
    
    return self;
}

- (void)setUpChildControl{
    
    self.backgroundColor = [UIColor clearColor];
    UIImageView * picV = [[UIImageView alloc] init];
//    picV.backgroundColor = [UIColor blueColor];
    [self addSubview:picV];
    picV.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreInfoAction)];
    tap.numberOfTapsRequired = 1;
    [picV addGestureRecognizer:tap];
    [picV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(690*0.5*0.5 * IPHONE6_W_SCALE));
    }];
    _picV = picV;
    
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"bangding"] forState:UIControlStateNormal];
//    [moreBtn setBackgroundImage:[UIImage imageNamed:@"gengduoxinxi"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreInfoAction) forControlEvents:UIControlEventTouchUpInside];
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

- (void)setModel:(PlatformModel *)model{
    
    _model = model;
    self.userInteractionEnabled = NO;
}
- (void)setRow:(NSInteger *)row{
    
    _row = row;
}
- (void)moreInfoAction{
    
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickWithURL:andRow:)]) {
        [self.delegate tableViewCell:self didClickWithURL:_model.weburl andRow:0];
    }
}


@end
