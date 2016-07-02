//
//  MyReplyFrameModel.h
//  dipai
//
//  Created by 梁森 on 16/7/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyReplyModel;
@interface MyReplyFrameModel : NSObject

/**
 *  评论数据
 */
@property (nonatomic, strong) MyReplyModel * myreplyModel;

/**
 *  评论frame
 */
@property (nonatomic, assign) CGRect CommentsFrame;
/************评论子控件frame******************/
/**
 *  头像frame
 */
@property (nonatomic, assign) CGRect faceFrame;
/**
 *  姓名frame
 */
@property (nonatomic, assign) CGRect nameFrame;
/**
 *  时间frame
 */
@property (nonatomic, assign) CGRect timeFrame;
/**
 *  评论内容frame
 */
@property (nonatomic, assign) CGRect contentsFrame;
/**
 *  回复图片的frame
 */
@property (nonatomic, assign) CGRect picsFrame;


/**
 *  回复frame
 */
@property (nonatomic, assign) CGRect replyFrame;
/***********回复子控件************/
/**
 *  回复用户名frame
 */
@property (nonatomic, assign) CGRect replyName;
/**
 *  回复内容frame
 */
@property (nonatomic, assign) CGRect replyContent;


/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
