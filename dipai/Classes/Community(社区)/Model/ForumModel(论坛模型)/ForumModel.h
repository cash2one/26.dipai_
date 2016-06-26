//
//  ForumModel.h
//  dipai
//
//  Created by 梁森 on 16/6/22.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface ForumModel : NSObject<MJKeyValue>
/*
 "section":[
 {
 "id":"3",
 "name":"自由",
 "picname":"",
 "wapurl":"http://dipaiapp.replays.net/app/forum/list/3"
 },
 Object{...}
 ],
 "hot":[
 
 ]
 */

/**
*  版块
*/
@property (nonatomic, strong) NSArray * section;
/**
 *  热门讨论区
 */
@property (nonatomic, strong) NSArray * hot;
@end
