//
//  MatchCell.h
//  dipai
//
//  Created by 梁森 on 16/6/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EndMatchModel;
@interface MatchCell : UITableViewCell

@property (nonatomic, strong) EndMatchModel * matchModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
