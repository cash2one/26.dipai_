//
//  SpecialDetailVC.h
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationHiddenVC.h"
#import "SpecialModel.h"
@interface SpecialDetailVC : NavigationHiddenVC

@property (nonatomic, copy) NSString * wapurl;
@property (nonatomic, strong) SpecialModel * specialModel;
@end
