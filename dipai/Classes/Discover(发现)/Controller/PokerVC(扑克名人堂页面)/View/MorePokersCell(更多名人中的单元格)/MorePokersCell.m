//
//  MorePokersCell.m
//  dipai
//
//  Created by 梁森 on 16/6/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MorePokersCell.h"

#import "MorePokersModel.h"

#import "UIImageView+WebCache.h"

#import "Masonry.h"
@interface MorePokersCell()
/**
 *  头像
 */
@property (nonatomic, strong) UIImageView * faceView;

/**
 *  姓名
 */
@property (nonatomic, strong) UILabel * nameLbl;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel * titleLbl;
/**
 *  简介
 */
@property (nonatomic, strong) UILabel * briefLbl;

/**
 *  底部横线
 */
@property (nonatomic, strong) UIView * line;

@end

@implementation MorePokersCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
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

- (void)setMorePokersModel:(MorePokersModel *)morePokersModel{
    _morePokersModel = morePokersModel;
}

- (void)setUpChildControl{
    
    // 头像
    UIImageView * faceView = [[UIImageView alloc] init];
    faceView.layer.masksToBounds = YES;
    faceView.layer.cornerRadius = 25 * IPHONE6_W_SCALE;
    [self addSubview:faceView];
    _faceView = faceView;
    // 跳转个人主页
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStarVC:)];
    faceView.userInteractionEnabled = YES;
    [faceView addGestureRecognizer:tap];
    
    //  姓名
    UILabel * nameLbl = [[UILabel alloc] init];
//    nameLbl.backgroundColor = [UIColor yellowColor];
    nameLbl.font = Font16;
    nameLbl.textColor = [UIColor redColor];
    [self addSubview:nameLbl];
    _nameLbl = nameLbl;
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
//    titleLbl.backgroundColor = [UIColor greenColor];
    titleLbl.font = Font12;
    titleLbl.textColor = Color123;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    // 简介
    UILabel * briefLbl = [[UILabel alloc] init];
//    briefLbl.backgroundColor = [UIColor blueColor];
    briefLbl.font = Font12;
    briefLbl.textColor = Color123;
    [self addSubview:briefLbl];
    _briefLbl = briefLbl;
    
    // 关注按钮
    UIButton * attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [attentionBtn setImage:[UIImage imageNamed:@"icon_jiaguanzhu"] forState:UIControlStateNormal];
    [attentionBtn addTarget:self action:@selector(attentionAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:attentionBtn];
    _attentionBtn = attentionBtn;
    
    // 底部横线
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
    [self addSubview:line];
    _line = line;
}

#pragma mark --- 关注按钮的点击事件
- (void)attentionAction{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedWithModel:)]) {
        [self.delegate tableViewCell:self didClickedWithModel:_morePokersModel];
    } else{
        NSLog(@"MorePokersCell的代理没有响应...");
    }
}
#pragma mark --- 跳转到个人主页
- (void)showStarVC:(UIGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickFaceWith:)]) {
        [self.delegate tableViewCell:self didClickFaceWith:_morePokersModel];
    } else{
        NSLog(@"点击头像时，MorePokersCell的代理没有响应...");
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 头像
    CGFloat faceX = Margin30 * IPHONE6_W_SCALE;
    CGFloat faceY = 12 * IPHONE6_H_SCALE;
    _faceView.frame = CGRectMake(faceX, faceY, 50 * IPHONE6_W_SCALE, 50 * IPHONE6_W_SCALE);
    [_faceView sd_setImageWithURL:[NSURL URLWithString:_morePokersModel.face] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    
    //  姓名
    CGFloat nameX = CGRectGetMaxX(_faceView.frame) + 11 * IPHONE6_W_SCALE;
    CGFloat nameY = faceY;
    _nameLbl.frame = CGRectMake(nameX, nameY, WIDTH-nameX, 16 * IPHONE6_W_SCALE);
    _nameLbl.text = _morePokersModel.username;
    
    // 标题
    CGFloat titleX = nameX;
    CGFloat titleY = CGRectGetMaxY(_nameLbl.frame) + 7 * IPHONE6_H_SCALE;
    _titleLbl.frame = CGRectMake(titleX, titleY, WIDTH-titleX, 12*IPHONE6_W_SCALE);
    _titleLbl.text = _morePokersModel.title;
    
    // 简介
    CGFloat briefX = nameX;
    CGFloat briefY = CGRectGetMaxY(_titleLbl.frame) + 5 * IPHONE6_H_SCALE;
    _briefLbl.frame = CGRectMake(briefX, briefY, WIDTH-briefX, 12*IPHONE6_W_SCALE);
    _briefLbl.text= _morePokersModel.brief;
    
    // 关注按钮
    [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(46 * IPHONE6_W_SCALE));
        make.height.equalTo(@(31 * IPHONE6_W_SCALE));
    }];
    
    NSLog(@"model.relation:%@", _morePokersModel.relation);
    
    // 底部横线
    _line.frame = CGRectMake(0, 74 * IPHONE6_H_SCALE, WIDTH, 0.5);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
