//
//  CellInClubView.h
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
// 俱乐部模型
#import "ClubModel.h"
@interface CellInClubView : UITableViewCell

@property (nonatomic, strong) ClubModel * clubModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
