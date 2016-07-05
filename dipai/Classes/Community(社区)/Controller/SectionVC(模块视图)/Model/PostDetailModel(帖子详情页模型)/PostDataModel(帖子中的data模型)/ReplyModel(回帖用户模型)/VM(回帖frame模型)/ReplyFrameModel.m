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
    if (_replyModel.reply[@"username"]) {  // 如果有回复内容
        
        // 计算对回帖回复高度
        [self setUpReReplyFrame];
        
        _cellHeight = CGRectGetMaxY(_ReReplyFrame) + 14 * IPHONE6_H_SCALE;
    } else{
        _cellHeight = CGRectGetMaxY(_ReplyFrame);
    }
    
//    NSLog(@"cellHeight:%f", _cellHeight);
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
        CGFloat photosY = CGRectGetMaxY(_contentsFrame) + 14 * IPHONE6_H_SCALE;
        // 计算配图视图的大小（根据图片的数量）
        
//        NSLog(@"%@", _replyModel.picname);
        
        CGSize photosSize = [self photosSizeWithCount:_replyModel.picname.count];
        _picsFrame = (CGRect){{photosX,photosY},photosSize};
        
        postH = CGRectGetMaxY(_picsFrame);
    }
    
    // 帖子的frame
    CGFloat postX = 0;
    CGFloat postY = 0;
    CGFloat postW = WIDTH;
    
    _ReplyFrame = CGRectMake(postX, postY, postW, postH);
    
}

- (void)setUpReReplyFrame{
    // 回复用户名
    CGFloat nameX = 13 * IPHONE6_W_SCALE;
    CGFloat nameY = 14 * IPHONE6_H_SCALE;
    
    NSMutableDictionary * nameDic = [NSMutableDictionary dictionary];
    nameDic[NSFontAttributeName] = Font13;
    CGSize nameSize = [_replyModel.reply[@"username"] sizeWithAttributes:nameDic];
    
    _ReNameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    // 回复的内容
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(_ReNameFrame) + Margin26 * IPHONE6_H_SCALE;
    CGFloat contentW = WIDTH - 56 * IPHONE6_W_SCALE;
    
    NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
    contentDic[NSFontAttributeName] = Font14;
    CGRect contentRect = [_replyModel.reply[@"content"] boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil];
    _ReContentFrame = (CGRect){{contentX, contentY}, contentRect.size};
    
    // 回复的frame
    CGFloat replyX = 15 * IPHONE6_H_SCALE;
    CGFloat replyY = CGRectGetMaxY(_ReplyFrame);
    CGFloat replyW = WIDTH - 30*IPHONE6_W_SCALE;
    CGFloat replyH = CGRectGetMaxY(_ReContentFrame) + 28 / 2 * IPHONE6_H_SCALE;
    _ReReplyFrame = CGRectMake(replyX, replyY, replyW, replyH);
}

#pragma mark - 计算配图的尺寸
- (CGSize)photosSizeWithCount:(NSUInteger)count
{
    CGFloat w = WIDTH - 30 * IPHONE6_W_SCALE;
    CGFloat h = 0.0;
    
    for (int i = 0; i < count; i ++) {
        CGSize size = [UIImageView downloadImageSizeWithURL:[NSURL URLWithString:_replyModel.picname[i]]];
        
        CGFloat height = size.height;
        CGFloat width = size.width;
        
        if (width == 0) {
            width = WIDTH - 30 * IPHONE6_W_SCALE;
        }
        
        CGFloat scale = 1.0;
        if (size.width<WIDTH-30*IPHONE6_W_SCALE) {
            
//            NSLog(@"scale1---%f", scale);
            
            scale = (WIDTH - 30 * IPHONE6_W_SCALE)/width;
            height = height * scale;
        } else{
            scale = 1.0;
            height = height;
        }
        
        h = h + (height+8) * IPHONE6_H_SCALE;
    }
    
//    NSLog(@"所有图片的高度：－－－－%f", h);
    
    return CGSizeMake(w, h);
    
}
@end
