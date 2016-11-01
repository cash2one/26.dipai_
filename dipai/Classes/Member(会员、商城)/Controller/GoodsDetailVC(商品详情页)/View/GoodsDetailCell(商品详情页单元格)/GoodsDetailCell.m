//
//  GoodsDetailCell.m
//  dipai
//
//  Created by 梁森 on 16/10/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "GoodsDetailCell.h"

#import "GoodsDetailModel.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface GoodsDetailCell()<UIScrollViewDelegate>

// 上方的图片banner图
@property (nonatomic, strong) UIScrollView * scrollV;
// 图片的标志符号
@property (nonatomic, strong) UILabel * tagLbl;
// 商品名称
@property (nonatomic, strong)  UILabel * nameLbl;
// 商品积分
@property (nonatomic, strong) UILabel * numLbl;
// 商品详情
@property (nonatomic, strong) UILabel * detailLbl;

@property (nonatomic, strong) UIView * topV;
@property (nonatomic, strong) UIView * line;

@end

@implementation GoodsDetailCell

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
    
    if (self == [super initWithStyle: style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpChildControl];
    }
    return self;
}

- (void)setUpChildControl{
    
    // 上方的banner图
    UIScrollView * scrollV = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, WIDTH, 375 * IPHONE6_W_SCALE)];
//    scrollV.backgroundColor = [UIColor redColor];
    scrollV.pagingEnabled = YES;
    scrollV.delegate = self;
    [self addSubview:scrollV];
    _scrollV = scrollV;
    // 标志符号
    UILabel * tagLbl = [[UILabel alloc] init];
    tagLbl.text = @"1/2";
    tagLbl.backgroundColor = [UIColor blackColor];
    tagLbl.alpha = 0.38;
    tagLbl.textColor = [UIColor whiteColor];
    tagLbl.font = Font11;
    tagLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tagLbl];
    [tagLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(scrollV.mas_right).offset(-12 * IPHONE6_W_SCALE);
        make.bottom.equalTo(scrollV.mas_bottom).offset(-12 * IPHONE6_W_SCALE);
        make.width.equalTo(@(40 * IPHONE6_W_SCALE));
        make.height.equalTo(@(40 * IPHONE6_W_SCALE));
    }];
    tagLbl.layer.cornerRadius = 20 * IPHONE6_W_SCALE;
    tagLbl.layer.masksToBounds = YES;
    _tagLbl = tagLbl;
    
    UIView * topV = [[UIView alloc] init];
    [self addSubview:topV];
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(scrollV.mas_bottom);
        make.height.equalTo(@(92 * IPHONE6_H_SCALE));
    }];
    _topV = topV;
    
    // 商品名称
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.numberOfLines = 0;
    nameLbl.font = Font14;
    nameLbl.preferredMaxLayoutWidth = WIDTH - 30 * IPHONE6_W_SCALE;
    [nameLbl setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [topV addSubview:nameLbl];
    _nameLbl = nameLbl;
    
    // 商品积分
    UILabel * numLbl = [[UILabel alloc] init];
    numLbl.font = [UIFont boldSystemFontOfSize:21 * IPHONE6_W_SCALE];
    numLbl.textColor = [UIColor redColor];
    [topV addSubview:numLbl];
    [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topV.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.bottom.equalTo(topV.mas_bottom).offset(-18 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 15 * IPHONE6_W_SCALE));
        make.height.equalTo(@(21 * IPHONE6_H_SCALE));
    }];
    _numLbl = numLbl;
    
    // 分割线1
    UIView * lineV1 = [[UIView alloc] init];
    lineV1.backgroundColor = SeparateColor;
    [self addSubview:lineV1];
    [lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(topV.mas_bottom);
        make.height.equalTo(@(20 * IPHONE6_H_SCALE));
    }];
    
    // 商品详情
    UILabel * deTitleLbl = [[UILabel alloc] init];
    deTitleLbl.text = @"商品详情";
    deTitleLbl.font = Font16;
    [self addSubview:deTitleLbl];
    [deTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(lineV1.mas_bottom);
        make.height.equalTo(@(83 * 0.5 * IPHONE6_W_SCALE));
    }];
    UIView * line = [[UIView alloc] init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(deTitleLbl.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
    _line = line;
    UILabel * detailLbl = [[UILabel alloc] init];
    detailLbl.font = Font13;
    detailLbl.textColor = RGBA(51, 51, 51, 1);
    detailLbl.numberOfLines = 0;
    [self addSubview:detailLbl];
    _detailLbl = detailLbl;

}

- (void)setDetailModel:(GoodsDetailModel *)detailModel{
    
    _detailModel = detailModel;
    
    _scrollV.contentSize = CGSizeMake(WIDTH * _detailModel.atlas.count, 0);
    for (int i = 0; i < _detailModel.atlas.count; i ++) {
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0+ i * WIDTH, 0 , WIDTH, 375 * IPHONE6_W_SCALE)];
        imgV.backgroundColor = [UIColor greenColor];
        [_scrollV addSubview:imgV];
       
        imgV.userInteractionEnabled = YES;
        [imgV sd_setImageWithURL:[NSURL URLWithString:_detailModel.atlas[i]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
    }
    
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"1/%lu", _detailModel.atlas.count]];
    [attributeStr addAttribute:NSFontAttributeName value:Font16 range:NSMakeRange(0, 1)];
    _tagLbl.attributedText = attributeStr;
    
    // 商品名称
    _nameLbl.text = _detailModel.goods_name;
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(_topV.mas_top).offset(13 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-15 * IPHONE6_W_SCALE);
    }];
    
    // 商品积分
    NSMutableAttributedString * numText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"积分：%@", _detailModel.shop_price]];
    [numText addAttribute:NSFontAttributeName value:Font15 range:NSMakeRange(0, 3)];
    _numLbl.attributedText = numText;
    
    // 商品详情
    _detailLbl.text = _detailModel.goods_desc;
    [_detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.right.equalTo(self.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.top.equalTo(_line.mas_bottom);
    }];
}
#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    NSLog(@"---%f", scrollView.contentOffset.x);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"///---%f", scrollView.contentOffset.x);
    int x = scrollView.contentOffset.x / WIDTH + 1;
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d/%lu",x, _detailModel.atlas.count]];
    [attributeStr addAttribute:NSFontAttributeName value:Font16 range:NSMakeRange(0, 1)];
    _tagLbl.attributedText = attributeStr;
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
