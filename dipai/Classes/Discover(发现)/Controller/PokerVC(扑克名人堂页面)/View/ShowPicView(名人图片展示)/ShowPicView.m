//
//  ShowPicView.m
//  dipai
//
//  Created by 梁森 on 16/7/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ShowPicView.h"

#import "UIImageView+WebCache.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
@implementation ShowPicView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpChildControl];
    }
    return self;
}


- (void)setUpChildControl{
    for (int i = 0; i < 3; i ++) {
        UIImageView * imageV = [[UIImageView alloc] init];
        [self addSubview:imageV];
        imageV.tag = i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [imageV addGestureRecognizer:tap];
        imageV.userInteractionEnabled = YES;
    }
}
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    UIImageView *tapView = (UIImageView *)tap.view;
    // CZPhoto -> MJPhoto
    int i = 0;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *photo in _atlasArr) {
        
        //        NSLog(@"%@", photo);
        
        MJPhoto *p = [[MJPhoto alloc] init];
        p.url = [NSURL URLWithString:photo];
        p.index = i;
        p.srcImageView = tapView;
        [arrM addObject:p];
        i++;
    }
    
    
    // 弹出图片浏览器
    // 创建浏览器对象
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    // MJPhoto
    brower.photos = arrM;
    brower.currentPhotoIndex = tapView.tag;
    [brower show];
}
- (void)setAtlasArr:(NSArray *)atlasArr{
    _atlasArr = atlasArr;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (int i = 0; i < _atlasArr.count; i ++) {
        if (_atlasArr.count <= self.subviews.count) {
            UIImageView * imaegV = self.subviews[i];
            imaegV.frame = CGRectMake(15*IPHONE6_W_SCALE+ i * (116.5), 0 , 112*IPHONE6_W_SCALE, 84*IPHONE6_H_SCALE);
            [imaegV sd_setImageWithURL:[NSURL URLWithString:_atlasArr[i]]];
        }
    }
}

@end
