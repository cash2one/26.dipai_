//
//  DetailPokerVC.h
//  dipai
//
//  Created by 梁森 on 16/9/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPokerVC : UIViewController
/**
 *  制作人
 */
@property (nonatomic, copy) NSString * userName;

/**
 *  编辑内容
 */
@property (nonatomic, copy) NSString * text;

// 标准编辑内容
@property (nonatomic, strong) NSMutableArray * textArr;

@end
