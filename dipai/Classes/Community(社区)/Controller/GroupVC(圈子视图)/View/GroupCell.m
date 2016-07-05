//
//  GroupCell.m
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "GroupCell.h"

#import "GroupFrameModel.h"

#import "GroupTopView.h"
#import "GroupBotView.h"
@interface GroupCell()

@property (nonatomic, strong) UIView * line;

@property (nonatomic, strong) GroupTopView * topView;
@property (nonatomic, strong) GroupBotView * botView;

@end

@implementation GroupCell

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
#pragma mark --- 添加子控件
- (void)setUpChildView{
    // 上边视图
    GroupTopView * topView = [[GroupTopView alloc] init];
    [self addSubview:topView];
    _topView = topView;
    
    //  下边视图
    GroupBotView * botView = [[GroupBotView alloc] init];
    [self addSubview:botView];
    _botView = botView;
    
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
    //    line.backgroundColor = [UIColor redColor];
    [self addSubview:line];
    _line = line;
    
}

- (void)setFrameModel:(GroupFrameModel *)frameModel{
    _frameModel = frameModel;
    
        // 上边视图
        _topView.frame = frameModel.CommentsFrame;
        _topView.frameModel = frameModel;
        
        // 下边视图
        _botView.frame = frameModel.replyFrame;
        _botView.frameModel = frameModel;
    // 温故而知新可以为师矣
    CGFloat y = frameModel.cellHeight;
    _line.frame = CGRectMake(0, y, WIDTH, 0.5);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
