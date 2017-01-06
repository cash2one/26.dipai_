//
//  MyPostsViewController.h
//  dipai
//
//  Created by 梁森 on 16/5/30.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationHiddenVC.h"
@class UserModel;
@interface MyPostsViewController : NavigationHiddenVC

/**
 *  用户模型
 */
@property (nonatomic, strong) UserModel * userModel;
@end
