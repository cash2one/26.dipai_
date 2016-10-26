//
//  MemberBeneCellModel.h
//  dipai
//
//  Created by 梁森 on 16/10/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberBeneCellModel : NSObject

/**
 *  礼遇数组
 */
@property (nonatomic, strong) NSArray * benefitsArr;

/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
