//
//  SectionVC.h
//  dipai
//
//  Created by 梁森 on 16/6/22.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationHiddenVC.h"
@class SectionModel;
@interface SectionVC : NavigationHiddenVC
/**
 *  传递过来的链接
 */
@property (nonatomic, strong) NSString * wapurl;

@property (nonatomic, copy) NSString * titleStr;

@property (nonatomic, strong) SectionModel * sectionModel;

@end
