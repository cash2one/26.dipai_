//
//  PhoneLoginViewController.h
//  dipai
//
//  Created by 梁森 on 16/5/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhoneLoginViewControllerDelegate <NSObject>

- (void)dismiss;

@end

@interface PhoneLoginViewController : UIViewController

@property (nonatomic, assign) id <PhoneLoginViewControllerDelegate> delegate;

@end
