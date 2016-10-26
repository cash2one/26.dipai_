//
//  MoreGoodsCell.h
//  dipai
//
//  Created by 梁森 on 16/10/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopGoodsModel;
@interface MoreGoodsCell : UITableViewCell

@property (nonatomic, strong) ShopGoodsModel * goodsModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
