//
//  ClubInformationVC.h
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubInformationVCDelegate <NSObject>
// 跳转到图集页面
- (void)showMorePicsWithImages:(NSArray *)images;
// 传递其它三个页面的URL
- (void)sendURLWhenDisappearWithArr:(NSArray *)URLArr andID:(NSString *)iD;

@end

@interface ClubInformationVC : UIViewController
/**
 *  接口
 */
@property (nonatomic, copy) NSString * wapurl;

@property (nonatomic, assign) id <ClubInformationVCDelegate> delegate;

@end
