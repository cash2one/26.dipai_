//
//  TableFooterView.m
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "TableFooterView.h"
// 标签模型
#import "labelModel.h"

@interface TableFooterView()
/**
 *  标识图片
 */
@property (nonatomic, strong)UIImageView * picView;
/**
 *  装标签的数组
 */
@property (nonatomic, strong) NSMutableArray * lblArr;

@end
@implementation TableFooterView

- (NSMutableArray *)lblArr{
    if (_lblArr == nil) {
        _lblArr = [NSMutableArray array];
    }
    return _lblArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // 设置子控件
        [self setUpChildControl];
    }
    return self;
}
#pragma mark ---- 设置子控件
- (void)setUpChildControl{
    
    // 标识图片
    UIImageView * picView = [[UIImageView alloc] init];
    picView.image = [UIImage imageNamed:@"tuijianbiaoqian"];
    [self addSubview:picView];
    _picView = picView;
    
    // 标签
    for (int i = 0; i < 9; i ++) {
        UILabel * lbl = [[UILabel alloc] init];
        lbl.layer.borderColor = [[UIColor colorWithRed:201 / 255.f green:201 / 255.f blue:201 / 255.f alpha:1] CGColor];
        lbl.layer.borderWidth = 0.5;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = Color102;
        lbl.font = Font13;
        lbl.text = @"测试文字";
        [self addSubview:lbl];
        [self.lblArr addObject:lbl];
    }
}

- (void)setTagArr:(NSArray *)tagArr{
    
    _tagArr = tagArr;
    if (_tagArr.count > 0) {
        
        NSLog(@"标签的个数:--%lu", _tagArr.count);
        
        [self setFrame];
    } else{
        NSLog(@"暂时没有数据...");
    }
}
- (void)setFrame{
    // 标签  <3:标签的个数
    for (int i = 0; i < _tagArr.count; i ++) {
        UILabel * lbl = self.lblArr[i];
        CGFloat lblX = CGRectGetMaxX(_picView.frame) + Margin24 * IPHONE6_W_SCALE;
        CGFloat lblY = 34 * 0.5 * IPHONE6_H_SCALE;
        CGFloat lblW = 174 * 0.5 * IPHONE6_W_SCALE;
        CGFloat lblH = 54 * 0.5 * IPHONE6_H_SCALE;
        
        int j = i / 3;
        int k = i % 3;
        
        lbl.frame = CGRectMake(lblX + (28 * 0.5 * IPHONE6_W_SCALE + lblW) * k, lblY + (28 * 0.5 * IPHONE6_H_SCALE + lblH)*j, lblW, lblH);
        labelModel * model = _tagArr[i];
        lbl.text = model.name;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 标识图片
    CGFloat picX = Margin30 * IPHONE6_H_SCALE;
    CGFloat picY = Margin34 * IPHONE6_H_SCALE;
    CGFloat picW = 48 * 0.5 * IPHONE6_W_SCALE;
    CGFloat picH = picW;
    _picView.frame = CGRectMake(picX, picY, picW, picH);
    
    
}

@end
