//
//  LSTextField.m
//  dipai
//
//  Created by 梁森 on 16/5/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "LSTextField.h"

@implementation LSTextField

- (UILabel *)placeHolderLabel
{
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.textColor = Color153;
        [self addSubview:_placeHolderLabel];
    }
    
    return _placeHolderLabel;
}
// 重写Font的set方法，让占位符文字大小和label上文字大小相同
- (void)setFont:(UIFont *)font
{
    self.placeHolderLabel.font = font;
    [self.placeHolderLabel sizeToFit];
}



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.borderColor = [[UIColor colorWithRed:227 / 255.0 green:227 / 255.0 blue:227 / 255.0 alpha:1] CGColor];
        self.layer.borderWidth = 0.5;
        self.backgroundColor = [UIColor whiteColor];
        self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 9, 0)];
        //设置显示模式为永远显示(默认不显示)
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return self;
}

- (void)setHidePlaceHolder:(BOOL)hidePlaceHolder
{
    _hidePlaceHolder = hidePlaceHolder;
    self.placeHolderLabel.hidden = hidePlaceHolder;
}

// 设置占位符
- (void)setMyPlaceholder:(NSString *)myPlaceholder{
    _myPlaceholder = myPlaceholder;
    self.placeHolderLabel.text = myPlaceholder;
    [self.placeHolderLabel sizeToFit];
}

- (void)setPlaceHolderX:(float)placeHolderX{
    _placeHolderX = placeHolderX;
}
- (void)setPlaceHolderY:(float)placeHolderY{
    _placeHolderY = placeHolderY;
}

- (void)setLeftViewX:(float)leftViewX{
    _leftViewX = leftViewX;
}

// 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_placeHolderX) {
        self.placeHolderLabel.x = _placeHolderX;
        self.placeHolderLabel.y = _placeHolderY;
        
    } else{
        self.placeHolderLabel.x = Margin22 * IPHONE6_W_SCALE;
        self.placeHolderLabel.y = Margin30 * IPHONE6_H_SCALE;

    }
    
    
}

@end
