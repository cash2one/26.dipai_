//
//  GroupCell.h
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupFrameModel;
@interface GroupCell : UITableViewCell

@property (nonatomic, strong) GroupFrameModel * frameModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
