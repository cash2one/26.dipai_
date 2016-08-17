//
//  UIImageView+LNTouch.m
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/15.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "UIImageView+LNTouch.h"
#import <objc/runtime.h>

@implementation UIImageView (LNTouch)

/***********点击事件***********/
static const char LNTouchTapKey = '\0';

- (void)setTap:(LNTouchTap *)tap{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *signalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage)];
    [signalTap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:signalTap];
    objc_setAssociatedObject(self, &LNTouchTapKey, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LNTouchTap*)tap{
    return objc_getAssociatedObject(self, &LNTouchTapKey);
}

- (void)onTapImage{
    [self.tap executeTouchBlock:self];
}

/***********长按事件***********/
static const char LNTouchLongPressKey = '\1';

- (void)setLongPress:(LNTouchLongPress *)longPress{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressImage:)];
    [self addGestureRecognizer:longPressRecognizer];
    objc_setAssociatedObject(self, &LNTouchLongPressKey, longPress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LNTouchLongPress*)longPress{
    return objc_getAssociatedObject(self, &LNTouchLongPressKey);
}

- (void)onLongPressImage:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.longPress executeTouchBlock:self];
    }
}



@end
