//
//  SpecialModel.h
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface SpecialModel : NSObject<MJKeyValue>
/*
 "id":"10094377",
 "title":"扑克规则“郑”解",
 "picname":"http://dipaiadmin.replays.net/uploads/picname/2016/01/14537042885E8.jpg",
 "url":"
 */

/**
*  专题ID
*/
@property (nonatomic, copy) NSString * iD;
/**
 *  专题标题
 */
@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * descriptioN;


/**
 *  专题内容
 */
@property (nonatomic, copy) NSString * content;

/**
 *  专题封面图
 */
@property (nonatomic, copy) NSString * picname;
/**
 *  专题详情页URL
 */
@property (nonatomic, copy) NSString * url;
@end
