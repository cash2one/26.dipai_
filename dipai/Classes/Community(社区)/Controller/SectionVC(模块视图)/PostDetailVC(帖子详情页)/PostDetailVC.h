//
//  PostDetailVC.h
//  dipai
//
//  Created by 梁森 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostDetailVC : UIViewController
/**
 *  详情页接口
 */
@property (nonatomic, copy) NSString * wapurl;

/**
 *  从个人主页跳过来的时候tableView高度为64
 */
@property (nonatomic, assign) int height;
@property (nonatomic, copy) NSString * heightStr;

@end
