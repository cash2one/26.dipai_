//
//  HttpTool.m
//  dipai
//
//  Created by 梁森 on 16/5/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "HttpTool.h"
// AF第三方
#import "AFNetworking.h"
#import <UIKit/UIKit.h>
#import "RootTabBarController.h"
#import "RootNavigationController.h"

#import "BaseViewController.h"
@implementation HttpTool

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    if (![URLString hasPrefix:@"http"]) {
        URLString = [NSString stringWithFormat:@"%@%@", DipaiBaseURL, URLString];
    }
    [mgr GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", URLString);
        NSLog(@"获取数据：%@", responseObject);
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * cookieName = [defaults objectForKey:Cookie];
        NSDictionary * wxData = [defaults objectForKey:WXUser];
        if (cookieName || wxData) { // 如果已经登录
            if (responseObject[@"state"] && [responseObject[@"state"] isEqualToString:@"96"]) { // 如果异地登录
                
                if (success) {
                    success(responseObject);
                }
                NSString * message = responseObject[@"content"];
                UIWindow * window = [UIApplication sharedApplication].keyWindow;
                RootTabBarController * tabBarC = (RootTabBarController *)window.rootViewController;
                NSNumber * index = [defaults objectForKey:tabBarIndex];
                NSInteger tabIndex = [index integerValue];
                RootNavigationController * nav = (RootNavigationController *)tabBarC.childViewControllers[tabIndex];
                UIViewController * VC = [nav.viewControllers lastObject];
                UIViewController * firstVC = [nav.viewControllers firstObject];
                // 不管有没有present的VC都先dismiss,防止有present的VC
                [VC dismissViewControllerAnimated:YES completion:nil];
                UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 确定按钮做两个操作：1.退出登录  2.回到根视图
                    NSLog(@"退出登录...");
                     [OutLoginTool outLoginAction];
                    if ([VC isEqual:firstVC] && [VC isKindOfClass:[BaseViewController class]]) {
                        NSLog(@"刷新该页面");
                        BaseViewController * vc = (BaseViewController *)VC;
                        [vc getData];
                    }else{
                        [VC.navigationController popToRootViewControllerAnimated:YES];
                    }
                   
                }];
                [alertC addAction:action];
                [VC presentViewController:alertC animated:YES completion:nil];
            }else{
                
                if (success) {
                    success(responseObject);
                }
            }
          
        }else{  // 如果未登录
            NSLog(@"没有登录");
            if (success) {
                success(responseObject);
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    // 创建请求管理者
    if (![URLString hasPrefix:@"http"]) {
        URLString = [NSString stringWithFormat:@"%@%@", DipaiBaseURL, URLString];
    }
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSString * message = responseObject[@"content"];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * cookieName = [defaults objectForKey:Cookie];
        NSDictionary * wxData = [defaults objectForKey:WXUser];
        if (cookieName || wxData) { // 如果已经登录
            if (responseObject[@"state"] && [responseObject[@"state"] isEqualToString:@"96"]) { // 如果异地登录
                NSString * message = responseObject[@"content"];
                UIWindow * window = [UIApplication sharedApplication].keyWindow;
                RootTabBarController * tabBarC = (RootTabBarController *)window.rootViewController;
                NSNumber * index = [defaults objectForKey:tabBarIndex];
                NSInteger tabIndex = [index integerValue];
                RootNavigationController * nav = (RootNavigationController *)tabBarC.childViewControllers[tabIndex];
                UIViewController * VC = [nav.viewControllers lastObject];
                UIViewController * firstVC = [nav.viewControllers firstObject];
                [VC dismissViewControllerAnimated:YES completion:nil];
                UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 确定按钮做两个操作：1.退出登录  2.回到根视图
                    NSLog(@"退出登录...");
                    [OutLoginTool outLoginAction];
                    if ([VC isEqual:firstVC] && [VC isKindOfClass:[BaseViewController class]]) {
                        NSLog(@"刷新该页面");
                        BaseViewController * vc = (BaseViewController *)VC;
                        [vc getData];
                    }else{
                        [VC.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                }];
                [alertC addAction:action];
                [VC presentViewController:alertC animated:YES completion:nil];
            }else{
                if (success) {
                    success(responseObject);
                }
            }
        }else{  // 如果未登录
            
            if (success) {
                success(responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)endRequest{
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr.operationQueue cancelAllOperations];
}


@end
