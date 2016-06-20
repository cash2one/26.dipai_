//
//  MatchCell.m
//  dipai
//
//  Created by 梁森 on 16/6/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MatchCell.h"

#import "EndMatchModel.h"
#import "UIImageView+WebCache.h"
@interface MatchCell()
/**
 *  封面图
 */
@property (nonatomic, strong) UIImageView * picView;
/**
 *  开始和结束时间
 */
@property (nonatomic, strong) UILabel * timeLbl;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel * titleLbl;
/**
 *  主赛买入
 */
@property (nonatomic, strong) UILabel * buyLbl;
/**
 *  主赛奖池
 */
@property (nonatomic, strong) UILabel * prizeLbl;
/**
 *  地址
 */
@property (nonatomic, strong) UILabel * placeLbl;
/**
 *  分割线
 */
@property (nonatomic, strong) UIView * separateView;
@end

@implementation MatchCell

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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 设置子控件
        [self setUpChildControl];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}
#pragma mark --- 设置子控件
- (void)setUpChildControl{
    // 封面图
    UIImageView * picView = [[UIImageView alloc] init];
    [self addSubview:picView];
    _picView = picView;
    
    // 开始和结束时间
    UILabel * timeLbl = [[UILabel alloc] init];
    timeLbl.textColor = [UIColor whiteColor];
    timeLbl.font = Font11;
    timeLbl.textAlignment = NSTextAlignmentCenter;
    timeLbl.backgroundColor = [UIColor colorWithRed:228 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.7];
    [self addSubview:timeLbl];
    _timeLbl = timeLbl;
    
    
    // 标题
    UILabel * titleLbl =  [[UILabel alloc] init];
    titleLbl.font = Font15;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    
    // 主赛买入
    UILabel * buyLbl = [[UILabel alloc] init];
    buyLbl.font = Font11;
    buyLbl.textColor = Color123;
    [self addSubview:buyLbl];
    _buyLbl = buyLbl;
    
    
    // 主赛奖池
    UILabel * prizeLbl = [[UILabel alloc] init];
    prizeLbl.font = Font11;
    prizeLbl.textColor = Color123;
    [self addSubview:prizeLbl];
    _prizeLbl = prizeLbl;
    
    
    // 地址
    UILabel * placeLbl = [[UILabel alloc] init];
    placeLbl.font = Font11;
    placeLbl.textColor = Color123;
    [self addSubview:placeLbl];
    _placeLbl = placeLbl;
    
    // 分割线
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    [self addSubview:separateView];
    _separateView = separateView;
    
}

- (void)setMatchModel:(EndMatchModel *)matchModel{
    _matchModel = matchModel;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 封面图
    CGFloat picH = 190 * IPHONE6_H_SCALE;
    _picView.frame = CGRectMake(0, 0, WIDTH, picH);
    [_picView sd_setImageWithURL:[NSURL URLWithString:_matchModel.picname] placeholderImage:[UIImage imageNamed:@"123"]];
    
    // 开始和结束时间
    CGFloat timeX = WIDTH - 82 * IPHONE6_W_SCALE;
    CGFloat timeW = 82 * IPHONE6_W_SCALE;
    CGFloat timeH = 25 * IPHONE6_H_SCALE;
    _timeLbl.frame = CGRectMake(timeX, 0, timeW, timeH);
    _timeLbl.text = [NSString stringWithFormat:@"%@-%@", _matchModel.start_time, _matchModel.end_time];
    
    // 标题
    CGFloat titleX = Margin30 * IPHONE6_W_SCALE;
    CGFloat titleY = CGRectGetMaxY(_picView.frame) + 14 * IPHONE6_H_SCALE;
    CGFloat titleW = WIDTH - titleX;
    CGFloat titleH = 15 * IPHONE6_H_SCALE;
    _titleLbl.frame = CGRectMake(titleX, titleY, titleW, titleH);
    _titleLbl.text = _matchModel.title;
    [_titleLbl sizeToFit];
    
    
    // 主赛买入
    CGFloat buyY = CGRectGetMaxY(_titleLbl.frame) + 10 * IPHONE6_H_SCALE;
    _buyLbl.frame = CGRectMake(titleX, buyY, 50, 15);
    _buyLbl.text = [NSString stringWithFormat:@"主赛买入:%@", _matchModel.entry_fee];
    [_buyLbl sizeToFit];
    
    // 主赛奖池
    CGFloat prizeX = CGRectGetMaxX(_buyLbl.frame) + Margin30 * IPHONE6_W_SCALE;
    _prizeLbl.frame = CGRectMake(prizeX, buyY, 50, 15);
    _prizeLbl.text = [NSString stringWithFormat:@"主赛奖池:%@", _matchModel.prize_pool];
    [_prizeLbl sizeToFit];
    
    // 地址
    CGFloat placeX = CGRectGetMaxX(_prizeLbl.frame) + Margin30 * IPHONE6_W_SCALE;
    _placeLbl.frame = CGRectMake(placeX, buyY, 50, 15);
    _placeLbl.text = [NSString stringWithFormat:@"地址:%@", _matchModel.place];
    [_placeLbl sizeToFit];
    
    // 分割线
    CGFloat separateY = CGRectGetMaxY(_picView.frame) + 68 * IPHONE6_H_SCALE;
    _separateView.frame = CGRectMake(0, separateY, WIDTH, 20 * IPHONE6_H_SCALE);
    
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
