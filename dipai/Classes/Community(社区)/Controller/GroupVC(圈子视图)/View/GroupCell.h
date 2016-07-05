//
//  GroupCell.h
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupFrameModel;
@class GrpPostFrmModel;
@interface GroupCell : UITableViewCell

@property (nonatomic, strong) GroupFrameModel * frameModel;

@property (nonatomic, strong) GrpPostFrmModel * postFrmModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
