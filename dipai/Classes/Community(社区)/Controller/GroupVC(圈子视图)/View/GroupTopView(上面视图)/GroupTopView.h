//
//  GroupTopView.h
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupFrameModel;
@class GrpPostFrmModel;

@protocol GroupTopViewDelegate <NSObject>

// 点击头像的点击事件
- (void)didClickFace;

@end

@interface GroupTopView : UIView

@property (nonatomic, assign) id <GroupTopViewDelegate> delegate;

@property (nonatomic, strong) GrpPostFrmModel * grpFrmModel;

@property (nonatomic, strong) GroupFrameModel * frameModel;

@end
