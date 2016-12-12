//
//  FooterViewInShop.m
//  dipai
//
//  Created by 梁森 on 16/12/12.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "FooterViewInShop.h"

@implementation FooterViewInShop

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame: frame]) {
        
        [self setUpChildControl];
    }
    return self;
}

- (void)setUpChildControl{
    
    self.backgroundColor = RGBA(240, 239, 245, 1);
    //    tableFooterV.backgroundColor = [UIColor redColor];
    UILabel * messageLbl = [[UILabel alloc] initWithFrame:self.bounds];
    messageLbl.textAlignment = NSTextAlignmentCenter;
    messageLbl.font = Font12;
    messageLbl.textColor = RGBA(138, 138, 138, 1);
    messageLbl.text = @"活动由底牌提供，与设备生产Apple Inc.公司无关";
    [self addSubview:messageLbl];
}

@end
