//
//  ShopCell.m
//  dipai
//
//  Created by 梁森 on 16/10/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ShopCell.h"
// 商城列表模型
#import "ShopListModel.h"
// 商品模型
#import "ShopGoodsModel.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface ShopCell()

{
    NSString * _firstIn;    // 第一次进入的标志
}
// 标题
@property (nonatomic, strong) UILabel * titleLbl;

@end

@implementation ShopCell

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
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self setUpChildControl];
    }
    return self;
    
}
- (void)setUpChildControl{
    
    self.backgroundColor = SeparateColor;
    UIView * topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 83 * 0.5 * IPHONE6_H_SCALE)];
    topV.backgroundColor = [UIColor whiteColor];
    [self addSubview:topV];
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = [UIFont boldSystemFontOfSize:16 * IPHONE6_W_SCALE];
    [self addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(14 * IPHONE6_H_SCALE);
        make.left.equalTo(self.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.width.equalTo(@(WIDTH / 2-15 *IPHONE6_W_SCALE));
        make.height.equalTo(@(16 * IPHONE6_H_SCALE));
    }];
    _titleLbl = titleLbl;
    
    // 更多内容
    UIImageView * moreV = [[UIImageView alloc] init];
    moreV.image = [UIImage imageNamed:@"gengduo"];
    [self addSubview:moreV];
    [moreV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top).offset(33 * 0.5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(6 * IPHONE6_W_SCALE));
        make.height.equalTo(@(11 * IPHONE6_W_SCALE));
    }];
    UILabel * moreLbl = [[UILabel alloc] init];
    //    moreLbl.backgroundColor = [UIColor redColor];
    moreLbl.text = @"更多内容";
    moreLbl.font = Font12;
    moreLbl.textColor = Color153;
    moreLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:moreLbl];
    [moreLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(16 * IPHONE6_H_SCALE);
        make.right.equalTo(moreV.mas_left).offset(-7 * IPHONE6_W_SCALE);
        make.width.equalTo(@(100));
        make.height.equalTo(@(12 * IPHONE6_W_SCALE));
    }];
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:moreBtn];
    //    moreBtn.backgroundColor = [UIColor redColor];
    moreBtn.alpha = 0.5;
    
    [moreBtn addTarget:self action:@selector(seeMoreBenifits) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moreV.mas_right).offset(10);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(moreLbl.mas_left);
        make.bottom.equalTo(moreLbl.mas_bottom).offset(15 * IPHONE6_H_SCALE);
    }];
    
    // 底部分隔线
    UIView * separeV = [[UIView alloc] init];
    separeV.backgroundColor = SeparateColor;
    [self addSubview:separeV];
    [separeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(10 * IPHONE6_H_SCALE));
    }];
}

- (void)seeMoreBenifits{
    
    if ([self.delegate respondsToSelector:@selector(tableviewCell:didClickWithURL:withName:)]) {
        
        [self.delegate tableviewCell:self didClickWithURL:_listModel.url withName:_listModel.name];
    }else{
        NSLog(@"代理没有响应");
    }
}

- (void)setListModel:(ShopListModel *)listModel{
    
    _listModel = listModel;
    // 如果是第一次进入就加载
    if ( _firstIn != nil && _firstIn.length > 0) {
        NSLog(@"不是第一次进入");
    }else{
        
        _titleLbl.text = listModel.name;
        for (int i = 0; i < _listModel.data.count; i ++) {
            
            ShopGoodsModel * goodsModel = [_listModel.data objectAtIndex:i];
            
            int j = i / 2;
            int k = i % 2;
            UIView * backV = [[UIView alloc] initWithFrame:CGRectMake(0 + (WIDTH / 2 + 1.5 * IPHONE6_W_SCALE) * k, 83 * 0.5 * IPHONE6_H_SCALE + (192 * IPHONE6_H_SCALE)*j, WIDTH / 2 - 1.5 * IPHONE6_W_SCALE, 189 * IPHONE6_H_SCALE)];
            backV.backgroundColor = [UIColor whiteColor];
            backV.tag = i;
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeGoodsDetail:)];
            tap.numberOfTouchesRequired = 1;
            [backV addGestureRecognizer:tap];
            
            // 图片
            UIImageView * imageV = [[UIImageView alloc] init];
            [backV addSubview:imageV];
            imageV.frame = CGRectMake(0, 0, 372 * 0.5 * IPHONE6_W_SCALE, 246 * 0.5 * IPHONE6_W_SCALE);
            [imageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.goods_img] placeholderImage:[UIImage imageNamed:@"123"]];
            
            // 文字
            CGFloat nameX = 9 * IPHONE6_W_SCALE;
            CGFloat nameY = 133 * IPHONE6_H_SCALE;
            CGFloat nameW = WIDTH / 2 - 1.5 * IPHONE6_W_SCALE - 18 * IPHONE6_W_SCALE;
            NSMutableDictionary * contentsDic = [NSMutableDictionary dictionary];
            contentsDic[NSFontAttributeName] = Font12;
            CGRect contentsRect = [goodsModel.goods_name boundingRectWithSize:CGSizeMake(nameW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentsDic context:nil];
            UILabel * nameLbl = [[UILabel alloc] init];
            nameLbl.font = Font12;
            nameLbl.numberOfLines = 0;
            nameLbl.frame = (CGRect){{nameX, nameY}, contentsRect.size};
//            nameLbl.backgroundColor = [UIColor redColor];
            nameLbl.textColor = [UIColor blackColor];
            nameLbl.text = goodsModel.goods_name;
            [backV addSubview:nameLbl];
            
            // 积分
            UILabel * numLbl = [[UILabel alloc] init];
            numLbl.textColor = [UIColor redColor];
            numLbl.font = Font12;
            [backV addSubview:numLbl];
            [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backV.mas_left).offset(9 * IPHONE6_W_SCALE);
                make.bottom.equalTo(backV.mas_bottom).offset(-10 * IPHONE6_H_SCALE);
                make.width.equalTo(@(backV.frame.size.width - 18 * IPHONE6_W_SCALE));
                make.height.equalTo(@(12 * IPHONE6_H_SCALE));
            }];
            numLbl.text = [NSString stringWithFormat:@"积分：%@", goodsModel.shop_price];
            [self addSubview:backV];
        }
        
    }
    _firstIn = @"firstIn";
}

// 跳转到商品详情页
- (void)seeGoodsDetail:(UIGestureRecognizer *)tap{
    
    UIView * view = tap.view;
    ShopGoodsModel * goodsModel = [_listModel.data objectAtIndex:view.tag];
    if ([self.delegate respondsToSelector:@selector(tableviewCell:didClickWithURL:withTitle:)]) {
        
        [self.delegate tableviewCell:self didClickWithURL:goodsModel.wapurl withTitle:goodsModel.goods_name];
    }else{
        
        NSLog(@"代理没有响应");
    }
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
