//
//  GrpPostFrmModel.m
//  dipai
//
//  Created by 梁森 on 16/7/5.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "GrpPostFrmModel.h"

#import "GroupModel.h"
@implementation GrpPostFrmModel
- (void)setGroupModel:(GroupModel *)groupModel{
    
    _groupModel = groupModel;
    // 计算评论
    [self setUpCommentsFrame];
        
    _cellHeight = CGRectGetMaxY(_CommentsFrame) + 3*IPHONE6_H_SCALE;
    
}

#pragma mark ---计算评论高度
- (void)setUpCommentsFrame{
    
    // 头像
    CGFloat faceX = 10 * IPHONE6_W_SCALE;
    CGFloat faceY = 28 / 2 * IPHONE6_H_SCALE;
    CGFloat faceW = 76 / 2 * IPHONE6_W_SCALE;
    CGFloat faceH = faceW;
    _faceFrame = CGRectMake(faceX, faceY, faceW, faceH);
    
    // 姓名
    CGFloat nameX = CGRectGetMaxX(_faceFrame) + Margin22 * IPHONE6_W_SCALE;
    CGFloat nameY = 38 / 2 * IPHONE6_H_SCALE;
    
    NSMutableDictionary * nameDic = [NSMutableDictionary dictionary];
    nameDic[NSFontAttributeName] = Font15;
    CGSize nameSize = [_groupModel.username sizeWithAttributes:nameDic];
    _nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    // 时间 (时间会变)
    
    // 评论标题
    CGFloat titleX = 118 * 0.5 * IPHONE6_W_SCALE;
    CGFloat titleY = CGRectGetMaxY(_faceFrame) + Margin30 * IPHONE6_H_SCALE;
    CGFloat titleW = WIDTH - 15 * IPHONE6_W_SCALE - titleX;
//    CGFloat titleW = WIDTH;
//    _titleFrame = CGRectMake(titleX, titleY, WIDTH - 2 * titleW, 16 * IPHONE6_W_SCALE);
    
    NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
    titleDic[NSFontAttributeName] = Font16;
    CGRect titleRect = [_groupModel.title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
    _titleFrame = (CGRect){{titleX, titleY}, titleRect.size};
    
    // 评论内容
    CGFloat contentsX = 118 / 2 * IPHONE6_W_SCALE;
    CGFloat contentsY = CGRectGetMaxY(_titleFrame) + 13 * IPHONE6_H_SCALE;
    CGFloat contentsW = WIDTH - contentsX - 30 / 2 * IPHONE6_W_SCALE;
    
    NSMutableDictionary * contentsDic = [NSMutableDictionary dictionary];
    contentsDic[NSFontAttributeName] = Font13;
    CGRect contentsRect = [_groupModel.introduction boundingRectWithSize:CGSizeMake(contentsW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentsDic context:nil];
    _contentsFrame = (CGRect){{contentsX, contentsY}, contentsRect.size};
    
    
    // 如果有图片上面视图的frame
    CGFloat commentsH = CGRectGetMaxY(_contentsFrame) + Margin22 * IPHONE6_H_SCALE;
    if (_groupModel.picname) {    // 如果有图
        CGFloat picX = 118 * 0.5 * IPHONE6_W_SCALE;
        CGFloat picY = CGRectGetMaxY(_contentsFrame) + 7 * IPHONE6_H_SCALE;
        CGFloat picW = WIDTH - picX;
        CGFloat picH = 80 * IPHONE6_H_SCALE;
        _picsFrame = CGRectMake(picX, picY, picW, picH);
        commentsH = CGRectGetMaxY(_picsFrame) + Margin22 * IPHONE6_H_SCALE;
    }
    
    // 评论的frame
    CGFloat commentsX = 0;
    CGFloat commentsY = 0;
    CGFloat commentsW = WIDTH;
    
    _CommentsFrame = CGRectMake(commentsX, commentsY, commentsW, commentsH);
}
@end
