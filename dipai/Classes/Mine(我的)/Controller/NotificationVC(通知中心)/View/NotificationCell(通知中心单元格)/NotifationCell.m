//
//  NotifationCell.m
//  dipai
//
//  Created by 梁森 on 16/10/27.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NotifationCell.h"

#import "Masonry.h"
@interface NotifationCell()

@property (nonatomic, strong) UILabel * timeLbl ;

@property (nonatomic, strong) UIView * contentV ;

@property (nonatomic, strong) UILabel * contentLbl ;

@end

@implementation NotifationCell

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
        
        self.backgroundColor = SeparateColor;
    }
    return  self;
}

- (void)setUpChildControl{
    
    // 时间
    UILabel * timeLbl = [[UILabel alloc] init];
    timeLbl.font = Font11;
    timeLbl.textColor = [UIColor whiteColor];
    timeLbl.textAlignment = NSTextAlignmentCenter;
    timeLbl.backgroundColor = RGBA(190, 190, 190, 1);
    timeLbl.layer.cornerRadius = 3;
    timeLbl.layer.masksToBounds = YES;
    [self addSubview:timeLbl];
    _timeLbl = timeLbl;
    
    // 内容
    UIView * contentV = [[UIView alloc] init];
    contentV.backgroundColor = [UIColor whiteColor];
    contentV.layer.cornerRadius = 5;
    contentV.layer.masksToBounds = YES;
    contentV.layer.borderColor = Color216.CGColor;
    contentV.layer.borderWidth = 0.5;
    [self addSubview:contentV];
    _contentV = contentV;
    
    UILabel * contentLbl = [[UILabel alloc] init];
    contentLbl.font = Font14;
    contentLbl.numberOfLines = 0;
    [contentV addSubview:contentLbl];
    _contentLbl = contentLbl;
    
}

- (void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
}

// 内容视图的高度需要获取到数据之后才能确定
- (void)layoutSubviews{
    
    [super layoutSubviews];
#warning 假数据
    NSString * timeStr = @"2016-9-10";
    NSMutableDictionary * timeDic = [NSMutableDictionary dictionary];
    timeDic[NSFontAttributeName] = Font11;
    CGSize timeSize = [timeStr sizeWithAttributes:timeDic];
    _timeLbl.text = timeStr;
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(15 * IPHONE6_H_SCALE);
        make.width.equalTo(@(timeSize.width + 14 * IPHONE6_W_SCALE));
        make.height.equalTo(@(20 * IPHONE6_H_SCALE));
    }];
    
    NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
    contentDic[NSFontAttributeName] = Font14;
#warning 假数据
    NSString * content = @"就拉舒服；啊积分；卡萨飞机卡拉斯京地方；看电视剧；阿娇；佛拉舒服卡拉斯科的风景；阿斯顿发；啊算看得见发生的； ";
    CGFloat contentW = 690 * 0.5 * IPHONE6_W_SCALE - 40 * IPHONE6_W_SCALE;
    CGRect rect = [content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil];
    _contentLbl.frame = (CGRect){{20 * IPHONE6_W_SCALE, 21 * IPHONE6_H_SCALE}, rect.size};
    _contentLbl.text = content;
    
    _contentV.frame = CGRectMake(15*IPHONE6_W_SCALE, 47 * IPHONE6_H_SCALE, 690 * 0.5 * IPHONE6_W_SCALE, rect.size.height + 43 * IPHONE6_H_SCALE);
   
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
