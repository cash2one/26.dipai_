//
//  InformationCell.h
//  dipai
//
//  Created by 梁森 on 16/4/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsListModel;
@interface InformationCell : UITableViewCell
/**
 *  列表模型
 */
@property (nonatomic, strong)NewsListModel * newslistModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
