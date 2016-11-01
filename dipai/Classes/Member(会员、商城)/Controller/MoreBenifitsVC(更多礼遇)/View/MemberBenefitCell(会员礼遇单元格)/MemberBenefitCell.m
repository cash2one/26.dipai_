//
//  MemberBenefitCell.m
//  dipai
//
//  Created by 梁森 on 16/10/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MemberBenefitCell.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface MemberBenefitCell ()

{
    
    NSString * _firstIn;    // 第一次传值的标识
}

@end

@implementation MemberBenefitCell

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
    
    NSLog(@"创建。。。");
    
    // 会员等级名称
    UILabel * levelName = [[UILabel alloc] init];
    levelName.font = Font16;
    [self addSubview:levelName];
    [levelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@(WIDTH - 30 * IPHONE6_W_SCALE));
        make.height.equalTo(@(43 * IPHONE6_H_SCALE));
    }];
    levelName.tag = 1000;
    _levelName = levelName;
    
    //
    UIView * lineV = [[UIView alloc] init];
    lineV.backgroundColor = Color229;
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(levelName.mas_bottom);
        make.height.equalTo(@(1));
    }];
    lineV.tag = 1001;
    _lineV = lineV;
    
    // 分割线
    UIView * separateV = [[UIView alloc] init];
    separateV.backgroundColor = SeparateColor;
    [self addSubview:separateV];
    [separateV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(20 * IPHONE6_H_SCALE));
    }];
    separateV.tag = 1002;
}

- (void)setLevelArr:(NSArray *)levelArr{

    // 暂时实现功能，但并不完美，每次都会创建新的视图
    // 调用此方法只创建一次子控件就好
    _levelArr = levelArr;
    
    if (_firstIn != nil && _firstIn.length > 0) {
        NSLog(@"不是第一次进来不再创建");
    }else{
    
        // 礼遇内容
        for (int i = 0; i < _levelArr.count ; i ++) {
            int j = i / 3;
            int k = i % 3;
            UIImageView * imgBackV = [[UIImageView alloc] initWithFrame:CGRectMake(0 + WIDTH / 3 * k, 87 * 0.5 * IPHONE6_H_SCALE + 112 * IPHONE6_H_SCALE *j , WIDTH / 3, 112 * IPHONE6_H_SCALE)];
            imgBackV.userInteractionEnabled = YES;
            imgBackV.backgroundColor = [UIColor whiteColor];
            imgBackV.tag = i;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBeneDetail:)];
            [imgBackV addGestureRecognizer:tap];
            tap.numberOfTouchesRequired = 1;
            [self addSubview:imgBackV];
            
            UIImageView * imgV = [[UIImageView alloc] init];
            imgV.layer.cornerRadius = 35 * IPHONE6_W_SCALE;
            imgV.layer.masksToBounds = YES;
            [imgBackV addSubview:imgV];
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imgBackV.mas_centerX);
                make.top.equalTo(imgBackV.mas_top).offset(13 * IPHONE6_H_SCALE);
                make.width.equalTo(@(70 * IPHONE6_W_SCALE));
                make.height.equalTo(@(70 * IPHONE6_W_SCALE));
            }];
            NSDictionary * dic = [_levelArr objectAtIndex:i];
            NSString * picName = dic[@"picname"];
            
            [imgV sd_setImageWithURL:[NSURL URLWithString:picName] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            UILabel * titleLbl = [[UILabel alloc] init];
            titleLbl.textColor = [UIColor blackColor];
            titleLbl.text = dic[@"name"];
            titleLbl.textAlignment = NSTextAlignmentCenter;
            [imgBackV addSubview:titleLbl];
            [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imgBackV.mas_centerX);
                make.bottom.equalTo(imgBackV.mas_bottom);
                make.width.equalTo(imgBackV.mas_width);
                make.height.equalTo(@(17 * IPHONE6_W_SCALE));
            }];
        }

    }
    
    _firstIn = @"first";
    
//    for (UIImageView * imageV in self.subviews ) {
//        if (imageV.tag == 1000 || imageV.tag == 1001 || imageV.tag == 1002) {
//           
//        }else{
//            
//             [imageV removeFromSuperview];
//        }
//        
//    }
}

- (void)setLevel:(NSString *)level{
    
    _level = level;
    _levelName.text = [NSString stringWithFormat:@"V%@会员", _level];
    
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
}

- (void)seeBeneDetail:(UIGestureRecognizer *)tap{
    
    UIView * view = tap.view;
    if ([self.delegate respondsToSelector:@selector(MemberBenefitCell:didClickWithTag:)]) {
        [self.delegate MemberBenefitCell:self didClickWithTag:view.tag];
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
