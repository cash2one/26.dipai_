//
//  ReplyPostVC.h
//  dipai
//
//  Created by 梁森 on 16/6/27.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyPostVC : UIViewController
/**
 *  帖子的ID
 */
@property (nonatomic, copy) NSString * iD;
/**
 *  回帖用户的回帖ID
 */
@property (nonatomic, copy) NSString * comm_id;

@end
