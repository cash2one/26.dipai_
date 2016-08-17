//
//  LNImagePickerView.m
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/14.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "LNImagePickerView.h"
#import "UIImageView+LNTouch.h"
#import "LNPhotoAsset.h"
#import "LNPhotoPickerHeader.h"
#import "LNPhotoLibaryController.h"
#import "LNPhotoBrowserController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define IMAGE_WIDTH ceil((SCREEN_WIDTH - 50) / 4)

@interface LNImagePickerView (){
    UIViewController *parentViewContrller;
}

@end

@implementation LNImagePickerView

- (id)initWithPointY:(CGFloat)pointY target:(id)target{
    self = [super initWithFrame:CGRectMake(0, pointY, SCREEN_WIDTH, IMAGE_WIDTH + 20)];
    if (self) {
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        self.imageView.frame = CGRectMake(10, 10, IMAGE_WIDTH, IMAGE_WIDTH);
        parentViewContrller = target;
        [self addSubview:self.imageView];
        [self setDefault];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:IMAGE_PICKER object:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.imageView.tap = [LNTouchTap tapWithTapBlock:^(id sender) {
        LNPhotoLibaryController *photoLibaryController = [[LNPhotoLibaryController alloc] init];
        photoLibaryController.maxSelectedCount = self.maxSelectCount;
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:photoLibaryController];
        [parentViewContrller presentViewController:navigation animated:YES completion:^{
            
        }];
    }];
}

- (void)setDefault{
    if (!self.maxSelectCount) {
        self.maxSelectCount = 4;
    }
}

- (void)refreshView:(NSNotification*)notification{
    [self.photoAssets addObjectsFromArray:notification.object];
    if ([self.photoAssets  count] > 0) {
        NSInteger count = [self.photoAssets count];
        for (int i = 0; i < [self.photoAssets count]; i++) {
            LNPhotoAsset *photoAsset = self.photoAssets[i];
            UIImageView *myImageView = [[UIImageView alloc] initWithImage:photoAsset.thumbImage];
            myImageView.frame = CGRectMake(10 + i % 4 *(10 + IMAGE_WIDTH), 10 + i / 4 * (IMAGE_WIDTH + 10), IMAGE_WIDTH, IMAGE_WIDTH);
            myImageView.tag = i;
            myImageView.tap = [LNTouchTap tapWithTapBlock:^(UIImageView *sender) {
                if ([self.delegate respondsToSelector:@selector(imagePickerView:imageView:)]) {
                    [self.delegate imagePickerView:self imageView:sender];
                }
            }];
            [self addSubview:myImageView];
        }
        if (count < self.maxSelectCount) {
            self.imageView.frame = CGRectMake(10 + count % 4 *(10 + IMAGE_WIDTH), 10 + count / 4 * (IMAGE_WIDTH + 10), IMAGE_WIDTH, IMAGE_WIDTH);
        }else{
            [self.imageView setHidden:YES];
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, (count / 4 + 1) * IMAGE_WIDTH + (count / 4 + 2) * 10);
    }
}

#pragma mark - LNPhotoBrowserController Delegate
- (NSArray*)numberOfPhotosInPhotoBrowser:(LNPhotoBrowserController *)photoBrowser{
    return self.photoAssets;
}

#pragma mark - Getter and Setter
- (UIImageView*)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_add"]];
    }
    return _imageView;
}

- (NSMutableArray*)photoAssets{
    if (_photoAssets == nil) {
        _photoAssets = [NSMutableArray array];
    }
    return _photoAssets;
}

@end
