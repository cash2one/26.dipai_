//
//  HeaderViewInMatch.m
//  dipai
//
//  Created by 梁森 on 16/6/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "HeaderViewInMatch.h"

#import "Masonry.h"

#import "EndMatchModel.h"
#import "NoLiveModel.h"
#import "MatchingModel.h"
@interface HeaderViewInMatch()
/**
 *  背景图
 */
@property (nonatomic, strong) UIImageView * picView;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel * titleLbl;
/**
 *  小背景图
 */
@property (nonatomic, strong) UIView * backView;
/**
 *  时间
 */
@property(nonatomic, strong) UILabel * timeLbl;
/**
 *  报名费
 */
@property(nonatomic, strong) UILabel * applyLbl;
/**
 *  主赛奖池
 */
@property (nonatomic, strong) UILabel * prizeLbl;
/**
 *  地点
 */
@property (nonatomic, strong) UILabel * placeLbl;

/**
 *  没有赛事的模型
 */
@property (nonatomic, strong) NoLiveModel * noLive;


@end

@implementation HeaderViewInMatch

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
            [self setUpChildControl];
        
    }
    return self;
}
#pragma mark --- 设置进行中的赛事的头视图的子控件

#pragma mark --- 设置子控件
- (void)setUpChildControl{
    
    // 背景图
    UIImageView * picView = [[UIImageView alloc] init];
    picView.image = [UIImage imageNamed:@"saishi_beijingditu"];
    [self addSubview:picView];
    _picView = picView;
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = Font15;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    
    // 装时间等等的一个小背景图
    UIView * backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:255 / 255.f green:255 / 255.f blue:255 / 255.f alpha:0.18];
    backView.layer.cornerRadius = 4;
    [self addSubview:backView];
    _backView = backView;
    
    // 时间
    UILabel * timeLbl = [[UILabel alloc] init];
    timeLbl.textAlignment = NSTextAlignmentCenter;
    timeLbl.textColor = [UIColor whiteColor];
    timeLbl.font = Font13;
    [_backView addSubview:timeLbl];
    _timeLbl = timeLbl;
    
    // 报名费
    UILabel * applyLbl = [[UILabel alloc] init];
    applyLbl.textAlignment = NSTextAlignmentCenter;
    applyLbl.textColor = [UIColor whiteColor];
    applyLbl.font = Font12;
    [_backView addSubview:applyLbl];
    _applyLbl = applyLbl;
    
    // 主赛奖池：
    UILabel * prizeLbl = [[UILabel alloc] init];
    prizeLbl.textColor = [UIColor whiteColor];
    prizeLbl.font = Font12;
    [_backView addSubview:prizeLbl];
    _prizeLbl = prizeLbl;
    
    // 地点
    UILabel * placeLbl = [[UILabel alloc] init];
    placeLbl.textColor = [UIColor whiteColor];
    placeLbl.font = Font12;
    [_backView addSubview:placeLbl];
    _placeLbl = placeLbl;
    
}

- (void)setMatchModel:(MatchingModel *)matchModel{
    _matchModel = matchModel;
    
    // 字典转模型
    NSDictionary * match = _matchModel.match;
//    NSLog(@"%@", match);
//    NSLog(@"%@", matchModel);
    NoLiveModel * noLive = [NoLiveModel objectWithKeyValues:match];
    _noLive = noLive;
    
//    NSLog(@"%@", _noLive);
//    NSLog(@"%@", _noLive.start_time);
    [self layoutSubviews];
}



#pragma mark --- 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 背景图
    _picView.frame = CGRectMake(0, 0, WIDTH, 290 * 0.5 * IPHONE6_H_SCALE);
    
    // 标题
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(25 * IPHONE6_H_SCALE);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(WIDTH - 57 * IPHONE6_W_SCALE));
        make.height.equalTo(@(15 * IPHONE6_W_SCALE));
    }];
    _titleLbl.text = _matchModel.title;
    
    // 装时间等等的一个小背景图
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_titleLbl.mas_bottom).offset(15 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 57 * IPHONE6_W_SCALE));
        make.height.equalTo(@(65 * IPHONE6_H_SCALE));
    }];
    
    // 时间
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView.mas_centerX);
        make.top.equalTo(_backView.mas_top).offset(14 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 57 * IPHONE6_W_SCALE));
        make.height.equalTo(@(13 * IPHONE6_H_SCALE));
    }];
    
    
    _timeLbl.text = [NSString stringWithFormat:@"时间:%@-%@", _noLive.start_time, _noLive.end_time];
    
    // 报名费
    [_applyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView.mas_centerX);
        make.top.equalTo(_timeLbl.mas_bottom).offset(23*0.5*IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 57 * IPHONE6_W_SCALE));
        make.height.equalTo(@(12 * IPHONE6_H_SCALE));
    }];
    _applyLbl.text = [NSString stringWithFormat:@"报名费:%@   主赛奖池:%@   地点:%@", _noLive.entry_fee, _noLive.prize_pool, _noLive.place];
    
    // 主赛奖池：
    
    
    // 地点
}

@end
