//
//  NumberDetailCell.m
//  dipai
//
//  Created by 梁森 on 16/10/28.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NumberDetailCell.h"
#import "NumberDetailModel.h"

#import "Masonry.h"

@interface NumberDetailCell()
//
@property (nonatomic, strong) UIView * topV;
// 收入／支出
@property (nonatomic, strong)  UILabel * typeLbl ;
// 余额
@property (nonatomic, strong) UILabel * balanceLbl;
// 日期
@property (nonatomic, strong) UILabel * dateLbl ;
// 收入／支出数目
@property (nonatomic, strong)  UILabel * inOrOutLbl ;
//
@property (nonatomic, strong) UIView * detailV ;
// 详情
@property (nonatomic, strong) UILabel * detailLbl ;

@property (nonatomic, strong) UILabel * flagLbl ;

@end

@implementation NumberDetailCell

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
    
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpChildControl];
        self.backgroundColor = SeparateColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUpChildControl{
    
    UIView * topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 55 * IPHONE6_H_SCALE + 0.5)];
    topV.backgroundColor = [UIColor whiteColor];
    [self addSubview:topV];
    _topV = topV;
    
    UILabel * typeLbl = [[UILabel alloc] init]; // 支出或是收入
    typeLbl.font = Font14;
    [topV addSubview:typeLbl];
    [typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topV.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(topV.mas_top).offset(14 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH / 2 -15 * IPHONE6_W_SCALE));
        make.height.equalTo(@(14 * IPHONE6_H_SCALE));
    }];
    _typeLbl = typeLbl;
    
    // 余额
    UILabel * balanceLbl = [[UILabel alloc] init];
    balanceLbl.font = Font12;
    [topV addSubview:balanceLbl];
    [balanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLbl.mas_left);
        make.top.equalTo(typeLbl.mas_bottom).offset(7 * IPHONE6_H_SCALE);
        make.width.equalTo(typeLbl.mas_width);
        make.height.equalTo(@(12 * IPHONE6_H_SCALE));
    }];
    _balanceLbl = balanceLbl;
    
//    typeLbl.backgroundColor = [UIColor greenColor];
//    balanceLbl.backgroundColor = [UIColor redColor];
    
    // 日期
    UILabel * dateLbl = [[UILabel alloc] init];
    dateLbl.textAlignment = NSTextAlignmentRight;
    dateLbl.font = Font12;
    dateLbl.textColor = Color153;
    [topV addSubview:dateLbl];
    [dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topV.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.top.equalTo(topV.mas_top).offset(18 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH / 2 -15 * IPHONE6_W_SCALE));
        make.height.equalTo(@(12 * IPHONE6_H_SCALE));
    }];
    _dateLbl = dateLbl;
    
    // 收入／支出的积分数
    UILabel * inOrOutLbl = [[UILabel alloc] init];
    inOrOutLbl.textAlignment = NSTextAlignmentRight;
    inOrOutLbl.font = [UIFont fontWithName:@"Helvetica" size:15 * IPHONE6_W_SCALE];
    [topV addSubview:inOrOutLbl];
    [inOrOutLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dateLbl.mas_right);
        make.width.equalTo(dateLbl.mas_width);
        make.top.equalTo(dateLbl.mas_bottom).offset(7 * IPHONE6_H_SCALE);
        make.height.equalTo(@(15 * IPHONE6_H_SCALE));
    }];
    _inOrOutLbl = inOrOutLbl;
    UIView * bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = Color229;
    [topV addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topV.mas_left);
        make.right.equalTo(topV.mas_right);
        make.bottom.equalTo(topV.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
    
    UIView * detailV = [[UIView alloc] init];
    detailV.backgroundColor = [UIColor whiteColor];
//    detailV.backgroundColor = [UIColor redColor];
    [self addSubview:detailV];
    _detailV = detailV;
    
    UILabel * detailLbl = [[UILabel alloc] init];
    detailLbl.numberOfLines = 0;
//    detailLbl.backgroundColor = [UIColor greenColor];
    detailLbl.font = Font12;
    detailLbl.textColor = Color153;
    [detailV addSubview:detailLbl];
    _detailLbl = detailLbl;
    
    // 标记：支出／收入
    UILabel * flagLbl = [[UILabel alloc] init];
//    flagLbl.backgroundColor = [UIColor redColor];
    flagLbl.textColor = Color153;
    flagLbl.font = Font12;
    [detailV addSubview:flagLbl];
    _flagLbl = flagLbl;
}

- (void)setDetailModel:(NumberDetailModel *)detailModel{
    
    _detailModel = detailModel;
    _detailLbl.text = _detailModel.content;
    
    _typeLbl.text = _detailModel.type;
    _inOrOutLbl.text = _detailModel.extcredits1;
    _balanceLbl.text = [NSString stringWithFormat:@"余额：%@", _detailModel.extcredits2];
    _dateLbl.text = _detailModel.datetime;
    
    float inOrtOut = [_inOrOutLbl.text floatValue];
    if (inOrtOut > 0) {
        _flagLbl.text = @"积分来源：";
    }else{
        _flagLbl.text = @"支出详情：";
    }
//    NSLog(@"%@", _detailModel.type);
    if ([_detailModel.type isEqualToString:@"商城支出"]) {
        _flagLbl.text = @"支出详情：";
    }else{
        _flagLbl.text = @"积分来源：";
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    NSString * detailStr = _detailModel.content;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = Font12;
    CGRect detailRect = [detailStr boundingRectWithSize:CGSizeMake(WIDTH - 90 * IPHONE6_W_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGFloat detailH = detailRect.size.height;
    _detailLbl.frame = CGRectMake(75 * IPHONE6_W_SCALE, 10 * IPHONE6_H_SCALE, WIDTH - 90 * IPHONE6_W_SCALE, detailH);
    
    CGFloat detailVY = CGRectGetMaxY(_topV.frame);
    CGFloat detailVH = 47 * 0.5 * IPHONE6_H_SCALE + detailH;
    _detailV.frame = CGRectMake(0, detailVY, WIDTH, detailVH);
//    [_detailV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.top.equalTo(_topV.mas_bottom);
//        make.height.equalTo(@(47 * 0.5 * IPHONE6_H_SCALE + detailH));
//    }];
    
    [_flagLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(_topV.mas_bottom).offset(10 * IPHONE6_H_SCALE + 2);
        make.width.equalTo(@(80 * IPHONE6_W_SCALE));
        make.height.equalTo(@(12 * IPHONE6_H_SCALE));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
