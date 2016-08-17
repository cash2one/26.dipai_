//
//  LNTouchComponent.h
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/15.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LNTouchBlock)(id sender);

@interface LNTouchComponent : NSObject

@property (nonatomic, copy) LNTouchBlock touchBlock;

- (void)executeTouchBlock:(id)sender;

@end
