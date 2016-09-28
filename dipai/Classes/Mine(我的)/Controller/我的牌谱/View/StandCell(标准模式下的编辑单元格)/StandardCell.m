//
//  StandardCell.m
//  dipai
//
//  Created by 梁森 on 16/9/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "StandardCell.h"

#import "Masonry.h"
@implementation StandardCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"cellID";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpChildControl];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// 设置子控件
- (void)setUpChildControl{
    
    // 背景
    UIView * backV = [[UIView alloc] init];
    backV.backgroundColor = RGBA(54, 54, 54, 1);
    backV.layer.masksToBounds = YES;
    backV.layer.cornerRadius = 4;
    [self addSubview:backV];
    _backV = backV;
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.font = Font15;
    titleLbl.textColor = [UIColor whiteColor];
    [backV addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    // 右侧按钮
    UIButton * hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hiddenBtn setImage:[UIImage imageNamed:@"icon_yincang"] forState:UIControlStateNormal];
    [hiddenBtn setImage:[UIImage imageNamed:@"icon_xianshi"] forState:UIControlStateSelected];
    [backV addSubview:hiddenBtn];
    _hiddenBtn = hiddenBtn;
    [hiddenBtn addTarget:self action:@selector(hiddenAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 编辑框
    UITextView * textV = [[UITextView alloc] init];
    textV.textColor = Color178;
    textV.font = Font12;
    // 编辑框没有颜色吗？
    textV.backgroundColor = RGBA(54, 54, 54, 1);
    [backV addSubview:textV];
    _textV = textV;
    
    // 分割线
    UIView * separateV = [[UIView alloc] init];
    separateV.backgroundColor = RGBA(23, 23, 23, 1);
    [self addSubview:separateV];
    _separateV = separateV;
    
}

- (void)hiddenAction{
    
    if ([self.delegate respondsToSelector:@selector(tableViewCell:)]) {
        [self.delegate tableViewCell:self];
    }else{
        
        NSLog(@"StandardCell的代理没有响应...");
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(@(-13 * IPHONE6_H_SCALE));
    }];
    _backV.layer.cornerRadius = 4;
    
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backV.mas_left).offset(21 * IPHONE6_W_SCALE);
        make.top.equalTo(_backV.mas_top).offset(18 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 72 * IPHONE6_W_SCALE));
        make.height.equalTo(@(15 * IPHONE6_H_SCALE));
    }];
    
    [_hiddenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_backV.mas_top).offset(6 * IPHONE6_H_SCALE);
        make.right.equalTo(_backV.mas_right).offset(-8 * IPHONE6_W_SCALE);
        make.width.equalTo(@(23 * IPHONE6_W_SCALE));
        make.height.equalTo(@(23 * IPHONE6_W_SCALE));
    }];
    [_textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLbl.mas_bottom).offset(16 * IPHONE6_H_SCALE);
        make.left.equalTo(_backV.mas_left).offset(21 * IPHONE6_W_SCALE);
        make.right.equalTo(_backV.mas_right).offset(- 21 * IPHONE6_W_SCALE);
        make.bottom.equalTo(_backV.mas_bottom).offset(-21 * IPHONE6_H_SCALE);
    }];
//    _textV.backgroundColor = [UIColor greenColor];
    
    [_separateV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(13 * IPHONE6_H_SCALE));
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
