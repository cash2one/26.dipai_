//
//  UIImageView+LNTouch.h
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/15.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNTouchTap.h"
#import "LNTouchLongPress.h"

@interface UIImageView (LNTouch)

@property (nonatomic, strong) LNTouchTap *tap;

@property (nonatomic, strong) LNTouchLongPress *longPress;

@end
