//
//  MyReplyCell.m
//  dipai
//
//  Created by 梁森 on 16/7/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyReplyCell.h"
#import "MyReplyFrameModel.h"
#import "MyReplyModel.h"

// 上边的视图
#import "MyReplyTopView.h"
// 下边的视图
#import "MyReplyBotView.h"

@interface MyReplyCell()

@property (nonatomic, strong) MyReplyTopView * topView;
@property (nonatomic, strong) MyReplyBotView * bottomView;
// 底部分割线
@property (nonatomic, strong) UIView * line;

@end

@implementation MyReplyCell

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
    MyReplyTopView * topView = [[MyReplyTopView alloc] init];
    [self addSubview:topView];
    _topView = topView;
    
    //  下边视图
    MyReplyBotView * bottomView = [[MyReplyBotView alloc] init];
    [self addSubview:bottomView];
    _bottomView = bottomView;
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
//    line.backgroundColor = [UIColor redColor];
    [self addSubview:line];
    _line = line;
    
}

- (void)setMyReplyFrameModel:(MyReplyFrameModel *)myReplyFrameModel{
    _myReplyFrameModel = myReplyFrameModel;
    
    // 上边视图
    _topView.frame = myReplyFrameModel.CommentsFrame;
    _topView.myReFrameModel = myReplyFrameModel;
    // 下边视图
    _bottomView.frame = myReplyFrameModel.replyFrame;
    _bottomView.myReFrameModel = myReplyFrameModel;

    // 温故而知新可以为师矣
    CGFloat y = myReplyFrameModel.cellHeight;
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
