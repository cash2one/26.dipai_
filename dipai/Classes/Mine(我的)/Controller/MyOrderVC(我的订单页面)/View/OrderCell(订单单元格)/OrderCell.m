//
//  OrderCell.m
//  dipai
//
//  Created by 梁森 on 16/10/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "OrderCell.h"
// 订单模型
#import "OrderModel.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface OrderCell()

@property (nonatomic, strong) UIView * topV;
@property (nonatomic, strong) UILabel * orderNumLbl ;
@property (nonatomic, strong) UILabel * orderStateLbl;
@property (nonatomic, strong) UIView * lineV;
@property (nonatomic, strong) UIImageView * picV;
@property (nonatomic, strong) UILabel * goodsNameLbl;
@property (nonatomic, strong) UILabel * goodsNumLbl;
@property (nonatomic, strong) UIButton * serverBtn ;
@property (nonatomic, strong) UIView * separateV ;

@end

@implementation OrderCell

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
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return  self;
}
- (void)setUpChildControl{
    
    UIView * topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40 * IPHONE6_H_SCALE)];
    topV.backgroundColor = [UIColor whiteColor];
    [self addSubview:topV];
    _topV = topV;
    // 订单号
    UILabel * orderNumLbl = [[UILabel alloc] init];
    orderNumLbl.font = Font13;
    [topV addSubview:orderNumLbl];
    _orderNumLbl = orderNumLbl;
    // 订单状态
    UILabel * orderStateLbl = [[UILabel alloc] init];
    orderStateLbl.font = Font14;
    orderStateLbl.textColor = [UIColor redColor];
    orderStateLbl.textAlignment = NSTextAlignmentRight;
    [topV addSubview:orderStateLbl];
    _orderStateLbl = orderStateLbl;
    // 细线
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 40 * IPHONE6_H_SCALE, WIDTH, 0.5)];
    lineV.backgroundColor = Color229;
    [self addSubview:lineV];
    _lineV = lineV;
    
    // 图片
    UIImageView * picV = [[UIImageView alloc] init];
    [self addSubview:picV];
    _picV = picV;
    // 商品名称
    UILabel * goodsNameLbl = [[UILabel alloc] init];
    goodsNameLbl.font = Font12;
    goodsNameLbl.preferredMaxLayoutWidth = WIDTH - 152 * IPHONE6_W_SCALE;
    [goodsNameLbl setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    goodsNameLbl.numberOfLines = 0;
    [self addSubview:goodsNameLbl];
    _goodsNameLbl = goodsNameLbl;
    // 积分
    UILabel * goodsNumLbl = [[UILabel alloc] init];
    goodsNumLbl.font = Font14;
    goodsNumLbl.textColor = [UIColor redColor];
    [self addSubview:goodsNumLbl];
    _goodsNumLbl = goodsNumLbl;
    // 联系客服按钮
    UIButton * serverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [serverBtn addTarget:self action:@selector(getServerAction ) forControlEvents:UIControlEventTouchUpInside];
    [serverBtn setImage:[UIImage imageNamed:@"lianxikefu"] forState:UIControlStateNormal];
    [self addSubview:serverBtn];
    _serverBtn = serverBtn;
    // 分割线
    UIView * separateV = [[UIView alloc] init];
    separateV.backgroundColor = SeparateColor;
    [self addSubview:separateV];
    _separateV = separateV;

}
- (void)getServerAction{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickWithId:)]) {
        [self.delegate tableViewCell:self didClickWithId:_orderModel.order_id];
    }else{
        NSLog(@"代理没有响应...");
    }
}

- (void)setOrderModel:(OrderModel *)orderModel{
    
    _orderModel = orderModel;
    [self setData];
}

- (void)setData{
    
    _orderNumLbl.text = [NSString stringWithFormat:@"订单编号:%@", _orderModel.discount];
    
    NSString * status =  _orderModel.shipping_status;
    if ([status isEqualToString:@"0"]) {
        _orderStateLbl.text = @"未发货";
    }else if ([status isEqualToString:@"1"]){
        _orderStateLbl.text = @"已发货";
    }else{
        _orderStateLbl.text = @"确认完成";
    }
    
    [_picV sd_setImageWithURL:[NSURL URLWithString:_orderModel.goods_img] placeholderImage:[UIImage imageNamed:@"123"]];
    
    _goodsNameLbl.text = _orderModel.goods_name;
    
    NSMutableAttributedString * numText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"积分：%@", _orderModel.shop_price]];
    [numText addAttribute:NSFontAttributeName value:Font12 range:NSMakeRange(0, 3)];
    _goodsNumLbl.attributedText = numText;;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    // 订单号
    _orderNumLbl.frame = CGRectMake(15 * IPHONE6_W_SCALE, 0, WIDTH - 15 * IPHONE6_W_SCALE, 40 * IPHONE6_H_SCALE);
    // 订单状态
    [_orderStateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topV.mas_right).offset(-16 * IPHONE6_W_SCALE);
        make.top.equalTo(_topV.mas_top);
        make.bottom.equalTo(_topV.mas_bottom);
        make.width.equalTo(@(100 * IPHONE6_W_SCALE));
    }];
    // 细线
    
    // 图片
    [_picV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(_lineV.mas_bottom).offset(10 * IPHONE6_H_SCALE);
        make.width.equalTo(@(113 * IPHONE6_W_SCALE));
        make.height.equalTo(@(75 * IPHONE6_W_SCALE));
    }];
    // 商品名称
    [_goodsNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_picV.mas_right).offset(12 * IPHONE6_W_SCALE);
        make.top.equalTo(_picV.mas_top).offset(3 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-15 * IPHONE6_W_SCALE);
    }];
    // 积分
    [_goodsNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsNameLbl.mas_left);
        make.bottom.equalTo(_picV.mas_bottom);
        make.width.equalTo(@(135 * IPHONE6_W_SCALE));
        make.height.equalTo(@(14 * IPHONE6_W_SCALE));
    }];
    // 联系客服按钮
    [_serverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.bottom.equalTo(_goodsNumLbl.mas_bottom).offset(5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(156 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(22 * IPHONE6_W_SCALE));
    }];
    // 分割线
    [_separateV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(10 * IPHONE6_H_SCALE));
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
