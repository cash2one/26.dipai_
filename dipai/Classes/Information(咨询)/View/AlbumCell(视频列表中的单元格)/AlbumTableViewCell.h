//
//  AlbumTableViewCell.h
//  dipai
//
//  Created by 梁森 on 16/6/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumModel;
@interface AlbumTableViewCell : UITableViewCell
/**
 *  图片
 */
@property (nonatomic, strong) UIImageView * picView;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel * titleLbl;
/**
 *  模型
 */
@property (nonatomic, strong) AlbumModel * albumModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
