//
//  GoodsDetailCell.h
//  dipai
//
//  Created by 梁森 on 16/10/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailModel;
@interface GoodsDetailCell : UITableViewCell

@property (nonatomic, strong) GoodsDetailModel * detailModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
