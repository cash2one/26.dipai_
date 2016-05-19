//
//  InfomationModel.h
//  dipai
//
//  Created by 梁森 on 16/5/18.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfomationModel : NSObject
/**
 *  轮播页属性
 */
@property (nonatomic, strong) NSMutableArray * bannerArray;
/**
 *  赛事属性
 */
@property (nonatomic, strong) NSMutableArray * tournamentArray;
/**
 *  列表属性
 */
@property (nonatomic, strong) NSMutableArray * newslistArray;

@end
