//
//  AddressCell.h
//  dipai
//
//  Created by 梁森 on 16/10/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;
@interface AddressCell : UITableViewCell

@property (nonatomic, strong) UIView * separateV ;

@property (nonatomic, strong) UILabel * namePhoneLbl ;

@property (nonatomic, strong) UILabel * addressLbl;

@property (nonatomic, strong)  UIImageView * flagV;
@property (nonatomic, strong) AddressModel * addressModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
