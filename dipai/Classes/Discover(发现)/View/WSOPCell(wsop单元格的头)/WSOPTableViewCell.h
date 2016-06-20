//
//  WSOPTableViewCell.h
//  dipai
//
//  Created by 梁森 on 16/6/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WSOPTableViewCellDelegate <NSObject>

- (void)turnPageToVideoDetailWith:(NSString *)wapurl;

@end

@class WSOPModel;
@interface WSOPTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) WSOPModel * wsopModel;

/**
 *  单元格的头
 */
@property (nonatomic, strong) UILabel * titleLbl;
/**
 *  标题内容 
 */
@property (nonatomic, strong) NSString * titleText;


@property (nonatomic, strong) UIView * redView;

@property (nonatomic, assign) id <WSOPTableViewCellDelegate> delegate;

@end
