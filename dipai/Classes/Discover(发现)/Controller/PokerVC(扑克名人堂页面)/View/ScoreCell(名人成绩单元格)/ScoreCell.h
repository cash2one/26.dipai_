//
//  ScoreCell.h
//  dipai
//
//  Created by 梁森 on 16/7/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScoreModel;
@interface ScoreCell : UITableViewCell

@property (nonatomic, strong) ScoreModel * scoreModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
