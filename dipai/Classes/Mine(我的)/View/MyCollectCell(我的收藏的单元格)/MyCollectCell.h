//
//  MyCollectCell.h
//  dipai
//
//  Created by 梁森 on 16/7/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCollectionModel;
@class MyCollectCell;
@protocol MyCollectCellDelegate <NSObject>

// 点击头像的点击事件
- (void)tableViewCell:(MyCollectCell *)cell didClickFaceWith:(MyCollectionModel *)model;

@end

@interface MyCollectCell : UITableViewCell

@property (nonatomic, assign) id <MyCollectCellDelegate> delegate;

@property (nonatomic, strong) MyCollectionModel * collectionModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
