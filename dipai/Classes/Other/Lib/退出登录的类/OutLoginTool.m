//
//  OutLoginTool.m
//  dipai
//
//  Created by 梁森 on 16/12/19.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "OutLoginTool.h"

@implementation OutLoginTool
+ (void)outLoginAction{
    
    NSLog(@"============删除cookie===============");
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    //删除cookie
    for (NSHTTPCookie *tempCookie in cookies) {
        [cookieStorage deleteCookie:tempCookie];
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    // 删除别名
    NSDictionary * xcDic =  [defaults objectForKey:WXUser];
    NSString * userid1 = xcDic[@"userid"];
    NSDictionary * phoneDic = [defaults objectForKey:User];
    NSString * userid2 = phoneDic[@"userid"];
    //    NSLog(@"xcDic:%@", xcDic);
    //    NSLog(@"phoneDic:%@", phoneDic);
    //    NSLog(@"userid1:%@", userid1);
    //    NSLog(@"userid2:%@", userid2);
    [UMessage removeAlias:userid1 type:@"ALIAS_TYPE.DIPAI" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"删除userid1成功:%@", responseObject);
        NSLog(@"删除userid1失败:%@", responseObject);
    }];
    [UMessage removeAlias:userid2 type:@"ALIAS_TYPE.DIPAI" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        NSLog(@"删除userid2成功:%@", responseObject);
        NSLog(@"删除userid1失败:%@", responseObject);
    }];
    
    [defaults removeObjectForKey:Cookie];
    [defaults removeObjectForKey:Phone];
    [defaults removeObjectForKey:User];
    [defaults removeObjectForKey:WXUser];
}
@end
