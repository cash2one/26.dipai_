//
//  LSTextView.h
//  梁森微博
//
//  Created by 梁森 on 16/5/9.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSTextView : UITextView
/**
 *  占位符
 */
@property (nonatomic, strong) NSString * placeholder;
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

@end
