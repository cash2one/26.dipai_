//
//  CommentsFrame.m
//  dipai
//
//  Created by 梁森 on 16/6/6.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CommentsFrame.h"
// 评论列表模型
#import "CommentsModel.h"
@implementation CommentsFrame

// 将下载下来的数据模型传递过来
- (void)setComments:(CommentsModel *)comments{
    _comments = comments;
    
    // 计算评论
    [self setUpCommentsFrame];
    
//    if (comments.reply[@"username"]) {  // 如果有回复内容
    if (comments.reply) {  // 如果有回复内容
        
        // 计算回复高度
        [self setUpReplyFrame];
        
        _cellHeight = CGRectGetMaxY(_replyFrame) + 14*IPHONE6_H_SCALE;
    } else{
        _cellHeight = CGRectGetMaxY(_CommentsFrame) + 3*IPHONE6_H_SCALE;
    }
    
    
}
#pragma mark ---计算评论高度
- (void)setUpCommentsFrame{
    
    // 头像
    CGFloat faceX = Margin30 * IPHONE6_W_SCALE;
    CGFloat faceY = 28 / 2 * IPHONE6_H_SCALE;
    CGFloat faceW = 76 / 2 * IPHONE6_W_SCALE;
    CGFloat faceH = faceW;
    _faceFrame = CGRectMake(faceX, faceY, faceW, faceH);
    
    // 姓名
    CGFloat nameX = CGRectGetMaxX(_faceFrame) + Margin22 * IPHONE6_W_SCALE;
    CGFloat nameY = 38 / 2 * IPHONE6_H_SCALE;
    
    NSMutableDictionary * nameDic = [NSMutableDictionary dictionary];
    nameDic[NSFontAttributeName] = Font15;
    CGSize nameSize = [_comments.username sizeWithAttributes:nameDic];
    _nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    // 时间 (时间会变)
    
    // 评论内容
    CGFloat contentsX = 128 / 2 * IPHONE6_W_SCALE;
    CGFloat contentsY = CGRectGetMaxY(_faceFrame) + Margin30 * IPHONE6_H_SCALE;
    CGFloat contentsW = WIDTH - contentsX - 30 / 2 * IPHONE6_W_SCALE;
    
    NSMutableDictionary * contentsDic = [NSMutableDictionary dictionary];
    contentsDic[NSFontAttributeName] = Font16;
    CGRect contentsRect = [_comments.content boundingRectWithSize:CGSizeMake(contentsW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentsDic context:nil];
    _contentsFrame = (CGRect){{contentsX, contentsY}, contentsRect.size};
    
    // 评论的frame
    CGFloat commentsX = 0;
    CGFloat commentsY = 0;
    CGFloat commentsW = WIDTH;
    CGFloat commentsH = CGRectGetMaxY(_contentsFrame) + Margin22 * IPHONE6_H_SCALE;
    _CommentsFrame = CGRectMake(commentsX, commentsY, commentsW, commentsH);
}
#pragma mark --- 计算回复高度
- (void)setUpReplyFrame{
    
    // 回复用户名
    CGFloat nameX = Margin34 * IPHONE6_W_SCALE;
    CGFloat nameY = 28 / 2 * IPHONE6_H_SCALE;
    
    NSMutableDictionary * nameDic = [NSMutableDictionary dictionary];
    nameDic[NSFontAttributeName] = Font13;
    CGSize nameSize = [_comments.reply[@"username"] sizeWithAttributes:nameDic];
    
    _replyName = (CGRect){{nameX, nameY}, nameSize};
    
    // 回复的内容
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(_replyName) + Margin26 * IPHONE6_H_SCALE;
    CGFloat contentW = WIDTH - (128 + 34 + 37 + 30) / 2 * IPHONE6_W_SCALE;
    
    NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
    contentDic[NSFontAttributeName] = Font14;
    CGRect contentRect = [_comments.reply[@"content"] boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil];
    _replyContent = (CGRect){{contentX, contentY}, contentRect.size};
    
    // 回复的frame
    CGFloat replyX = 128 / 2 * IPHONE6_H_SCALE;
    CGFloat replyY = CGRectGetMaxY(_CommentsFrame);
    CGFloat replyW = WIDTH - (128 + 30)/2*IPHONE6_W_SCALE;
    CGFloat replyH = CGRectGetMaxY(_replyContent) + 28 / 2 * IPHONE6_H_SCALE;
    _replyFrame = CGRectMake(replyX, replyY, replyW, replyH);
}

@end
