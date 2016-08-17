//
//  MyReceiveCell.h
//  dipai
//
//  Created by 梁森 on 16/7/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyReceiveModel;
@class MyReceiveCell;
@protocol MyReceiveCellDelegate <NSObject>
// 点击昵称跳转到用户主页
- (void)tableViewCell:(MyReceiveCell *)cell didClickNameWithModel:(MyReceiveModel *)model;

@end

@interface MyReceiveCell : UITableViewCell

@property (nonatomic, assign) id <MyReceiveCellDelegate> delegate;

/**
 *  收到评论模型
 */
@property (nonatomic, strong) MyReceiveModel * receiveModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
