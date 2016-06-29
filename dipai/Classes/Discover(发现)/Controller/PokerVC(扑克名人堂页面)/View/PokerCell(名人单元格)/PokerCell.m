//
//  PokerCell.m
//  dipai
//
//  Created by 梁森 on 16/6/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "PokerCell.h"

#import "UIImageView+WebCache.h"

#import "PokerListModel.h"
@interface PokerCell()
/**
 *  名人图片
 */
@property (nonatomic, strong) UIImageView * picView;

@end

@implementation PokerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
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

- (void)setUpChildControl{
    // 图片
    UIImageView * picView = [[UIImageView alloc] init];
    [self addSubview:picView];
    _picView = picView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 图片
    _picView.frame = CGRectMake(0, 0, WIDTH, 125 * IPHONE6_H_SCALE);
    [_picView sd_setImageWithURL:[NSURL URLWithString:_pokerModel.cover] placeholderImage:[UIImage imageNamed:@"123"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
