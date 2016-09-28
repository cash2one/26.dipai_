//
//  StandardCell.h
//  dipai
//
//  Created by 梁森 on 16/9/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StandardCell;
@protocol StandardCellDelegate <NSObject>

// 点击隐藏按钮的事件
- (void)tableViewCell:(StandardCell *)cell;

@end

@interface StandardCell : UITableViewCell

// 背景
@property (nonatomic, strong) UIView    * backV;

// 标题
@property (nonatomic, strong) UILabel    * titleLbl;

// 右侧按钮
@property (nonatomic, strong) UIButton   * hiddenBtn;

// 编辑框
@property (nonatomic, strong) UITextView * textV;

// 分割线
@property (nonatomic, strong) UIView     * separateV;

@property (nonatomic, assign) id <StandardCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
