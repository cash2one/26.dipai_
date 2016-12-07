//
//  AppDelegate.m
//  dipai
//
//  Created by 梁森 on 16/4/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AppDelegate.h"
// 根视图控制器
#import "RootTabBarController.h"
// 数据库
#import "DataBase.h"

// 资讯详情页
#import "DetailWebViewController.h"
#import "InfomationViewController.h"
#import "NotificationVC.h"

// 友盟分享
#import "UMSocial.h"
#import "WXApi.h"

// 友盟推送
#import "UMessage.h"

#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import <UserNotifications/UserNotifications.h>

#import "SVProgressHUD.h"
// 腾讯云播放器
#import "TCPlayerBottomView.h"
#import "TCCloudPlayerControlView.h"

#import "DataTool.h"
#import "AFNetworking.h"
#import <JSPatchPlatform/JSPatch.h>
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface AppDelegate ()<WXApiDelegate, UIAlertViewDelegate, UNUserNotificationCenterDelegate>
{
    NSString * _url;    // 推送的网址
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // JSPatch
    [JSPatch startWithAppKey:@"49f780b700069d72"];
    [JSPatch sync];
    
    // 设置根控制器
    // 根视图控制器
    RootTabBarController * root = [[RootTabBarController alloc] init];
    self.window.rootViewController = root;
        
//    [DataBase setUpMagicalRecord];//初始化数据库
    
    [self setUpTCPlayer];
    
    // 设置友盟分享
    [self setUpUMShare];
    
    
    // 友盟SDK为了兼容Xcode3的工程，默认取的是Build号，如果需要取Xcode4及以上版本的Version，可以在StartWithAppkey之前调用下面的方法：
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //友盟推送
    [UMessage startWithAppkey:@"55556bc8e0f55a56230001d8" launchOptions:launchOptions];
    
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
            
            NSLog(@"允许推送。。。");
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
            NSLog(@"不允许推送...");
        }
    }];
    //for log
    [UMessage setLogEnabled:YES];
    
    if ([[[UIDevice currentDevice] systemVersion] intValue ] < 10) {
        // 如果是iOS10以下
        NSLog(@"版本小于10。。。");
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification) { // 说明有通知
            NSLog(@"---userInfo---%@", remoteNotification);
            _url = remoteNotification[@"1"];
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:remoteNotification[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即查看", nil];
            [alertView show];
            
        } else
        {
            NSLog(@"没有通知...");
        }
    }else{
        
        NSLog(@"版本大于10.。。");
    }
    
    
    // 友盟统计
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"55556bc8e0f55a56230001d8";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    
    [NSThread sleepForTimeInterval:2.0];
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];   // 程序启动后开始进行网络的监听
    [self.window makeKeyAndVisible];    // 让窗口可见
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    // 说明App已启动
    [defaults setObject:@"first" forKey:appStart];
    return YES;
}

#pragma mark --- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    if(buttonIndex == 0){
        NSLog(@",,,");
    }else{
        if(_url.length > 0 ){
            RootTabBarController * root = (RootTabBarController *)self.window.rootViewController;
            if(root.selectedIndex != 0){    // 如果当前页面不是首页转换到首页，在首页中进行跳转
                root.selectedIndex = 0;
                if([self.delegate respondsToSelector:@selector(pushToViewControllerWithURL:)]){
                    
                    [self.delegate pushToViewControllerWithURL:_url];
                }else{
                    NSLog(@"跳转时，AppDelegate的代理没有响应...");
                }
            }else{
                if([self.delegate respondsToSelector:@selector(pushToViewControllerWithURL:)]){
                    
                    [self.delegate pushToViewControllerWithURL:_url];
                }else{
                    NSLog(@"跳转时，AppDelegate的代理没有响应...");
                }
            }
        }else{
            // 跳转到通知中心
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNoti" object:nil];
        }
    }
}

#pragma mark --- 收到远程推送
// 使用友盟（如：推送、分享）要回调的三个方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"注册通知...");
    NSLog(@"deviceToken:%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    // 友盟推送用到的
    // 将deviceToken发送给友盟服务器
    [UMessage registerDeviceToken:deviceToken];
    
}

//iOS10以下使用这个方法接收通知
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    [UMessage didReceiveRemoteNotification:userInfo];
//}

// 接收到远程推送调用此方法（前提：程序在运行中）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    
    [UMessage didReceiveRemoteNotification:userInfo];
    //    NSLog(@"---userInfo---%@", userInfo);
    NSString * string1 = userInfo[@"1"];
        NSLog(@"---string---%@", string1);
    _url = string1;
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        //        NSLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即查看", nil];
        [alertView show];
        
    }
    else//后台运行状态下，直接跳转到跳转页面。
    {
        // 跳转到通知中心
        
        if (_url.length > 0) {
            if ([self.delegate respondsToSelector:@selector(pushToViewControllerWithURL:)]) {
                [self.delegate pushToViewControllerWithURL:_url];
            }else{
                NSLog(@"跳转时，AppDelegate的代理没有响应...");
            }
        }else{
            // 跳转到通知中心
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNoti" object:nil];
        }
    }
    
}


// 处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        // 应用处于前台时的远程推送接受
        // 必须添加这行代码
        [UMessage didReceiveRemoteNotification:userInfo];
        NSLog(@"前台。。。");
        NSString * str = userInfo[@"1"];
        _url = str;
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即查看", nil];
        [alertView show];
    }else{
        
        // 应用处于前台时的本地推送接受
    }
}

// 处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        // 应用处于后台时的远程推送接受
        // 必须添加这行代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        NSString * str = userInfo[@"1"];
        _url = str;
        NSLog(@"后台");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即查看", nil];
        [alertView show];
    }else{
        
        // 应用处于后台时的本地推送接受
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}


#pragma mark --- 设置友盟分享
- (void)setUpUMShare{
    [UMSocialData setAppKey:@"55556bc8e0f55a56230001d8"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3205758101" secret:@"aef7fb35e74f046206e3de6f513b47ef" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    // 登录的就不用在写了
    //分享微信 微信好友、微信朋友圈
    [UMSocialWechatHandler setWXAppId:@"wx4cb9b2da7d176df3" appSecret:@"fe59b6d505e4d8d51a3c4b50ab3c5703" url:nil];
    
    //分享QQ  QQ好友、QQ空间
    [UMSocialQQHandler setQQWithAppId:@"1104698514" appKey:@"SEex8zSMjkTlD4Rl" url:@"http://www.umeng.com/social"];
    
    [WXApi registerApp:@"wx4cb9b2da7d176df3"];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"weixin:%@", url);
    // 微信登录
    if ([url.host isEqualToString:@"oauth"]) {
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }else{
        
        BOOL result = [UMSocialSnsService handleOpenURL:url];
        if (result == FALSE) {
            //调用其他SDK，例如支付宝SDK等
        }
        return result;
        
    }
    
}

// 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
- (void)onResp: (BaseReq *) resp{
    
    NSLog(@"onResP:%s", __func__);
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {    // 用户同意
            NSString *code = aresp.code;
                
            if ([self.delegate respondsToSelector:@selector(dismissWithStr:)]) {
                [self.delegate dismissWithStr:code];
            }else{
                NSLog(@"AppDelegate的代理没有响应...");
            }
        }
    }
}




#pragma mark --- 设置腾讯云播放器
- (void)setUpTCPlayer{
    // 腾讯云播放器   设置默认控件类
    // 可以让播放起下面出现暂停、播放按钮以及全频按钮
    [TCPlayerView setPlayerBottomViewClass:[TCPlayerBottomView class]];
    [TCPlayerView setPlayerCtrlViewClass:[TCCloudPlayerControlView class]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
