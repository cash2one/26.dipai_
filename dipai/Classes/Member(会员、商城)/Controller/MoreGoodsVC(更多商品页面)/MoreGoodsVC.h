//
//  MoreGoodsVC.h
//  dipai
//
//  Created by 梁森 on 16/10/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationHiddenVC.h"
@interface MoreGoodsVC : NavigationHiddenVC

// 请求接口
@property (nonatomic, copy) NSString * url;
// 标题
@property (nonatomic, copy) NSString * titleName;
@end
