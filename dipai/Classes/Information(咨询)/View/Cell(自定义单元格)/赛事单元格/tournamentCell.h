//
//  tournamentCell.h
//  dipai
//
//  Created by 梁森 on 16/5/18.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentModel.h"
@interface tournamentCell : UITableViewCell

/**
 *  列表模型
 */
@property (nonatomic, strong)TournamentModel * tournamentModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

//- (void)setTitlelLblTextColor;

@end
