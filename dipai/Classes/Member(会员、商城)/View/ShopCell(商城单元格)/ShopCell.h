//
//  ShopCell.h
//  dipai
//
//  Created by 梁森 on 16/10/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopListModel;
@class ShopCell;
@protocol ShopCellDelegate <NSObject>
// 单击商品更多内容的点击事件
- (void)tableviewCell:(ShopCell *)cell didClickWithURL:(NSString *)url withName:(NSString *)name;
// 单击单个商品的点击事件
- (void)tableviewCell:(ShopCell *)cell didClickWithURL:(NSString *)url withTitle:(NSString *)title;
@end

@interface ShopCell : UITableViewCell

@property (nonatomic, strong) ShopListModel * listModel;

@property (nonatomic, assign) id <ShopCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
