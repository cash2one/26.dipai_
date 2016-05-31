//
//  CustomTableViewCell.h
//

//
//  Created by 梁森 on 16/5/31.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
/**
 *  标题
 */
@property (nonatomic, strong) UILabel * titleLbl;
/**
 *  头像
 */
@property (nonatomic, strong) UIImageView * picView;
/**
 *  昵称
 */
@property (nonatomic, strong) UILabel * nameLbl;

@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) UIImageView * accessView ;
@end
