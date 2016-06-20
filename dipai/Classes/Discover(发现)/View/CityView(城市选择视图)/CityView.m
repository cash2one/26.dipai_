//
//  CityView.m
//  dipai
//
//  Created by 梁森 on 16/6/12.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CityView.h"

@interface CityView()
@end

@implementation CityView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置上面的子控件
        [self setUpChildView];
    }
    
    return self;
}
#pragma mark --- 设置子控件
- (void)setUpChildView
{
    
    
}


- (void)setCityModelArr:(NSArray *)cityModelArr{
    _cityModelArr = cityModelArr;
    
    NSLog(@"传过来的城市模型数量%lu", _cityModelArr.count);
    
}
@end
