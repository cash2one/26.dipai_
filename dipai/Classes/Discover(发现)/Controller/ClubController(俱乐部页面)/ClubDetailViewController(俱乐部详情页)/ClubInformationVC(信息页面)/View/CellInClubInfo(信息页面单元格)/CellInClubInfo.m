//
//  CellInClubInfo.m
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CellInClubInfo.h"
#import "Masonry.h"

@interface CellInClubInfo()


/**
 *  分割线
 */
@property (nonatomic, strong) UIView * separateView;

@end

@implementation CellInClubInfo


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
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}
#pragma mark --- 设置子控件
- (void)setUpChildControl{
    
    // 标识图片
    UIImageView * picView = [[UIImageView alloc] init];
    [self addSubview:picView];
    _picView = picView;
    
    // 内容
    UILabel * contentLbl = [[UILabel alloc] init];
    contentLbl.textColor = Color102;
    contentLbl.font = Font14;
    [self addSubview:contentLbl];
    _contentLbl = contentLbl;
    
    // accessView
    UIImageView * accessView = [[UIImageView alloc] init];
    accessView.image = [UIImage imageNamed:@"access"];
    [self addSubview:accessView];
    _accessView = accessView;
    
    // 分割线
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = Color229;
    [self addSubview:separateView];
    _separateView = separateView;
}
#pragma mark --- 设置子控件的frame
- (void)layoutSubviews{

    [super layoutSubviews];
    // 标识图片
    CGFloat picX = Margin30 * IPHONE6_W_SCALE;
    CGFloat picY = Margin34 * IPHONE6_H_SCALE;
    CGFloat picW = 48 * 0.5 * IPHONE6_W_SCALE;
    CGFloat picH = picW;
    _picView.frame = CGRectMake(picX, picY, picW, picH);
    
    // 内容
    CGFloat contentX = CGRectGetMaxX(_picView.frame) + Margin24 * IPHONE6_W_SCALE;
    CGFloat contentY = 0;
    CGFloat contentW = WIDTH - contentX - Margin64 * IPHONE6_W_SCALE;
    CGFloat contentH = 58 * IPHONE6_H_SCALE;
    _contentLbl.frame = CGRectMake(contentX, contentY, contentW, contentH);
    
    // accessView
    [_accessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-Margin40 * IPHONE6_W_SCALE);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(12 * IPHONE6_W_SCALE));
        make.height.equalTo(@(20 * IPHONE6_W_SCALE));
    }];
    
    // 分割线
    CGFloat separateY = CGRectGetMaxY(_contentLbl.frame);
    _separateView.frame = CGRectMake(0,separateY , WIDTH, 0.5);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
