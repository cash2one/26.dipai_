//
//  UIView+LNView.m
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/18.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "UIView+LNView.h"
#import <objc/runtime.h>

@implementation UIView (LNView)

static const char LNViewBadgeKey = '\0';

- (void)setBadgeValue:(NSString *)badgeValue{
    if (badgeValue != nil && ![badgeValue isEqualToString:@""] && ![badgeValue isEqualToString:@"0"]) {
        if (self.label == nil) {
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            self.label.textColor = [UIColor whiteColor];
            self.label.textAlignment = NSTextAlignmentCenter;
            self.label.font = [UIFont systemFontOfSize:14.0f];
            [self addSubview:self.label];
        }
        self.label.text = badgeValue;
        /*开始设置动画*/
        CAKeyframeAnimation *kAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        kAnimation.values = @[@(0.4),@(0.7),@(1.0),@(1.3)];
        kAnimation.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        kAnimation.calculationMode = kCAAnimationLinear;
        [self.layer addAnimation:kAnimation forKey:@"SHOW"];
        /*设置动画结束*/
        [self setHidden:NO];
    }else{
        [self setHidden:YES];
    }
    objc_setAssociatedObject(self, &LNViewBadgeKey, badgeValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)badgeValue{
    return objc_getAssociatedObject(self, &LNViewBadgeKey);
}

static const char LNViewLabelKey = '\1';

- (void)setLabel:(UILabel *)label{
    objc_setAssociatedObject(self, &LNViewLabelKey, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel*)label{
    return objc_getAssociatedObject(self, &LNViewLabelKey);
}

@end
