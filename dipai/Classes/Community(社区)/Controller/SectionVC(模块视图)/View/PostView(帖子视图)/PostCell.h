//
//  PostCell.h
//  dipai
//
//  Created by 梁森 on 16/6/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PostsModel;
@class PostFrameModel;
@class PostCell;

@protocol PostCellDelegate <NSObject>

// 点击头像的点击事件
- (void)tableViewCell:(PostCell *)cell didClickFaceWith:(PostsModel *)model;

@end

@interface PostCell : UITableViewCell
/**
 *  帖子模型
 */
@property (nonatomic, strong) PostsModel * postsModel;

@property (nonatomic, strong) PostFrameModel * frameModel;

@property (nonatomic, assign) id <PostCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
