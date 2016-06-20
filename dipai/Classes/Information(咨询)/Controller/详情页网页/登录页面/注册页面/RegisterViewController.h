//
//  RegisterViewController.h
//  dipai
//
//  Created by 梁森 on 16/5/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterViewControllerDelegate <NSObject>

- (void)dismissAfterRegister;

@end

@interface RegisterViewController : UIViewController

@property (nonatomic, assign) id <RegisterViewControllerDelegate> delegate;

@end
