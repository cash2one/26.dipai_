//
//  ReplyFrameModel.h
//  dipai
//
//  Created by 梁森 on 16/6/28.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

// 回帖数据
@class ReplyModel;
@interface ReplyFrameModel : NSObject
/**
 *  回帖数据
 */
@property (nonatomic, strong) ReplyModel * replyModel;

/**
 *  回帖frame
 */
@property (nonatomic, assign) CGRect ReplyFrame;
/************帖子子控件frame******************/
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
 *  回帖楼层的frame
 */
@property (nonatomic, assign) CGRect replyIndexFrame;
/**
 *  回帖内容frame
 */
@property (nonatomic, assign) CGRect contentsFrame;
/**
 *  回帖中图片frame
 */
@property (nonatomic, assign) CGRect picsFrame;


/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;


/**
 *  下方回复的frame
 */
@property (nonatomic, assign) CGRect ReReplyFrame;
/*****************下方回复的子控件*************/
// 用户名frame
@property (nonatomic, assign) CGRect ReNameFrame;
// 回复内容frame
@property (nonatomic, assign) CGRect ReContentFrame;

@end
