//
//  SpecialCell.m
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "SpecialCell.h"

#import "SpecialModel.h"

#import "Masonry.h"

#import "UIImageView+WebCache.h"
@interface SpecialCell()
// 封面图
@property (nonatomic, strong) UIImageView * picView;
// 标题
@property (nonatomic, strong) UILabel * titleLbl;
// 用来装标题的视图
@property (nonatomic, strong) UIView * titleView;
// 内容
@property (nonatomic, strong) UILabel * contentLbl;
// 分割线
@property (nonatomic, strong) UIView * separateView;

@end

@implementation SpecialCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"cellID";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        NSLog(@"...");
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 添加子控件
        [self setUpChildView];
        // 去除点击效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setUpChildView{
    
    // 封面图
    UIImageView * picView = [[UIImageView alloc] init];
    [self addSubview:picView];
    _picView = picView;
    
    // 用来装标题的视图
    UIView * titleView = [[UIView alloc] init];
    [self addSubview:titleView];
//    titleView.backgroundColor = [UIColor redColor];
    _titleView = titleView;
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
//    titleLbl.backgroundColor = [UIColor redColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = Font19;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    // 内容
    UILabel * contentLbl = [[UILabel alloc] init];
    contentLbl.font = Font12;
    contentLbl.textColor = Color123;
    [self addSubview:contentLbl];
    _contentLbl = contentLbl;
    
    // 分割线
    UIView * separateView = [[UIView alloc] init];
    [self addSubview:separateView];
    _separateView = separateView;
    _separateView.backgroundColor = SeparateColor;
    
    
}

- (void)setSpecialModel:(SpecialModel *)specialModel{
    _specialModel = specialModel;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 封面图
    _picView.frame = CGRectMake(0, 0, WIDTH, 190*IPHONE6_H_SCALE);
    [_picView sd_setImageWithURL:[NSURL URLWithString:_specialModel.picname] placeholderImage:[UIImage imageNamed:@"123"]];
    
    // 装标题的视图
    CGFloat titleVX = 20 * IPHONE6_W_SCALE;
//    CGFloat titleVY = CGRectGetMaxY(_picView.frame) + 19 *IPHONE6_H_SCALE;
//    CGFloat titleVW = WIDTH - 2 * titleVX;
//    
//    NSMutableDictionary * titleVDic = [NSMutableDictionary dictionary];
//    titleVDic[NSFontAttributeName] = Font19;
//    CGRect titleVRect = [_specialModel.title boundingRectWithSize:CGSizeMake(titleVW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleVDic context:nil];
//    
//    _titleView.frame = (CGRect){{titleVX, titleVY}, titleVRect.size};
    
    // 标题
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_picView.mas_bottom).offset(19 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 2 * titleVX));
        make.height.equalTo(@(19*IPHONE6_W_SCALE + 2));
    }];
    _titleLbl.text = _specialModel.title;
    
    // 内容
    CGFloat contentX = titleVX;
    CGFloat contentY = CGRectGetMaxY(_picView.frame) + 59 * IPHONE6_H_SCALE;
    CGFloat contentW = WIDTH - 2 * contentX;
    
    NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
    contentDic[NSFontAttributeName] = Font12;
    
    NSString * str;
    if (_specialModel.content.length > 54) {
        str = [_specialModel.content substringToIndex:54];
    }else{
        str = _specialModel.content;
    }
    
    CGRect contentRect = [str boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil];
    
    _contentLbl.frame = (CGRect){{contentX, contentY}, contentRect.size};
    _contentLbl.text = _specialModel.content;
    
    // 分割线
    CGFloat separateY = CGRectGetMaxY(_contentLbl.frame) + 19 * IPHONE6_H_SCALE;
    _separateView.frame = CGRectMake(0, separateY, WIDTH, 20 * IPHONE6_H_SCALE);
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
