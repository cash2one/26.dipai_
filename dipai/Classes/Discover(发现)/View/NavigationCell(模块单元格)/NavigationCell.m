//
//  NavigationCell.m
//  dipai
//
//  Created by 梁森 on 16/6/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NavigationCell.h"

@implementation NavigationCell
#pragma mark --- 创建自定义的单元格
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"tournamentCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        //        NSLog(@"...");
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        [self setUpChildView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return  self;
}

#pragma mark --- 设置子控件
- (void)setUpChildView
{
    // 俱乐部按钮
    UIButton * clubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    clubBtn.backgroundColor = [UIColor redColor];
    [clubBtn setImage:[UIImage imageNamed:@"julebu"] forState:UIControlStateNormal];
    [self addSubview:clubBtn];
    _clubBtn = clubBtn;
    
    // 赛事
    UIButton * matchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    matchBtn.backgroundColor = [UIColor redColor];
    [matchBtn setImage:[UIImage imageNamed:@"saishi"] forState:UIControlStateNormal];
    [self addSubview:matchBtn];
    _matchBtn = matchBtn;
    
    // 扑克名人堂
    UIButton * pokerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    pokerBtn.backgroundColor = [UIColor redColor];
    [pokerBtn setImage:[UIImage imageNamed:@"mingrentang"] forState:UIControlStateNormal];
    [self addSubview:pokerBtn];
    _pokerBtn = pokerBtn;
    
    // 专辑
    UIButton * specialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    specialBtn.backgroundColor = [UIColor redColor]; 
    [specialBtn setImage:[UIImage imageNamed:@"zhuanti"] forState:UIControlStateNormal];
    [self addSubview:specialBtn];
    _specialBtn = specialBtn;
    
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    [self addSubview:separateView];
    _separateView = separateView;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 俱乐部按钮
    CGFloat clubX = 24* IPHONE6_W_SCALE;
    
    CGFloat clubY = Margin24 * IPHONE6_H_SCALE;
    if (HEIGHT == 480.f) {  // 为了适配4
        clubY = 8 * IPHONE6_H_SCALE;
    }
    CGFloat clubW = 40 * IPHONE6_W_SCALE;
    CGFloat clubH = 117 * 0.5 * IPHONE6_W_SCALE;
    _clubBtn.frame = CGRectMake(clubX, clubY, clubW, clubH);
//    [_clubBtn sizeToFit];
    
    // 赛事
    CGFloat matchX = CGRectGetMaxX(_clubBtn.frame) + 110 * 0.5 * IPHONE6_W_SCALE;
    CGFloat matchY = clubY;
    CGFloat matchW = clubW;
    CGFloat matchH = clubH;
    _matchBtn.frame = CGRectMake(matchX, matchY, matchW, matchH);
//    [_matchBtn sizeToFit];
    
    // 扑克名人堂
    CGFloat pokerX = CGRectGetMaxX(_matchBtn.frame) + (110-26.5) * 0.5 * IPHONE6_W_SCALE;
    CGFloat pokerY = clubY;
    CGFloat pokerW = 133 * 0.5 * IPHONE6_W_SCALE;
    CGFloat pokerH = clubH;
    _pokerBtn.frame = CGRectMake(pokerX, pokerY, pokerW, pokerH);
//    [_pokerBtn sizeToFit];
    
    
    // 专辑
    CGFloat specialX = CGRectGetMaxX(_pokerBtn.frame) + (110-26.5) * 0.5 * IPHONE6_W_SCALE;
    CGFloat specialY = clubY;
    CGFloat specialW = clubW;
    CGFloat specialH = clubH;
    _specialBtn.frame = CGRectMake(specialX, specialY, specialW, specialH);
//    [_specialBtn sizeToFit];
    
    _separateView.frame = CGRectMake(0, 80*IPHONE6_H_SCALE, WIDTH, 10*IPHONE6_H_SCALE);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
