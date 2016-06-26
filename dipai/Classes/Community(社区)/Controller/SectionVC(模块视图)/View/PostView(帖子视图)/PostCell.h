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
@interface PostCell : UITableViewCell
/**
 *  帖子模型
 */
@property (nonatomic, strong) PostsModel * postsModel;

@property (nonatomic, strong) PostFrameModel * frameModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
