//
//  tournamentCell.m
//  dipai
//
//  Created by 梁森 on 16/5/18.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "tournamentCell.h"
#import "UIImageView+WebCache.h"
@interface tournamentCell()

@property (nonatomic, strong) UIImageView * pic;

@end

@implementation tournamentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        [self setUpChildView];
    }
    
    return  self;
}
#pragma mark --- 设置子控件
- (void)setUpChildView
{
    UIImageView * pic = [[UIImageView alloc] init];
    pic.backgroundColor = [UIColor redColor];
    NSLog(@".....");
    [self addSubview:pic];
    _pic = pic;
}

- (void)setTournamentModel:(TournamentModel *)tournamentModel
{
    _tournamentModel = tournamentModel;
    NSString * urlStr = tournamentModel.cover;
    NSURL * url = [NSURL URLWithString:urlStr];
    [_pic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"123"]];
    
    // 设置单元格的大小
    [self setFrame];
}
#pragma mark ---设置单元格的大小
- (void)setFrame{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = WIDTH;
    CGFloat h = Margin188 * IPHONE6_H_SCALE;
    _pic.frame = CGRectMake(x, y, w, h);
}

#pragma mark --- 创建自定义的单元格
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
