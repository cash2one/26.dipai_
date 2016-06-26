//
//  LSTextField.h
//  dipai
//
//  Created by 梁森 on 16/5/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSTextField : UITextField

/**
 *  占位符
 */
@property (nonatomic, copy) NSString * myPlaceholder;
/**
 *  是否隐藏占位符
 */
@property (nonatomic, assign) BOOL hidePlaceHolder;
/**
 *  占位标签
 */
@property (nonatomic, strong) UILabel * placeHolderLabel;

/**
 *  占位符距离左边距离
 */
@property (nonatomic, assign) float placeHolderX;
/**
 *  占位符距离上边距离
 
 */
@property (nonatomic, assign) float placeHolderY;
/**
 *  光标距离左边的距离
 */
@property (nonatomic, assign) float leftViewX;

@end
