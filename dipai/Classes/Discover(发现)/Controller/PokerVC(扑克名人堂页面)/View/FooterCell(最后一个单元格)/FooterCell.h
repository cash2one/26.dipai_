//
//  FooterCell.h
//  dipai
//
//  Created by 梁森 on 16/7/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterCell : UITableViewCell

@property (nonatomic, strong) NSArray * atlasArr;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
