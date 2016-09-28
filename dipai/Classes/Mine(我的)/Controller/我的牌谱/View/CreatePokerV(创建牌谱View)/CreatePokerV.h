//
//  CreatePokerV.h
//  dipai
//
//  Created by 梁森 on 16/9/6.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePokerV : UIView
// 关闭按钮
@property (nonatomic, strong) UIButton * deleteBtn;
// 导入按钮
@property (nonatomic, strong) UIButton * importBtn;
// 编写按钮
@property (nonatomic, strong) UIButton * writeBtn;

@property (nonatomic, strong) UILabel  * titleLbl;

@end
