//
//  AdvertisementView.h
//  dipai
//
//  Created by 梁森 on 16/4/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

// 制定协议
@protocol AdvertisementViewDelegate <NSObject>

- (void)turnPageToDetailView:(NSString *)url;

@end
@interface AdvertisementView : UIView

// 将代理设置为自己的属性
@property (nonatomic, assign) id <AdvertisementViewDelegate> delegate;

// 设置滚动视图
- (void)setScrollWithCount:(int)counts andArray:(NSArray *)bannerModelArray;

@end
