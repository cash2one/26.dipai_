//
//  X_SelectPicHeaderView.h
//  dipai
//
//  Created by 辛鹏贺 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Commplete)(void);

@interface X_SelectPicHeaderView : UICollectionReusableView

@property (nonatomic, copy) Commplete commplete;

@end
