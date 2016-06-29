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
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UIButton *imgV0;
@property (nonatomic, assign) BOOL res;

@end
