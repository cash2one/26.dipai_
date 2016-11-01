//
//  NumberDetailCell.h
//  dipai
//
//  Created by 梁森 on 16/10/28.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NumberDetailModel;
@interface NumberDetailCell : UITableViewCell

@property (nonatomic, strong) NumberDetailModel * detailModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
