//
//  PostView.h
//  dipai
//
//  Created by 梁森 on 16/6/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PostFrameModel;
@interface PostView : UIView
/**
 *  帖子的frame
 */
@property (nonatomic, strong) PostFrameModel * postFrame;

@end
