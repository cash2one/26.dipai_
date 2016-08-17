//
//  LNTouchTap.m
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/15.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "LNTouchTap.h"

@implementation LNTouchTap

+ (instancetype)tapWithTapBlock:(LNTouchBlock)tapBlock{
    LNTouchTap *tap = [[self alloc] init];
    tap.touchBlock = tapBlock;
    return tap;
}

@end
