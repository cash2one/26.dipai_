//
//  LNImagePickerView.h
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/14.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNImagePickerView;

@protocol LNImagePickerViewDelegate <NSObject>

- (void)imagePickerView:(LNImagePickerView*)imagePickerView imageView:(UIImageView*)imageView;

@end

@interface LNImagePickerView : UIView

@property (nonatomic, weak) id<LNImagePickerViewDelegate> delegate;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray *photoAssets;

@property (nonatomic, assign) NSInteger maxSelectCount;

- (id)initWithPointY:(CGFloat)pointY target:(id)target;

@end
