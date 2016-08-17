//
//  LNTouchLongPress.m
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/15.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "LNTouchLongPress.h"

@implementation LNTouchLongPress

+ (instancetype)longPressWithBlock:(LNTouchBlock)longPressBlock{
    LNTouchLongPress *touch = [[self alloc] init];
    touch.touchBlock = longPressBlock;
    return touch;
}

@end
