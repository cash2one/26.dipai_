//
//  ScoreCell.m
//  dipai
//
//  Created by 梁森 on 16/7/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ScoreCell.h"

#import "ScoreModel.h"
@interface ScoreCell()
@property (nonatomic, strong)  UIView * leftView;
@property (nonatomic, strong) UIImageView * redPoint;
@property (nonatomic, strong) UILabel * timeLbl;
@property (nonatomic, strong) UILabel * scoreLbl;

@end

@implementation ScoreCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"cellID";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        NSLog(@"...");
    }
    
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 添加子控件
        [self setUpChildView];
        // 去除点击效果
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setUpChildView{
    
    // 左侧竖线
    UIView * leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor colorWithRed:245 / 255.f green:245 / 255.f blue:245 / 255.f alpha:1];
    [self addSubview:leftView];
    _leftView = leftView;
    
    // 小红点
    UIImageView * redPoint = [[UIImageView alloc] init];
    redPoint.image = [UIImage imageNamed:@"hongseyuandian"];
    [self addSubview:redPoint];
    _redPoint = redPoint;
    
    // 时间
    UILabel * timeLbl = [[UILabel alloc] init];
//    timeLbl.backgroundColor = [UIColor redColor];
    timeLbl.font = Font12;
    timeLbl.textColor = Color123;
    [self addSubview:timeLbl];
    _timeLbl = timeLbl;
    // 成绩label
    UILabel * scoreLbl = [[UILabel alloc] init];
    scoreLbl.font = Font13;
    [self addSubview:scoreLbl];
    _scoreLbl = scoreLbl;

}

- (void)setScoreModel:(ScoreModel *)scoreModel{
    _scoreModel = scoreModel;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 左侧竖线
    
    // 小红点
    _redPoint.frame = CGRectMake(15 * IPHONE6_W_SCALE, 15*IPHONE6_H_SCALE, 12*IPHONE6_W_SCALE, 12*IPHONE6_W_SCALE);
    
    // 时间
    CGFloat timeX = CGRectGetMaxX(_redPoint.frame) + 10 * IPHONE6_W_SCALE;
    
    _timeLbl.frame = CGRectMake(timeX, 15*IPHONE6_H_SCALE, WIDTH-timeX, 12*IPHONE6_W_SCALE);
    _timeLbl.text = _scoreModel.year;
    
    // 成绩label
    CGFloat scoreX = timeX;
    CGFloat scoreY = CGRectGetMaxY(_timeLbl.frame) + 15*IPHONE6_H_SCALE;
    CGFloat scoreW = WIDTH - 2 * timeX;
    NSMutableDictionary * scoreDic = [NSMutableDictionary dictionary];
    scoreDic[NSFontAttributeName] = Font13;
    CGRect scoreRect = [_scoreModel.Content boundingRectWithSize:CGSizeMake(scoreW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:scoreDic context:nil];
    _scoreLbl.frame = (CGRect){{scoreX, scoreY}, scoreRect.size};
    _scoreLbl.text = _scoreModel.Content;
    
    CGFloat leftH = CGRectGetMaxY(_scoreLbl.frame) + 9 * IPHONE6_H_SCALE;
    _leftView.frame = CGRectMake(20*IPHONE6_W_SCALE, 0, 2*IPHONE6_W_SCALE, leftH);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
