//
//  ReReplyModel.h
//  dipai
//
//  Created by 梁森 on 16/6/28.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

// 实际上是回帖用户
@interface ReReplyModel : NSObject

/*
 "username":"Liangsen226",
 "content":"2"
 */

/**
*  用户名
*/
@property (nonatomic, copy) NSString * username;
/**
 *  回复内容
 */
@property (nonatomic, copy) NSString * content;

@end
