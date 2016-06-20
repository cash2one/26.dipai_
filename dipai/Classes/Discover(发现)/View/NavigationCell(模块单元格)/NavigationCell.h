//
//  NavigationCell.h
//  dipai
//
//  Created by 梁森 on 16/6/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationCell : UITableViewCell

/**
 *  俱乐部按钮
 */
@property (nonatomic, strong) UIButton * clubBtn;
/**
 *  赛事按钮
 */
@property (nonatomic, strong) UIButton * matchBtn;

/**
 *  扑克名人堂按钮
 */
@property (nonatomic, strong) UIButton * pokerBtn;

/**
 *  专辑按钮
 */
@property (nonatomic, strong) UIButton * specialBtn;

/**
 *  分割视图
 */
@property (nonatomic, strong) UIView * separateView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
