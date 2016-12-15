//
//  NumberDetailModel.m
//  dipai
//
//  Created by 梁森 on 16/10/28.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NumberDetailModel.h"

@implementation NumberDetailModel

// 重写cellHeight的get方法
- (CGFloat)cellHeight{
    
    if (_cellHeight == 0.f) {
        CGFloat cellHeight = 0;
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = Font12;
        CGRect detailRect = [self.content boundingRectWithSize:CGSizeMake(WIDTH - 90 * IPHONE6_W_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        CGFloat detailH = detailRect.size.height;
        cellHeight = 55 * IPHONE6_H_SCALE + 0.5 + 47 * 0.5 * IPHONE6_H_SCALE + detailH + 7 * IPHONE6_H_SCALE;
        _cellHeight = cellHeight;
    }
    return _cellHeight;
}
@end
