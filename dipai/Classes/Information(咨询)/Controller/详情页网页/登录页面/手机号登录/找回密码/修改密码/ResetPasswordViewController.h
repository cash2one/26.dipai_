//
//  ResetPasswordViewController.h
//  dipai
//
//  Created by 梁森 on 16/5/27.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController
// 寻找密码的手机号
@property (nonatomic, copy) NSString * phone;
// 验证码
@property (nonatomic, copy) NSString * codeStr;
@end
