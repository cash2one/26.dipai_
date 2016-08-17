//
//  X_SelectPicHeaderView.m
//  dipai
//
//  Created by 辛鹏贺 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "X_SelectPicHeaderView.h"
#import "Masonry.h"
@implementation X_SelectPicHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * selectPicView = [[UIView alloc] initWithFrame:CGRectMake(0,0, WIDTH, 40 * IPHONE6_H_SCALE)];
        selectPicView.backgroundColor = [UIColor whiteColor];
        UIButton * picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectPicView addSubview:picBtn];
        picBtn.frame = CGRectMake(25*IPHONE6_W_SCALE, 10 * IPHONE6_H_SCALE, 24*IPHONE6_W_SCALE, 20*IPHONE6_W_SCALE);
        [picBtn setImage:[UIImage imageNamed:@"icon_zhaopian"] forState:UIControlStateNormal];
        // 为按钮添加选择发布图片的事件
        [picBtn addTarget:self action:@selector(selectPic) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * upLine = [[UIView alloc] init];
        upLine.backgroundColor = Color238;
        [selectPicView addSubview:upLine];
        
        UIView * bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = Color216;
        //    bottomLine.backgroundColor = [UIColor redColor];
        [selectPicView addSubview:bottomLine];
        
        upLine.frame = CGRectMake(0, 0, WIDTH, 0.5);
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selectPicView.mas_left);
            make.right.equalTo(selectPicView.mas_right);
            make.bottom.equalTo(selectPicView.mas_bottom);
            make.height.equalTo(@0.5);
        }];
        
        [self addSubview:selectPicView];
    }
    
    return self;
}

- (void)selectPic{
    NSLog(@"添加图片...");
    _commplete();
}

@end
