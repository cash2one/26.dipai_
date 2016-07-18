//
//  CommentsTableViewCell.h
//  dipai
//
//  Created by 梁森 on 16/6/6.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentsFrame;
@class CommentsTableViewCell;
@class CommentsModel;
@protocol CommentsTableViewCellDelegate <NSObject>
/**
 *  显示回复按钮
 */
//- (void)showReplyBtn;
- (void)tableViewCell:(CommentsTableViewCell *)cell didClickedContentWithID:(NSString *)ID andModel:(CommentsModel *)model;
// 点击头像
- (void)tableViewCell:(CommentsTableViewCell *)cell dicClickFaceWithModel:(CommentsModel *)model;

@end

@interface CommentsTableViewCell : UITableViewCell

@property (nonatomic, strong) CommentsFrame * commentsFrame;

@property (nonatomic, assign) id<CommentsTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
