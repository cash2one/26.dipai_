//
//  ClubNewsVC.h
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubNewsVCDelegate <NSObject>
// 跳转到详细页
- (void)turnPageToDetailVCWithURL:(NSString *)wapurl;

@end

@interface ClubNewsVC : UIViewController

@property (nonatomic, assign) id <ClubNewsVCDelegate> delegate;
/**
 *  接口
 */
@property (nonatomic, copy) NSString * wapurl;
@end
