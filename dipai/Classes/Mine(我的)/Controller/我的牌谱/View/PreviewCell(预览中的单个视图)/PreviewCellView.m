//
//  PreviewCellView.m
//  dipai
//
//  Created by 梁森 on 16/9/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "PreviewCellView.h"

#import "Masonry.h"
@implementation PreviewCellView

- (instancetype)init{

    if (self = [super init]) {
        
        [self setUpChildControl];
        
        self.backgroundColor = RGBA(54, 54, 54, 1);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
    }
    return self;
}

- (void)setUpChildControl{
    
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = Font15;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    UILabel * contentLbl = [[UILabel alloc] init];
    contentLbl.numberOfLines = 0;
    contentLbl.font = Font12;
    contentLbl.textColor = Color178;
    [self addSubview:contentLbl];
    _contentLbl = contentLbl;
}

- (void)setContentStr:(NSString *)contentStr{
    
    _contentStr = contentStr;
    _contentLbl.text = _contentStr;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(21 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top).offset(18 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 72));
        make.height.equalTo(@(15 * IPHONE6_H_SCALE));
    }];
    
    CGFloat contentX = 21 * IPHONE6_W_SCALE;
    CGFloat contentY = CGRectGetMaxY(_titleLbl.frame) + 16 * IPHONE6_H_SCALE;
    CGFloat contentW = WIDTH - 72 * IPHONE6_W_SCALE;
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = Font12;
    CGRect rect = [_contentStr boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    _contentLbl.frame = (CGRect){{contentX, contentY}, rect.size};
    
}

@end
