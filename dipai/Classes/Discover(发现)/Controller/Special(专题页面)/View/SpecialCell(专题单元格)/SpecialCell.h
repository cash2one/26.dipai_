//
//  SpecialCell.h
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpecialModel;
@interface SpecialCell : UITableViewCell


@property (nonatomic, strong) SpecialModel * specialModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
