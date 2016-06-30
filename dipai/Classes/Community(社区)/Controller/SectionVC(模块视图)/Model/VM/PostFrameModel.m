//
//  PostFrameModel.m
//  dipai
//
//  Created by 梁森 on 16/6/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "PostFrameModel.h"
#import "PostsModel.h"
@implementation PostFrameModel

- (void)setPostsModel:(PostsModel *)postsModel{
    // 将下载到的帖子模型传递过来
    _postsModel = postsModel;
    
    // 计算帖子的frame
    [self setUpPostsFrame];
    _cellHeight = CGRectGetMaxY(_PostFrame);
}
#pragma mark --- 计算帖子的frame
- (void)setUpPostsFrame{
    
    // 头像
    CGFloat faceX = Margin30 * IPHONE6_W_SCALE;
    CGFloat faceY = 28 * 0.5 * IPHONE6_H_SCALE;
    CGFloat faceW = 76 * 0.5 * IPHONE6_W_SCALE;
    CGFloat faceH = faceW;
    _faceFrame = CGRectMake(faceX, faceY, faceW, faceH);
    
    // 姓名
    CGFloat nameX = CGRectGetMaxX(_faceFrame) + Margin22 * IPHONE6_W_SCALE;
    CGFloat nameY = 38 * 0.5 * IPHONE6_H_SCALE;
    
    NSMutableDictionary * nameDic = [NSMutableDictionary dictionary];
    nameDic[NSFontAttributeName] = Font15;
    CGSize nameSize = [_postsModel.username sizeWithAttributes:nameDic];
    _nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
     // 时间 (时间会变)
    
    // 帖子标题
    CGFloat titleX = 128 * 0.5 * IPHONE6_W_SCALE;
    CGFloat titleY = CGRectGetMaxY(_faceFrame) + Margin30 * IPHONE6_H_SCALE;
    CGFloat titleW = WIDTH - titleX - 15 * IPHONE6_W_SCALE;
    
    NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
    titleDic[NSFontAttributeName] = Font16;
    CGRect titleRect = [_postsModel.title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
    _titleFrame = (CGRect){{titleX, titleY}, titleRect.size};
    
    // 帖子内容
    CGFloat contentsX = titleX;
    CGFloat contentsY = CGRectGetMaxY(_titleFrame) + 12 * IPHONE6_H_SCALE;
    CGFloat contentsW = WIDTH - contentsX - 15 * IPHONE6_W_SCALE;
    
    NSMutableDictionary * contentsDic = [NSMutableDictionary dictionary];
    contentsDic[NSFontAttributeName] = Font13;
    CGRect contentsRect = [_postsModel.introduction boundingRectWithSize:CGSizeMake(contentsW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentsDic context:nil];
    _contentsFrame = (CGRect){{contentsX, contentsY}, contentsRect.size};
    
    // 如果有对回帖的回复
//    if () {
//        <#statements#>
//    }
    
    
    // 帖子图片
    CGFloat postH = CGRectGetMaxY(_contentsFrame) + 14 * IPHONE6_H_SCALE;   // 帖子的高度
    
    if (_postsModel.picname) {    // 如果有图片
        
        NSLog(@"----图片的个数:%lu", _postsModel.picname.count);
        CGFloat photosX = titleX;
        CGFloat photosY = CGRectGetMaxY(_contentsFrame) + 7 * IPHONE6_H_SCALE;
        // 计算配图视图的大小（根据图片的数量）
        CGSize photosSize = [self photosSizeWithCount:_postsModel.picname.count];
        _picsFrame = (CGRect){{photosX,photosY},photosSize};
        postH = CGRectGetMaxY(_picsFrame) + 14 * IPHONE6_H_SCALE;
    } 
    
    // 帖子的frame
    CGFloat postX = 0;
    CGFloat postY = 0;
    CGFloat postW = WIDTH;
    
    _PostFrame = CGRectMake(postX, postY, postW, postH);
}

#pragma mark - 计算配图的尺寸
- (CGSize)photosSizeWithCount:(NSUInteger)count
{
    CGFloat w;
    CGFloat h;
    if (count == 1) {   // 只有一张图片
        w = 120 * IPHONE6_W_SCALE;
        h = 80 * IPHONE6_W_SCALE;
    }  else if (count == 2){    // 只有两张图片
        w = 170 * IPHONE6_W_SCALE;
        h = 80 * IPHONE6_W_SCALE;
    } else{ // 其它情况
        w = 170*0.5*3 * IPHONE6_W_SCALE;
        h = 80 * IPHONE6_W_SCALE;
    }
    
    
    
    return CGSizeMake(w, h);
    
}
@end
