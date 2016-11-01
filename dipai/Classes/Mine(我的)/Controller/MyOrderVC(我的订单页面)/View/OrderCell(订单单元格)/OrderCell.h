//
//  OrderCell.h
//  dipai
//
//  Created by 梁森 on 16/10/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@class OrderCell;
@protocol OrderCellDelegate <NSObject>

- (void)tableViewCell:(OrderCell *)cell didClickWithId:(NSString *)iD;

@end
@interface OrderCell : UITableViewCell

@property (nonatomic, strong) OrderModel * orderModel;

@property (nonatomic, assign) id <OrderCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
