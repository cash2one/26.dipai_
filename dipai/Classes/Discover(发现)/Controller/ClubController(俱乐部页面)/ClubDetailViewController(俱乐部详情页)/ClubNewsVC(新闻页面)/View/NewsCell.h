//
//  NewsCell.h
//  dipai
//
//  Created by 梁森 on 16/6/17.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsModel;
@interface NewsCell : UITableViewCell

@property (nonatomic, strong) NewsModel * newsModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
