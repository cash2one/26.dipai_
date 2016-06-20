//
//  HeaderView.m
//  dipai
//
//  Created by 梁森 on 16/6/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView()

@end

@implementation HeaderView

- (instancetype)initWithDescription:(NSString *)description andSummary:(NSString *)summary{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 设置子控件
        [self setUpChildControl];
        
        // 设置frame
//        [self setUpFrame];
    }
    
    return self;
}

#pragma mark --- 设置子控件
- (void)setUpChildControl{
    // 描述
    UILabel * descriptionLbl = [[UILabel alloc] init];
    descriptionLbl.backgroundColor = [UIColor redColor];
    descriptionLbl.font = Font16;
    descriptionLbl.numberOfLines = 0;
    [self addSubview:descriptionLbl];
    _descriptionLbl = descriptionLbl;
    
    // 详细描述
    UILabel * summaryLbl = [[UILabel alloc] init];
    summaryLbl.backgroundColor = [UIColor blueColor];
    summaryLbl.font = Font12;
    summaryLbl.textColor = Color123;
    [self addSubview:summaryLbl];
    _summaryLbl = summaryLbl;
    // 展开图片
    UIImageView * openImage = [[UIImageView alloc] init];
    openImage.image = [UIImage imageNamed:@"zhankai"];
    [self addSubview:openImage];
    _openImage = openImage;
    // 展开按钮
    UIButton * openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:openBtn];
    _openBtn = openBtn;
    
}
#pragma 设置frame
- (void)setUpFrame{
    //描述
    CGFloat descriptionX = 30 / 2;
    CGFloat descriptionY = Margin26 * IPHONE6_H_SCALE;
//    CGFloat descriptionW = WIDTH - descriptionX - 120 / 2 * IPHONE6_W_SCALE + Margin15 * IPHONE6_W_SCALE;
    CGFloat descriptionW = WIDTH - 2 * descriptionX;
    NSMutableDictionary * descriptionDic = [NSMutableDictionary dictionary];
    descriptionDic[NSFontAttributeName] = Font16;
    CGRect descriptionRect = [_descriptionLbl.text boundingRectWithSize:CGSizeMake(descriptionW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:descriptionDic context:nil];
    _descriptionLbl.frame = (CGRect){{descriptionX, descriptionY}, descriptionRect.size};
    
    // 详细描述
    if (_summaryLbl.text.length > 54) {
        _summary = [_summaryLbl.text substringToIndex:54];
        
    } else{
        _summary = _summaryLbl.text;
    }
    _summaryLbl.numberOfLines = 0;
    CGFloat summaryX = descriptionX;
    CGFloat summaryY = CGRectGetMaxY(_descriptionLbl.frame) + Margin24 * IPHONE6_H_SCALE;
    CGFloat summaryW = WIDTH - 2 * descriptionX + Margin15 * IPHONE6_W_SCALE;
    NSMutableDictionary * summaryDic = [NSMutableDictionary dictionary];
    summaryDic[NSFontAttributeName] = Font12;
    CGRect summaryRect = [_summary boundingRectWithSize:CGSizeMake(summaryW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:summaryDic context:nil];
    _summaryLbl.frame = (CGRect){{summaryX, summaryY}, summaryRect.size};
    
    // 展开图片
    
    // 展开按钮
    
    _height = CGRectGetMaxY(_summaryLbl.frame) + 38 / 2 * IPHONE6_H_SCALE;
}

- (CGFloat)height{
    NSLog(@"高度：－－－%f", _height);
    return _height;
}

- (void)setDes:(NSString *)des andSummary:(NSString *)summary{
    _descriptionLbl.text = des;
    _summaryLbl.text = summary;
    [self setUpFrame];
}

@end
