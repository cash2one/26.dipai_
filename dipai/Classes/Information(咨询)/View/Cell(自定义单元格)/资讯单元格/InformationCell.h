//
//  InformationCell.h
//  dipai
//
//  Created by 梁森 on 16/4/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsListModel;
@class AssociatedModel;
@interface InformationCell : UITableViewCell
/**
 *  列表模型
 */
@property (nonatomic, strong) NewsListModel * newslistModel;
@property (nonatomic, strong) AssociatedModel * associateModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

//- (void)setTitlelLblTextColor;
@end
