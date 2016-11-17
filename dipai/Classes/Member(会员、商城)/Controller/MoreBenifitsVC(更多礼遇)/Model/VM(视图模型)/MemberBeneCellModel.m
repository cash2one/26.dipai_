//
//  MemberBeneCellModel.m
//  dipai
//
//  Created by 梁森 on 16/10/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MemberBeneCellModel.h"

@implementation MemberBeneCellModel

- (void)setBenefitsArr:(NSArray *)benefitsArr{
    
    _benefitsArr = benefitsArr;
    
    [self setUpCellHeight];
}

- (void)setUpCellHeight{
    
    NSInteger j;
    if (_benefitsArr.count % 3 == 0) {
        j = _benefitsArr.count / 3;
    }else{
        j = (_benefitsArr.count / 3 )+ 1;
    }
    _cellHeight =j * 112 * IPHONE6_H_SCALE;
}

@end
