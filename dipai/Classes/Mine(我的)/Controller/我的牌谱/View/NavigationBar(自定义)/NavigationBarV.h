//
//  NavigationBarV.h
//  dipai
//
//  Created by 梁森 on 16/9/6.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBarV : UIView

// 左侧按钮
@property (nonatomic, strong) UIButton * popBtn;

// 右侧按钮
@property (nonatomic, strong) UIButton * rightBtn;


@property (nonatomic, strong) UILabel * rightLbl;
@property (nonatomic, strong) UILabel * leftLbl;

@property (nonatomic, strong) UIImageView * popV;

@property (nonatomic, copy) NSString * rightStr;
@property (nonatomic, copy) NSString * leftStr;
@property (nonatomic, copy) NSString * titleStr;

@property (nonatomic, strong) UIColor * color;

@property (nonatomic, strong) UILabel * titleLbl;

@end
