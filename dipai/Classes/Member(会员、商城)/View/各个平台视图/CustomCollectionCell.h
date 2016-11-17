//
//  CustomCollectionCell.h
//  UICollectionViewCell的复用
//
//  Created by 梁森 on 16/10/18.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomCollectionCell;
@class PlatformModel;
@protocol CustomCollectionCellDelegate <NSObject>

- (void)tableViewCell:(CustomCollectionCell *)cell didClickWithURL:(NSString *)url;

@end

@interface CustomCollectionCell : UICollectionViewCell
// 平台图片
@property (nonatomic, strong) UIImageView * picV;
// 更多信息按钮
@property (nonatomic, strong) UIButton * moreBtn;
// 平台网页网址
@property (nonatomic, copy) NSString * url;
// 第几个平台
@property (nonatomic, assign) NSInteger * row;
// 传递过来的平台模型
@property (nonatomic, strong) PlatformModel * model;
@property (nonatomic, assign) id<CustomCollectionCellDelegate>delegate;
@end
