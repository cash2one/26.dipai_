//
//  X_SelectPicViewCell.m
//  dipai
//
//  Created by 梁森 on 16/6/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "X_SelectPicViewCell.h"

@implementation X_SelectPicViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        _imgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgV];
        
        _imgV0 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imgV0 setImage:[UIImage imageNamed:@"tianjiatupian"] forState:UIControlStateNormal];
        [_imgV0 addTarget:self action:@selector(doIt) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_imgV0];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn addTarget:self action:@selector(doSth) forControlEvents:UIControlEventTouchUpInside];
        [_btn setImage:[UIImage imageNamed:@"icon_shanchu"] forState:UIControlStateNormal];
        [self.contentView addSubview:_btn];
    }
    
    return self;
}

- (void)doIt{
    if (_btnAction) {
        _btnAction();
    }
}

- (void)doSth{
    if (_action) {
        _action();
    }
}

//- (void)setRes:(BOOL)res{
//    _imgV.hidden = !res;
//    _imgV0.hidden = res;
//}

- (void)setIcon:(UIImage *)icon{
    _imgV.image = icon;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _btn.frame = CGRectMake(self.contentView.width-20*IPHONE6_W_SCALE, 0, 20*IPHONE6_W_SCALE, 20*IPHONE6_W_SCALE);
    _imgV.frame = CGRectMake(0, 10*IPHONE6_H_SCALE, self.contentView.width-10*IPHONE6_W_SCALE, self.contentView.width-10*IPHONE6_W_SCALE);
    _imgV0.frame = _imgV.frame;
}

@end
