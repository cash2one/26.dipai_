//
//  CustomCollectionCell.h
//  UICollectionViewCell的复用
//
//  Created by 梁森 on 16/10/18.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionCell : UICollectionViewCell
// 平台图片
@property (nonatomic, strong) UIImageView * picV;
// 更多信息按钮
@property (nonatomic, strong) UIButton * moreBtn;

@end
