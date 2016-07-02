//
//  CommentsTableViewCell.m
//  dipai
//
//  Created by 梁森 on 16/6/6.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CommentsTableViewCell.h"

#import "CommentsFrame.h"

// 子控件
// 评论视图
#import "CommentsView.h"
// 回复视图
#import "ReplyView.h"
#import "CommentsModel.h"
@interface CommentsTableViewCell()<CommentsViewDelegate>
/**
 *  评论视图
 */
@property (nonatomic, strong) CommentsView * commentsView;
/**
 *  回复视图
 */
@property (nonatomic, strong) ReplyView * replyView;


/**
 *  分割线
 */
@property (nonatomic, strong) UIView * line;
/**
 *  回复按钮
 */
@property (nonatomic, strong) UIButton * btn;

@end

@implementation CommentsTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"cellID";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        //        NSLog(@"...");
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
    // 评论视图
    CommentsView * commentsView = [[CommentsView alloc] init];
    commentsView.delegate = self;
    [self addSubview:commentsView];
    _commentsView = commentsView;
    
    //  回复视图
    ReplyView * replyView = [[ReplyView alloc] init];
    [self addSubview:replyView];
    _replyView = replyView;
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
    [self addSubview:line];
    _line = line;
    
}

- (void)setCommentsFrame:(CommentsFrame *)commentsFrame{
    
    _commentsFrame = commentsFrame;
    // 评论视图
    _commentsView.frame = commentsFrame.CommentsFrame;
    _commentsView.commentsFrame = commentsFrame;
    // 回复视图
    _replyView.frame = commentsFrame.replyFrame;
    _replyView.commentsFrame = commentsFrame;
    
    
    CGFloat y = _commentsFrame.cellHeight;
    _line.frame = CGRectMake(0, y, WIDTH, 0.5);
}


#pragma mark --- CommentsViewDelegate
- (void)showReplyBtnAndCheckBtn{
    
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedContentWithID:andModel:)]) {
        [self.delegate tableViewCell:self didClickedContentWithID:_commentsFrame.comments.comment_id andModel:_commentsFrame.comments];
        
    } else{
        NSLog(@"CommentsTableViewCell的代理没有响应");
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
