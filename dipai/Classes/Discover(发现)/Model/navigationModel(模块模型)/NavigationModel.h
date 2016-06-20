//
//  NavigationModel.h
//  dipai
//
//  Created by 梁森 on 16/6/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationModel : NSObject
/*
 "club":"http://dipaiapp.replays.netapp/club/list",
 "match":"1",
 "poker":"1",
 "special":
 */

/**
*  俱乐部接口
*/
@property (nonatomic, copy) NSString * club;
/**
 *  赛事接口
 */
@property (nonatomic, copy) NSString * match;
/**
 *  扑克名人堂接口
 */
@property (nonatomic, copy) NSString * poker;
/**
 *  专题接口
 */
@property (nonatomic, copy) NSString * special;

@end
