//
//  MineController.h
//  dipai
//
//  Created by 梁森 on 16/4/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MineController : BaseViewController


@property (nonatomic, copy ) void(^complete)(void);
@end
