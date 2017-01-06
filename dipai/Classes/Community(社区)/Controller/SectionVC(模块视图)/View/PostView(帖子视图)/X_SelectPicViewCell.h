//
//  X_SelectPicViewCell.h
//  dipai
//
//  Created by 梁森 on 16/6/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Action)(void);
@interface X_SelectPicViewCell : UICollectionViewCell

@property (nonatomic, copy) Action action;
@property (nonatomic, copy) Action btnAction;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIButton *btn;                            //删除键
@property (nonatomic, strong) UIImageView *imgV;                  //图片view
@property (nonatomic, strong) UIButton *imgV0;                       //加号
@property (nonatomic, assign) BOOL res;

@end
