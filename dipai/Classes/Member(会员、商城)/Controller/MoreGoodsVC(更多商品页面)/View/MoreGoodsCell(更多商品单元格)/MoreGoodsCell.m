//
//  MoreGoodsCell.m
//  dipai
//
//  Created by 梁森 on 16/10/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MoreGoodsCell.h"

#import "ShopGoodsModel.h"

#import "Masonry.h"

#import "UIImageView+WebCache.h"
@interface MoreGoodsCell()

@property (nonatomic, strong) UIImageView * picV;

@property (nonatomic, strong) UILabel * titleLbl;

@property (nonatomic, strong) UIView * lineV;

@property (nonatomic, strong) UILabel * numLbl;
// 非会员积分
@property (nonatomic, strong) UILabel * feVIPLbl;
@end

@implementation MoreGoodsCell

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
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpChildControl];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return  self;
}

- (void)setUpChildControl{
    
    // 图片
    UIImageView * picV = [[UIImageView alloc] init];
    [self addSubview:picV];
    _picV = picV;
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
//    titleLbl.backgroundColor = [UIColor redColor];
    titleLbl.font = Font15;
    titleLbl.preferredMaxLayoutWidth = (WIDTH -168 * IPHONE6_W_SCALE);
    [titleLbl setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    titleLbl.numberOfLines = 0;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    // 积分
    UILabel * numLbl = [[UILabel alloc] init];
//    numLbl.backgroundColor = [UIColor greenColor];
    numLbl.font = Font16;
    numLbl.textColor = [UIColor redColor];
    [self addSubview:numLbl];
    _numLbl = numLbl;
    // 非会员积分
    UILabel * feVIPLbl = [[UILabel alloc] init];
//    feVIPLbl.backgroundColor = [UIColor redColor];
    feVIPLbl.font = Font12;
    feVIPLbl.textColor = Color102;
    [self addSubview:feVIPLbl];
    _feVIPLbl = feVIPLbl;
    // 删除线
    UILabel * deleteLbl = [[UILabel alloc] init];
    deleteLbl.backgroundColor = Color102;
    [feVIPLbl addSubview:deleteLbl];
    [deleteLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(feVIPLbl.mas_centerX);
        make.centerY.equalTo(feVIPLbl.mas_centerY);
        make.width.equalTo(feVIPLbl.mas_width).offset(2);
        make.height.equalTo(@(1));
    }];
    // 分割线
    UIView * lineV = [[UIView alloc] init];
    lineV.backgroundColor = Color229;
    [self addSubview:lineV];
    _lineV = lineV;
    
}

- (void)setGoodsModel:(ShopGoodsModel *)goodsModel{
    
    _goodsModel = goodsModel;
    // 图片
    [_picV sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goods_img] placeholderImage:[UIImage imageNamed:@"123"]];
    // 标题
    _titleLbl.text = _goodsModel.goods_name;
    NSMutableAttributedString * numStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"积分：%@", _goodsModel.shop_price]];
    [numStr addAttribute:NSFontAttributeName value:Font12 range:NSMakeRange(0, 3)];
    _numLbl.attributedText = numStr;
    // 非会员积分
    _feVIPLbl.text = @"2000";
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    // 图片
    [_picV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top).offset(5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(130 * IPHONE6_W_SCALE));
        make.height.equalTo(@(172 * 0.5 * IPHONE6_W_SCALE));
    }];
    
    // 积分
    NSMutableDictionary * numDic = [NSMutableDictionary dictionary];
    numDic[NSFontAttributeName] = Font14;
    CGFloat numWidth = [_numLbl.text sizeWithAttributes:numDic].width;
    [_numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_picV.mas_right).offset(12 * IPHONE6_W_SCALE);
        make.bottom.equalTo(self.mas_bottom).offset(- 27 * 0.5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(numWidth));
        make.height.equalTo(@(16 * IPHONE6_H_SCALE));
    }];
    // 非会员积分
    NSMutableDictionary * feNumDic = [NSMutableDictionary dictionary];
    feNumDic[NSFontAttributeName] = Font12;
    CGFloat feWidth = [_feVIPLbl.text sizeWithAttributes:feNumDic].width;
    [_feVIPLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_numLbl.mas_right).offset(8 * IPHONE6_W_SCALE);
        make.bottom.equalTo(_numLbl.mas_bottom).offset(-1);
        make.width.equalTo(@(feWidth+1*IPHONE6_W_SCALE));
        make.height.equalTo(@(12 * IPHONE6_W_SCALE));
    }];
    
    // 标题
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_numLbl.mas_left);
        make.top.equalTo(self.mas_top).offset(13 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-21 * IPHONE6_W_SCALE);
    }];
    
    
    // 分割线
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
//        make.width.equalTo(@(456 * IPHONE6_W_SCALE * 0.5));
        make.left.equalTo(self.mas_left);
        make.height.equalTo(@(0.5));
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
