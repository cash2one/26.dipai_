//
//  LSAlertView.h
//  dipai
//
//  Created by 梁森 on 16/5/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSAlertView;
@protocol LSAlertViewDeleagte <NSObject>
/**
 *  取消按钮的点击事件
 *
 *  @param alertView <#alertView description#>
 *  @param cancel    <#cancel description#>
 */
- (void)lsAlertView:(LSAlertView *)alertView cancel:(NSString * )cancel;
/**
 *  确定按钮的点击事件
 *
 *  @param alertView <#alertView description#>
 *  @param sure      <#sure description#>
 */
- (void)lsAlertView:(LSAlertView *)alertView sure:(NSString *)sure;

@end

@interface LSAlertView : UIView

@property (nonatomic, strong) id <LSAlertViewDeleagte> delegate;

@end
