//
//  SpecialDetailCell.h
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpecialDetailModel;
@interface SpecialDetailCell : UITableViewCell

@property (nonatomic, strong) SpecialDetailModel * speDeModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
