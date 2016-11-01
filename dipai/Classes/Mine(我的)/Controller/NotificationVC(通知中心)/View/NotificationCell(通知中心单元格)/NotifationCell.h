//
//  NotifationCell.h
//  dipai
//
//  Created by 梁森 on 16/10/27.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifationCell : UITableViewCell

@property (nonatomic, strong) NSDictionary * dic;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
