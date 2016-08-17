//
//  HeaderViewInTalking.m
//  dipai
//
//  Created by 梁森 on 16/6/22.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "HeaderViewInTalking.h"

// 论坛模型
#import "ForumModel.h"

// 模块模型
#import "SectionModel.h"

#import "Masonry.h"

#import "UIImageView+WebCache.h"

@interface HeaderViewInTalking()
/**
 *  装图片的数组
 */
@property (nonatomic, strong) NSMutableArray * imageArr;
/**
 *  装标题的数组
 */
@property (nonatomic, strong) NSMutableArray * titleArr;

/**
 *  论坛模型
 */
@property (nonatomic, strong) SectionModel * sectionModel;

/**
 *  分割线
 */
@property (nonatomic, strong) UIView * separateView;
/**
 *  热门讨论
 */
@property (nonatomic, strong) UILabel * hotLbl;

/**
 *  底部的线
 */
@property (nonatomic, strong) UIView * line;

@end

@implementation HeaderViewInTalking

- (NSMutableArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (instancetype)initWithFrame:(CGRect)frame WithModel:(ForumModel *)model{
    if (self = [super initWithFrame:frame]) {
        _forumModel = model;
        //  设置子控件
        [self setUpChildControlWithModel:model];
    }
    
    return self;
}



#pragma mark --- 设置子控件
- (void)setUpChildControlWithModel:(ForumModel *)model{
    NSInteger count = model.section.count;   // 版块的个数
    NSInteger rows =   count / 5 + 1;   // 版块的行数
    for (int i = 0; i < count; i ++) {
        
        UIImageView * sectionView = [[UIImageView alloc] init];
//        sectionView.backgroundColor = [UIColor redColor];
        [self addSubview:sectionView];
        [self.imageArr addObject:sectionView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [sectionView addGestureRecognizer:tap];
        sectionView.userInteractionEnabled = YES;
        sectionView.tag = i;
        
        UILabel * titleLbl = [[UILabel alloc] init];
        titleLbl.font = Font12;
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLbl];
        [self.titleArr addObject:titleLbl];
    }
    
    // 分割线
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    [self addSubview:separateView];
    _separateView = separateView;
    
    // 热门讨论
    UILabel * hotLbl = [[UILabel alloc] init];
    hotLbl.text = @"热门讨论";
    hotLbl.font = Font16;
    [self addSubview:hotLbl];
    _hotLbl = hotLbl;
    
    // 底部的线
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
    [self addSubview:line];
    _line = line;
}

- (void)tapAction:(UIGestureRecognizer *)tap{
    UIImageView * imageView = (UIImageView *)tap.view;
    NSInteger index = imageView.tag;
    SectionModel * sectionModel = _forumModel.section[index];
    NSString * wapurl = sectionModel.wapurl;
    if ([self.delegate respondsToSelector:@selector(turnPageToSomeSectionWithURL:andSectionModel:)]) {
        [self.delegate turnPageToSomeSectionWithURL:wapurl andSectionModel:sectionModel];
    }else{
        NSLog(@"HeaderViewInTalkingDelegate的代理没有响应...");
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i = 0; i < self.imageArr.count; i ++) {
        // 图片
        UIImageView * sectionView = self.imageArr[i];
        CGFloat sectionX = 65 * 0.5 * IPHONE6_W_SCALE;
        CGFloat sectionY = 14 * IPHONE6_H_SCALE;
        CGFloat sectionW = 37 * IPHONE6_W_SCALE;
        CGFloat sectionH = sectionW;
        
        int j = i % 4;
        int k = i / 4;
        
        sectionView.frame = CGRectMake(sectionX + j * (sectionW + 54*IPHONE6_W_SCALE), sectionY + k * (sectionH + 31*IPHONE6_H_SCALE), sectionW, sectionH);
        sectionView.layer.masksToBounds = YES;
        sectionView.layer.cornerRadius = sectionW * 0.5;
        
        _sectionModel = _forumModel.section[i];
        [sectionView sd_setImageWithURL:[NSURL URLWithString:_sectionModel.picname]];
        // 标题
        UILabel * titleLbl = self.titleArr[i];
        titleLbl.text = _sectionModel.name;
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(sectionView.mas_centerX);
            make.top.equalTo(sectionView.mas_bottom).offset(9 * IPHONE6_H_SCALE);
            make.width.equalTo(@(WIDTH / 4));
            make.height.equalTo(@(12*IPHONE6_W_SCALE));
        }];
        
    }
    
    // 分割线
    UILabel * titleLbl = [self.titleArr lastObject];
    [_separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(titleLbl.mas_bottom).offset(19 * IPHONE6_H_SCALE);
        make.height.equalTo(@(10*IPHONE6_H_SCALE));
    }];
    
    // 热门讨论区
    [_hotLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10 * IPHONE6_W_SCALE);
        make.top.equalTo(_separateView.mas_bottom).offset(14 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(16 * IPHONE6_W_SCALE));
    }];
//    _hotLbl.backgroundColor = [UIColor redColor];
//    
//    _line.backgroundColor = [UIColor redColor];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@0.5);
    }];
}

@end
