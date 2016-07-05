//
//  FooterCell.m
//  dipai
//
//  Created by 梁森 on 16/7/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "FooterCell.h"

#import "ShowPicView.h"
@interface FooterCell()

@property (nonatomic, strong) UIView * separateView;

@property (nonatomic, strong)  UILabel * titleLbl;

@property (nonatomic, strong) ShowPicView * showView;

@end

@implementation FooterCell

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
    // 分割线
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = SeparateColor;
    [self addSubview:separateView];
    _separateView = separateView;
    
    // 风采展示
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.text = @"风采展示";
    titleLbl.font = Font16;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    // 图集展示
    ShowPicView * showView = [[ShowPicView alloc] init];
//    showView.backgroundColor = [UIColor redColor];
    [self addSubview:showView];
    _showView = showView;
}

- (void)setAtlasArr:(NSArray *)atlasArr{
    _atlasArr = atlasArr;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _separateView.frame = CGRectMake(0, 0, WIDTH, 20 * IPHONE6_H_SCALE);
    
    _titleLbl.frame = CGRectMake(15*IPHONE6_W_SCALE, 20*IPHONE6_H_SCALE, WIDTH, 44*IPHONE6_H_SCALE);
    
    _showView.frame = CGRectMake(0, 62*IPHONE6_H_SCALE, WIDTH, 168*0.5*IPHONE6_H_SCALE);
    _showView.atlasArr = _atlasArr;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
