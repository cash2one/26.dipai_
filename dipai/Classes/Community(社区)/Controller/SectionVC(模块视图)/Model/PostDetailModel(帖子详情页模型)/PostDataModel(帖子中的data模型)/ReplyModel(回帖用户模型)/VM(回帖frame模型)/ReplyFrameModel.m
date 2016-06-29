//
//  ReplyFrameModel.m
//  dipai
//
//  Created by 梁森 on 16/6/28.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ReplyFrameModel.h"

#import "ReplyModel.h"

#import "UIImageView+getSize.h"
@implementation ReplyFrameModel

- (void)setReplyModel:(ReplyModel *)replyModel{
    _replyModel = replyModel;
    // 计算回帖的frame
    [self setUpPostsFrame];
    _cellHeight = CGRectGetMaxY(_ReplyFrame);
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
    CGSize nameSize = [_replyModel.username sizeWithAttributes:nameDic];
    _nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    // 时间 (时间会变)
    
    // 楼层标题
    CGFloat indexX = CGRectGetMaxX(_nameFrame) + 14 * IPHONE6_W_SCALE;
    CGFloat indexY = CGRectGetMaxY(_nameFrame) + 4 * IPHONE6_H_SCALE;
    CGFloat indexW = 50 * IPHONE6_W_SCALE;
    CGFloat indexH = 11 * IPHONE6_H_SCALE;
    _replyIndexFrame = CGRectMake(indexX, indexY, indexW, indexH);
    
    // 回复按钮
    
    
    // 回帖内容
    CGFloat contentsX = faceX;
    CGFloat contentsY = CGRectGetMaxY(_faceFrame) + 14 * IPHONE6_H_SCALE;
    CGFloat contentsW = WIDTH - 2 * contentsX;
    
    NSMutableDictionary * contentsDic = [NSMutableDictionary dictionary];
    contentsDic[NSFontAttributeName] = Font15;
    CGRect contentsRect = [_replyModel.content boundingRectWithSize:CGSizeMake(contentsW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentsDic context:nil];
    _contentsFrame = (CGRect){{contentsX, contentsY}, contentsRect.size};
    
    // 帖子图片
    CGFloat postH = CGRectGetMaxY(_contentsFrame) + 14 * IPHONE6_H_SCALE;   // 帖子的高度
    
    if (_replyModel.picname) {    // 如果有图片
        
        CGFloat photosX = faceX;
        CGFloat photosY = CGRectGetMaxY(_contentsFrame) + 7 * IPHONE6_H_SCALE;
        // 计算配图视图的大小（根据图片的数量）
        
        NSLog(@"%@", _replyModel.picname);
        
        CGSize photosSize = [self photosSizeWithCount:_replyModel.picname.count];
        _picsFrame = (CGRect){{photosX,photosY},photosSize};
        
        if (_replyModel.reply) {    // 如果有对回帖的回复
            
//            CGFloat nameX = 13 * IPHONE6_W_SCALE;
//            CGFloat nameY = 14 * IPHONE6_H_SCALE;
//            NSMutableDictionary * nameDic = [NSMutableDictionary dictionary];
//            nameDic[NSFontAttributeName] = Font13;
//            CGSize nameSize = [_replyModel.reply[@"username"] sizeWithAttributes:nameDic];
//            _nameFrame = (CGRect){{nameX, nameY}, nameSize};
//            
//            CGFloat x = 15 * IPHONE6_W_SCALE;
//            CGFloat y = CGRectGetMaxY(_picsFrame) + 9 * IPHONE6_H_SCALE;
//            CGFloat w = WIDTH - 2 * x;
//            CGFloat h = (28 + 26 + 26 + 28) * 0.5 * IPHONE6_H_SCALE;
//            
//            CGRect 
//            
//            _ReReplyFrame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        }
        
        postH = CGRectGetMaxY(_picsFrame) + 14 * IPHONE6_H_SCALE;
    }
    
    // 帖子的frame
    CGFloat postX = 0;
    CGFloat postY = 0;
    CGFloat postW = WIDTH;
    
    _ReplyFrame = CGRectMake(postX, postY, postW, postH);
    
    
}
#pragma mark - 计算配图的尺寸
- (CGSize)photosSizeWithCount:(NSUInteger)count
{
    CGFloat w = WIDTH - 30 * IPHONE6_W_SCALE;
    CGFloat h = 0.0;
    
    for (int i = 0; i < count; i ++) {
        CGSize size = [UIImageView downloadImageSizeWithURL:[NSURL URLWithString:_replyModel.picname[i]]];
        CGFloat height = size.height;
        h = h + (height+8) * IPHONE6_H_SCALE;
    }
    
    NSLog(@"所有图片的高度：－－－－%f", h);
    
    return CGSizeMake(w, h);
    
}
@end
