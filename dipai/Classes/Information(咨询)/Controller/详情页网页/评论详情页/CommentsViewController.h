//
//  CommentsViewController.h
//  dipai
//
//  Created by 梁森 on 16/5/19.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationHiddenVC.h"
@interface CommentsViewController : NavigationHiddenVC
/**
 *  文章类型
 */
@property (nonatomic, copy) NSString * type;
/**
 *  文章ID
 */
@property (nonatomic, copy) NSString * iD;

@end
