//
//  MatchingHeader.m
//  dipai
//
//  Created by 梁森 on 16/6/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MatchingHeader.h"

#import "Masonry.h"
@interface MatchingHeader()
/**
 *  背景图
 */
@property (nonatomic, strong) UIImageView * picView;


/**
 *  当前盲注
 */
@property (nonatomic, strong) UILabel * blindLbl;
/**
 *  平均记分牌
 */
@property (nonatomic, strong) UILabel * scoreLbl;
/**
 *  剩余选手
 */
@property (nonatomic, strong) UILabel * playerLbl;

// 两个竖直分割线
@property (nonatomic, strong) UIView * line1;
@property (nonatomic, strong) UIView * line2;

@end

@implementation MatchingHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // 设置子控件
        [self setUpChildControl];
    }
    return self;
}


#pragma mark --- 设置子控件
- (void)setUpChildControl{
    UIImageView * picView = [[UIImageView alloc] init];
    picView.image = [UIImage imageNamed:@"saishi_beijingditu"];
    [self addSubview:picView];
    _picView = picView;
    
    // 赛事状态
    UILabel * stateLbl = [[UILabel alloc] init];
    stateLbl.textAlignment = NSTextAlignmentRight;
    stateLbl.textColor = [UIColor whiteColor];
    stateLbl.font = Font13;
    [self addSubview:stateLbl];
    _stateLbl = stateLbl;
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = Font15;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    // 分割线
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor colorWithRed:255 / 255.f green:255 / 255.f blue:255 / 255.f alpha:0.7];
    [self addSubview:separateView];
    _separateView = separateView;
    
    // 盲注数、记分、剩余选手 分割线
    
    UILabel * blindNum = [[UILabel alloc] init];
//    blindNum.backgroundColor = [UIColor whiteColor];
    blindNum.textColor = [UIColor redColor];
    blindNum.textAlignment = NSTextAlignmentCenter;
    [self addSubview:blindNum];
    _blindNum = blindNum;
    UILabel * score = [[UILabel alloc] init];
//    score.backgroundColor = [UIColor whiteColor];
    score.textColor = [UIColor redColor];
    score.textAlignment = NSTextAlignmentCenter;
    [self addSubview:score];
    _score = score;
    UILabel * players = [[UILabel alloc] init];
//    players.backgroundColor = [UIColor whiteColor];
    players.textColor = [UIColor redColor];
    players.textAlignment = NSTextAlignmentCenter;
    [self addSubview:players];
    _players = players;
    
    UIView * line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithRed:255 / 255.f green:255 / 255.f blue:255 / 255.f alpha:0.7];
    [self addSubview:line1];
    _line1 = line1;
    UIView * line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithRed:255 / 255.f green:255 / 255.f blue:255 / 255.f alpha:0.7];
    [self addSubview:line2];
    _line2 = line2;
    
    // 盲注数、记分、剩余选手标签
    UILabel * blindLbl = [[UILabel alloc] init];
    blindLbl.layer.masksToBounds = YES;
    blindLbl.layer.cornerRadius = 2;
    blindLbl.text = @"当前盲注";
    blindLbl.textColor = [UIColor whiteColor];
    blindLbl.font = Font13;
    blindLbl.textAlignment = NSTextAlignmentCenter;
    blindLbl.backgroundColor = [UIColor colorWithRed:288 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.7];
    [self addSubview:blindLbl];
    _blindLbl = blindLbl;
    
    // 平均记分牌
    UILabel * scoreLbl = [[UILabel alloc] init];
    scoreLbl.layer.masksToBounds = YES;
    scoreLbl.layer.cornerRadius = 2;
    scoreLbl.text = @"平均记分牌";
    scoreLbl.textColor = [UIColor whiteColor];
    scoreLbl.font = Font13;
    scoreLbl.textAlignment = NSTextAlignmentCenter;
    scoreLbl.backgroundColor = [UIColor colorWithRed:288 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.7];
    [self addSubview:scoreLbl];
    _scoreLbl = scoreLbl;
    
    // 剩余选手
    UILabel * playerLbl = [[UILabel alloc] init];
    playerLbl.layer.masksToBounds = YES;
    playerLbl.layer.cornerRadius = 2;
    playerLbl.text = @"剩余选手";
    playerLbl.textColor = [UIColor whiteColor];
    playerLbl.font = Font13;
    playerLbl.textAlignment = NSTextAlignmentCenter;
    playerLbl.backgroundColor = [UIColor colorWithRed:288 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.7];
    [self addSubview:playerLbl];
    _playerLbl = playerLbl;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    // 赛事状态
    [_stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(16 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-39 * IPHONE6_W_SCALE);
        make.width.equalTo(@(WIDTH - 39 * IPHONE6_W_SCALE));
        make.height.equalTo(@(13 * IPHONE6_H_SCALE));
    }];
   
    
    // 标题
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(50 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 72*IPHONE6_W_SCALE));
        make.height.equalTo(@(15*IPHONE6_H_SCALE));
    }];
    
    
    // 分割线
    [_separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_titleLbl.mas_bottom).offset(14 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 72 * IPHONE6_W_SCALE));
        make.height.equalTo(@(0.5));
    }];
    
    // 盲注数、记分、剩余选手 分割线
    // 两个竖直分割线
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(259*0.5*IPHONE6_W_SCALE);
        make.top.equalTo(_separateView.mas_bottom).offset(13*IPHONE6_H_SCALE);
        make.width.equalTo(@(0.5));
        make.height.equalTo(@(13*IPHONE6_H_SCALE));
    }];
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_line1.mas_right).offset(231*0.5*IPHONE6_W_SCALE);
        make.top.equalTo(_line1.mas_top);
        make.width.equalTo(@(0.5));
        make.height.equalTo(_line1.mas_height);
    }];
    
//    [_score sizeToFit];
    
    
    
    // 盲注数、记分、剩余选手标签
    [_scoreLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_separateView.mas_bottom).offset(47 * IPHONE6_H_SCALE);
        make.width.equalTo(@(71* IPHONE6_W_SCALE));
        make.height.equalTo(@(21* IPHONE6_H_SCALE));
    }];
    [_blindLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_scoreLbl.mas_left).offset(-45* IPHONE6_W_SCALE);
        make.top.equalTo(_scoreLbl.mas_top);
        make.width.equalTo(_scoreLbl.mas_width);
        make.height.equalTo(_scoreLbl.mas_height);;
    }];
    [_playerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scoreLbl.mas_right).offset(45*IPHONE6_W_SCALE);
        make.top.equalTo(_scoreLbl.mas_top);
        make.width.equalTo(_scoreLbl.mas_width);
        make.height.equalTo(_scoreLbl.mas_height);
    }];
    
    [_score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_separateView.mas_bottom).offset(14*IPHONE6_H_SCALE);
        make.width.equalTo(@(100*IPHONE6_W_SCALE));
        make.height.equalTo(@(13* IPHONE6_H_SCALE));
        
    }];
    
    [_blindNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_blindLbl.mas_centerX);
        make.top.equalTo(_separateView.mas_bottom).offset(14*IPHONE6_H_SCALE);
        make.width.equalTo(@(259*0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(13* IPHONE6_H_SCALE));
    }];
//    [_blindNum sizeToFit];
    [_players mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_playerLbl.mas_centerX);
        make.top.equalTo(_separateView.mas_bottom).offset(14*IPHONE6_H_SCALE);
        make.width.equalTo(@(100*IPHONE6_W_SCALE));
        make.height.equalTo(@(13* IPHONE6_H_SCALE));
    }];
//    [_players sizeToFit];

}
@end
