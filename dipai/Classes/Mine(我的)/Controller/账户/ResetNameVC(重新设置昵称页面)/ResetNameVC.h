//
//  ResetNameVC.h
//  dipai
//
//  Created by 梁森 on 16/7/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationHiddenVC.h"
@interface ResetNameVC : NavigationHiddenVC
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) void (^changeName)(NSString * newName);
@end
