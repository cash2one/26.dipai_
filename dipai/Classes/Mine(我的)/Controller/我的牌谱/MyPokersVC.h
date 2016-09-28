//
//  MyPokersVC.h
//  dipai
//
//  Created by 梁森 on 16/9/6.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPokersVC : UIViewController

typedef void (^ReturnTextBlock)(NSArray *imageArr);
// push过来的标识
@property (nonatomic, copy) NSString * push;

@property (nonatomic, copy) NSString * present;
/**
 *  制作人
 */
@property (nonatomic, copy) NSString * userName;

/**
 *  已选择的图片个数
 */
@property (nonatomic, assign) NSInteger selectedNumOfPic;

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@end
