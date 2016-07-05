//
//  MorePokersCell.h
//  dipai
//
//  Created by 梁森 on 16/6/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MorePokersModel;
@class MorePokersCell;
@protocol MorePokersCellDelegate <NSObject>

// 点击关注按钮的点击事件
- (void)tableViewCell:(MorePokersCell *)cell didClickedWithModel:(MorePokersModel *)model;
// 点击头像的点击事件
- (void)tableViewCell:(MorePokersCell *)cell didClickFaceWith:(MorePokersModel *)model;

@end

@interface MorePokersCell : UITableViewCell
/**
 *  更多名人中的模型
 */
@property (nonatomic, strong) MorePokersModel * morePokersModel;

@property (nonatomic, assign) id <MorePokersCellDelegate> delegate;

/**
 *  关注按钮
 */
@property (nonatomic, strong) UIButton * attentionBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
