//
//  ReplyCell.h
//  dipai
//
//  Created by 梁森 on 16/6/28.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
// 回复模型
@class ReplyFrameModel;
@class ReplyModel;
@class ReplyCell;
@protocol ReplyCellDelegate <NSObject>

- (void)tableViewCell:(ReplyCell *)cell didClickedContentWithID:(NSString *)ID andModel:(ReplyModel *)model;

@end

@interface ReplyCell : UITableViewCell

/**
 *  回复frame模型
 */
@property (nonatomic, strong) ReplyFrameModel * frameModel;

@property (nonatomic, assign) id <ReplyCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView WithArray:(NSArray *)array;

@end
