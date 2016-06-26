//
//  PostFrameModel.h
//  dipai
//
//  Created by 梁森 on 16/6/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PostsModel;
@interface PostFrameModel : NSObject

// 帖子数据
@property (nonatomic, strong) PostsModel * postsModel;

/**
 *  帖子frame
 */
@property (nonatomic, assign) CGRect PostFrame;
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
 *  帖子标题的frame
 */
@property (nonatomic, assign) CGRect titleFrame;
/**
 *  帖子内容frame
 */
@property (nonatomic, assign) CGRect contentsFrame;
/**
 *  帖子中图片frame
 */
@property (nonatomic, assign) CGRect picsFrame;


/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
