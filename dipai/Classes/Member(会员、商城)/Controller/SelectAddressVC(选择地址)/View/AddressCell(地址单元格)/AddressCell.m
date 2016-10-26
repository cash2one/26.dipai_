//
//  AddressCell.m
//  dipai
//
//  Created by 梁森 on 16/10/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AddressCell.h"

#import "Masonry.h"
#import "AddressModel.h"
@implementation AddressCell

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
    
    // 分割线
    UIView * separateV = [[UIView alloc] init];
    separateV.backgroundColor = Color229;
    [self addSubview:separateV];
    _separateV = separateV;
    
    // 姓名和电话号码
    UILabel * namePhoneLbl = [[UILabel alloc] init];
    namePhoneLbl.font = Font15;
    [self addSubview:namePhoneLbl];
    _namePhoneLbl = namePhoneLbl;
    
    // 地址
    UILabel * addressLbl = [[UILabel alloc] init];
    addressLbl.font = Font13;
    addressLbl.textColor = Color102;
    addressLbl.preferredMaxLayoutWidth = WIDTH - 65 * IPHONE6_W_SCALE;
    [addressLbl setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    addressLbl.numberOfLines = 0;
    [self addSubview:addressLbl];
    _addressLbl = addressLbl;
    
    // 选择标记
    UIImageView * flagV = [[UIImageView alloc] init];
    flagV.image = [UIImage imageNamed:@"xuanzedizhi"];
    flagV.hidden = YES;
    [self addSubview:flagV];
    _flagV = flagV;
}

- (void)setAddressModel:(AddressModel *)addressModel{
    
    _addressModel = addressModel;
    // 姓名和电话号码
    _namePhoneLbl.text = [NSString stringWithFormat:@"%@  %@", addressModel.address_name, addressModel.mobile];
    // 地址
    _addressLbl.text = [NSString stringWithFormat:@"%@%@", addressModel.district, addressModel.address];
    [_addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.right.equalTo(self.mas_right).offset(-50 * IPHONE6_W_SCALE);
        make.top.equalTo(_namePhoneLbl.mas_bottom).offset(10 * IPHONE6_H_SCALE);
    }];
    
    if ([addressModel.defaultS isEqualToString:@"1"]) {
        _flagV.hidden = NO;
    }else{
        _flagV.hidden = YES;
    }
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    // 分割线
    _separateV.frame = CGRectMake(0, 0, WIDTH, 0.5);
    
    // 姓名和电话号码
    [_namePhoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top).offset(19 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 15 * IPHONE6_W_SCALE));
        make.height.equalTo(@(15 * IPHONE6_H_SCALE + 2));
    }];
    
    // 地址
    
    // 选择标记
    [_flagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.width.equalTo(@(22 * IPHONE6_W_SCALE));
        make.height.equalTo(@(22 * IPHONE6_W_SCALE));
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
