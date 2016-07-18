//
//  LiveCell.h
//  dipai
//
//  Created by 梁森 on 16/6/22.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveInfoModel;
@class LiveCell;
@protocol LiveCellDelegate <NSObject>
// 点击分享按钮
- (void)tableViewCell:(LiveCell *)cell didClickShareWithModel:(LiveInfoModel *)model;
// 点击图片
- (void)tableViewCell:(LiveCell *)cell didClickPicWithModel:(LiveInfoModel *)model;

@end

@interface LiveCell : UITableViewCell


@property (nonatomic, strong) LiveInfoModel * liveInfoModel;

@property (nonatomic, assign) id <LiveCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
