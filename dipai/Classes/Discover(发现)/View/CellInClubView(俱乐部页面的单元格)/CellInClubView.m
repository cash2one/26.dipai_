//
//  CellInClubView.m
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CellInClubView.h"

#import "UIImageView+WebCache.h"
@interface CellInClubView()
/**
 *  封面图
 */
@property (nonatomic, strong) UIImageView * picView;
/**
 *  俱乐部名称
 */
@property (nonatomic, strong) UILabel * nameLbl;
/**
 *  地址
 */
@property (nonatomic, strong) UILabel * addressLbl;
/**
 *  地址图片
 */
@property (nonatomic, strong) UIImageView * addressView;
/**
 *  分割线
 */
@property (nonatomic, strong) UIView * separateView;

@end

@implementation CellInClubView

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
        self.backgroundColor = Color248;
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
    
    // 俱乐部名称
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.font = Font16;
    nameLbl.textColor = [UIColor blackColor];
    [self addSubview:nameLbl];
    _nameLbl = nameLbl;
    
    
    // 俱乐部地址
    UILabel * addressLbl = [[UILabel alloc] init];
    addressLbl.font = Font12;
    addressLbl.textColor = Color153;
    [self addSubview:addressLbl];
    _addressLbl = addressLbl;
    // 地址图标
    UIImageView * addressView = [[UIImageView alloc] init];
    addressView.image = [UIImage imageNamed:@"zuobiao"];
    [self addSubview:addressView];
    _addressView = addressView;
    
    // 分割线
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    [self addSubview:separateView];
    _separateView = separateView;
    
}

- (void)setClubModel:(ClubModel *)clubModel{
    _clubModel = clubModel;
    
}

#pragma mark --- 对子控件进行布局
- (void)layoutSubviews{
    [super layoutSubviews];
    // 封面图
    CGFloat picX = 0;
    CGFloat picY = 0;
    CGFloat picW = WIDTH;
    CGFloat picH = 330 * 0.5 * IPHONE6_W_SCALE;
    _picView.frame = CGRectMake(picX, picY, picW, picH);
    [_picView sd_setImageWithURL:[NSURL URLWithString:_clubModel.picname] placeholderImage:[UIImage imageNamed:@"123"]];
    
    // 俱乐部名称
    CGFloat nameX = Margin40 * IPHONE6_W_SCALE;
    CGFloat nameY = CGRectGetMaxY(_picView.frame) + Margin16 * IPHONE6_H_SCALE;
    CGFloat nameW = 150;
    CGFloat nameH = 16;
    _nameLbl.frame = CGRectMake(nameX, nameY, nameW, nameH);
    _nameLbl.text = _clubModel.title;
    [_nameLbl sizeToFit];
    

    // 地址图标
    CGFloat addressViewX = nameX;
    CGFloat addressViewY = CGRectGetMaxY(_nameLbl.frame) + 18 * 0.5 * IPHONE6_H_SCALE;
    CGFloat addressViewW = Margin20 * IPHONE6_W_SCALE;
    CGFloat addressViewH = 28 * 0.5 * IPHONE6_W_SCALE;
    _addressView.frame = CGRectMake(addressViewX, addressViewY, addressViewW, addressViewH);
//    _addressView.image = [UIImage imageNamed:@"zuobiao"];
    // 俱乐部地址
    CGFloat addressX = CGRectGetMaxX(_addressView.frame) + Margin14 * IPHONE6_W_SCALE;
    CGFloat addressY = CGRectGetMaxY(_nameLbl.frame) + Margin20 * IPHONE6_H_SCALE;
    CGFloat addressW = WIDTH - addressX;
    CGFloat addressH = 12;
    _addressLbl.frame = CGRectMake(addressX, addressY, addressW, addressH);
    _addressLbl.text = _clubModel.address;
    [_addressLbl sizeToFit];
    
    // 分割线
    CGFloat separateX = 0;
    CGFloat separateY = CGRectGetMaxY(_picView.frame) + 110 * 0.5 * IPHONE6_H_SCALE;
    CGFloat separateW = WIDTH;
    CGFloat separateH = Margin14 * IPHONE6_H_SCALE;
    _separateView.frame = CGRectMake(separateX, separateY, separateW, separateH);
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
