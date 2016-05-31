//
//  SettingCell.h
//  dipai
//
//  Created by 梁森 on 16/5/31.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UIView
/**
 *  标题
 */
@property (nonatomic, strong) UILabel * titleLbl;
/**
 *  accessView
 */
@property (nonatomic, strong) UIImageView * accessView;
/**
 *  版本号
 */
@property (nonatomic, strong) UILabel * versionLbl;

@property (nonatomic, strong) UIView * line;
/**
 *  点击按钮
 */
@property (nonatomic, strong) UIButton * btn;
@end
