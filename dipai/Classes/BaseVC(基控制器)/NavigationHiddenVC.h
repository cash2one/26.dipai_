//
//  NavigationHiddenVC.h
//  dipai
//
//  Created by 梁森 on 16/10/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "BaseViewController.h"
#import "NavigationBarV.h"
@interface NavigationHiddenVC : BaseViewController

@property (nonatomic, strong) NavigationBarV * naviBar;


- (void)popAction;
@end
