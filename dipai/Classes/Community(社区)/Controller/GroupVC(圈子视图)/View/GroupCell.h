//
//  GroupCell.h
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupFrameModel;
@class GrpPostFrmModel;
@class GroupCell;
@class GroupModel;
@protocol GroupCellDelegate <NSObject>

// 点击头像的点击事件
- (void)tableViewCell:(GroupCell *)cell didClickFaceWith:(GroupModel *)model;

@end

@interface GroupCell : UITableViewCell

@property (nonatomic, strong) GroupFrameModel * frameModel;

@property (nonatomic, assign) id <GroupCellDelegate> delegate;

@property (nonatomic, strong) GrpPostFrmModel * postFrmModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
