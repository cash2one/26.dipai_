//
//  AppDelegate.h
//  dipai
//
//  Created by 梁森 on 16/4/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppDelegate <NSObject>
// 退出登录页面
- (void)dismissWithStr:(NSString *)str;

// 跳转页面
- (void)pushToViewControllerWithURL:(NSString *)url;

@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, assign) id <AppDelegate> delegate;
@property (strong, nonatomic) UIWindow *window;


@end

