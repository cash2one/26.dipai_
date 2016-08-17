//
//  ClubCommentsVC.h
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ClubCommentsVCDelegate <NSObject>
// 跳转到登录页面
- (void)presentLoginVC;

// 跳转到用户主页页面
- (void)turnPageToSBPageWithURL:(NSString *)url withFlag:(NSString *)flag;

@end

@interface ClubCommentsVC : UIViewController
/**
 *  俱乐部ID
 */
@property (nonatomic, copy) NSString * iD;
/**
 *  接口
 */
@property (nonatomic, copy) NSString * wapurl;

@property (nonatomic, assign) id<ClubCommentsVCDelegate> delegate;
@end
