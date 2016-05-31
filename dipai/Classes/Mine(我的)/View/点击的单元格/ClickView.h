//
//  ClickView.h
//  dipai
//
//  Created by 梁森 on 16/5/27.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol ClickViewDelegate <NSObject>
//
//- (void)turePageToNext;
//
//@end

@interface ClickView : UIView

@property (nonatomic, strong) UIImageView * pic;

@property (nonatomic, copy) NSString * message;

@property (nonatomic, copy) NSString * picName;

@property (nonatomic, strong) UILabel * textLbl;

@property (nonatomic, strong) UIImageView * next;

@property (nonatomic, strong) UIButton * btn;
/**
 *  评论数
 */
@property (nonatomic, strong) UILabel * commentNum;

//@property (nonatomic, assign) id <ClickViewDelegate> delegate;

@end
