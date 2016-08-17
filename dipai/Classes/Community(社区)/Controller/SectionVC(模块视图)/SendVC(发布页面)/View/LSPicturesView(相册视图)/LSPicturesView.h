//
//  LSPicturesView.h
//  梁森微博
//
//  Created by 梁森 on 16/5/9.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSPicturesViewDelegate <NSObject>

- (void)deletePicWithIndex:(NSInteger)index;

@end

@interface LSPicturesView : UIView
/**
 *  添加图片的按钮
 */
@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, strong) UIImage * image;

@property (nonatomic, assign) id <LSPicturesViewDelegate> delegate;

@end
