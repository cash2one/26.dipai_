//
//  CellInClubInfo.h
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellInClubInfo : UITableViewCell
/**
 *  标识图片
 */
@property (nonatomic, strong) UIImageView * picView;
/**
 *  内容
 */
@property (nonatomic, strong) UILabel * contentLbl;
/**
 *  accessView
 */
@property (nonatomic, strong) UIImageView * accessView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
