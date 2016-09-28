//
//  CreatePokerV.m
//  dipai
//
//  Created by 梁森 on 16/9/6.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CreatePokerV.h"

#import "Masonry.h"

@interface CreatePokerV()

@property (nonatomic, strong) UIView * line;

@end

@implementation CreatePokerV

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self setUpChildControl];
    }
    
    return self;
}

- (void)setUpChildControl{
    
    // 新建牌谱标签
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.font = Font17;
    titleLbl.text = @"新建牌谱";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    UIView * line = [[UIView alloc] init];
    [self addSubview:line];
    line.backgroundColor = RGBA(65, 65, 65, 1);
    _line = line;
    
    
    // 自定义编写按钮
    UIButton * writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:writeBtn];
    [writeBtn setTitle:@"自定义编写" forState:UIControlStateNormal];
    writeBtn.titleLabel.font = Font15;
    [writeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    writeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    writeBtn.layer.masksToBounds = YES;
    writeBtn.layer.cornerRadius = 4;
    writeBtn.layer.borderWidth = 1;
    writeBtn.layer.borderColor = [UIColor redColor].CGColor;
    _writeBtn = writeBtn;
    
    
    // 从其他平台导入按钮
    UIButton * importBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:importBtn];
    [importBtn setTitle:@"从其他平台导入" forState:UIControlStateNormal];
    importBtn.titleLabel.font = Font15;
    [importBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    importBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    importBtn.backgroundColor = RGBA(63, 63, 63, 1);
    importBtn.layer.masksToBounds = YES;
    importBtn.layer.cornerRadius = 4;
    importBtn.layer.borderWidth = 1;
    _importBtn = importBtn;
    
    // 右侧删除按钮
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-12 * IPHONE6_W_SCALE);
        make.width.equalTo(@(24 * IPHONE6_W_SCALE));
        make.height.equalTo(@(24 * IPHONE6_W_SCALE));
    }];
    [deleteBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    _deleteBtn = deleteBtn;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(28 * IPHONE6_H_SCALE);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(17 * IPHONE6_W_SCALE));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLbl.mas_bottom).offset(20 * IPHONE6_H_SCALE);
        make.left.equalTo(self.mas_left).offset(14 * IPHONE6_W_SCALE);
        make.right.equalTo(self.mas_right).offset(-14 * IPHONE6_W_SCALE);
        make.height.equalTo(@(1));
    }];
    
    [_writeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_line.mas_bottom).offset(116 * 0.5 * IPHONE6_H_SCALE);
        make.left.equalTo(self.mas_left).offset(37 * IPHONE6_W_SCALE);
        make.right.equalTo(self.mas_right).offset(-37 * IPHONE6_W_SCALE);
        make.height.equalTo(@(39 * IPHONE6_H_SCALE));
    }];
    
    [_importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_writeBtn.mas_bottom).offset(33 * IPHONE6_H_SCALE);
        make.width.equalTo(_writeBtn.mas_width);
        make.height.equalTo(_writeBtn.mas_height);
        make.centerX.equalTo(self.mas_centerX);
    }];
}


@end
