//
//  CustomTableViewCell.m
//  dipai
//
//  Created by 梁森 on 16/5/31.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CustomTableViewCell.h"

#import "Masonry.h"
@implementation CustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 设置子控件
        [self setUpChildControl];
    }
    
    return self;
}
#pragma mark ---- 设置子控件
- (void)setUpChildControl{
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.font = Font17;
//    titleLbl.backgroundColor = [UIColor redColor];
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    // 头像
    UIImageView * picView = [[UIImageView alloc] init];
    [self addSubview:picView];
    _picView = picView;
    // 昵称
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.font = Font15;
    nameLbl.textColor = Color153;
    nameLbl.textAlignment = NSTextAlignmentRight;
//    nameLbl.backgroundColor = [UIColor redColor];
    [self addSubview:nameLbl];
    _nameLbl = nameLbl;
    // accessView
    UIImageView * accessView = [[UIImageView alloc] init];
    accessView.image = [UIImage imageNamed:@"qianjin"];
    [self addSubview:accessView];
    _accessView = accessView;
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
    [self addSubview:line];
    _line = line;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    // 标题
    CGFloat titleX = Margin30 * IPHONE6_W_SCALE;
    CGFloat titleY = 0;
    CGFloat titleW = 150*IPHONE6_W_SCALE;
    CGFloat titleH = 110 / 2 * IPHONE6_H_SCALE;
    _titleLbl.frame = CGRectMake(titleX, titleY, titleW, titleH);
    // 头像
    CGFloat picX = 594 / 2 * IPHONE6_W_SCALE;
    CGFloat picY = 13 / 2 * IPHONE6_H_SCALE;
    CGFloat picW = 84 / 2 * IPHONE6_W_SCALE;
    CGFloat picH = picW;
    _picView.layer.masksToBounds = YES;
    _picView.layer.cornerRadius = picW / 2;
    _picView.frame = CGRectMake(picX, picY, picW, picH);
    // accessView
    CGFloat accessX = CGRectGetMaxX(_picView.frame) + Margin26 * IPHONE6_W_SCALE;
    CGFloat accessY = Margin40 * IPHONE6_H_SCALE;
    CGFloat accessW = Margin16 * IPHONE6_W_SCALE;
    CGFloat accessH = Margin30 * IPHONE6_H_SCALE;
    _accessView.frame = CGRectMake(accessX, accessY, accessW, accessH);
    // 昵称
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_accessView.mas_left).offset(-Margin32 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(110 / 2 * IPHONE6_H_SCALE));
        make.width.equalTo(@(150*IPHONE6_W_SCALE));
    }];
    CGFloat lineX = 0;
    CGFloat lineY = CGRectGetMaxY(_nameLbl.frame);
    CGFloat lineW = WIDTH;
    CGFloat lineH = 0.5;
    _line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
