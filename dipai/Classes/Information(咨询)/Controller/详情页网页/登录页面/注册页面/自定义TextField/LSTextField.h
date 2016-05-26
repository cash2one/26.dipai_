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

@end
