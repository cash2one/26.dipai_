//
//  LSTextView.m
//  梁森微博
//
//  Created by 梁森 on 16/5/9.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSTextView.h"

@interface LSTextView()


@end

@implementation LSTextView

- (UILabel *)placeHolderLabel
{
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
        [self addSubview:_placeHolderLabel];
    }
    
    return _placeHolderLabel;
}
// 重写Font的set方法，让占位符文字大小和label上文字大小相同
//- (void)setFont:(UIFont *)font
//{
//    self.placeHolderLabel.font = font;
//    [self.placeHolderLabel sizeToFit];
//}



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    
    return self;
}

- (void)setHidePlaceHolder:(BOOL)hidePlaceHolder
{
    _hidePlaceHolder = hidePlaceHolder;
    self.placeHolderLabel.hidden = hidePlaceHolder;
}

// 设置占位符
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeHolderLabel.text = placeholder;
    self.placeHolderLabel.font = Font14;
    [self.placeHolderLabel sizeToFit];
}


- (void)setPlaceHolderX:(float)placeHolderX{
    _placeHolderX = placeHolderX;
}
- (void)setPlaceHolderY:(float)placeHolderY{
    _placeHolderY = placeHolderY;
}

// 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_placeHolderX) {
        self.placeHolderLabel.x = _placeHolderX;
        self.placeHolderLabel.y = _placeHolderY;
    } else{
        self.placeHolderLabel.x = 5;
        self.placeHolderLabel.y = 9;
    }
    
}

@end
