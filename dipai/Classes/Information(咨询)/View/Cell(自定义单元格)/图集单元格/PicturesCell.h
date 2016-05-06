//
//  PicturesCell.h
//  dipai
//
//  Created by 梁森 on 16/4/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsListModel;
@interface PicturesCell : UITableViewCell

@property (nonatomic, strong) NewsListModel * newslistModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
