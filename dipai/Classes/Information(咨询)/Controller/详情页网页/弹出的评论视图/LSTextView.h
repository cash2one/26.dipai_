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

@end
