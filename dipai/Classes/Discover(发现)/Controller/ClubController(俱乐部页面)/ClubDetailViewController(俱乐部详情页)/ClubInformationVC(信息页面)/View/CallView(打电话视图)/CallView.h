//
//  CallView.h
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallView : UIView
/**
 *  呼叫
 */
@property (nonatomic, strong) UILabel * callLbl;
/**
 *  电话号码
 */
@property (nonatomic, strong) UILabel * numLbl;
/**
 *  是按钮
 */
@property (nonatomic, strong) UIButton * yesBtn;
/**
 *  否按钮
 */
@property (nonatomic, strong) UIButton * noBtn;
@end
