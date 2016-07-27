//
//  MoreVideosCell.m
//  dipai
//
//  Created by 梁森 on 16/6/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MoreVideosCell.h"
#import "HotVideoModel.h"

#import "UIImageView+WebCache.h"


@interface MoreVideosCell()
/**
 *  视频图片封面
 */
@property (nonatomic, strong) UIImageView * picView;
/**
 *  视频标题
 */
@property (nonatomic, strong) UILabel * titleLbl;

@end

@implementation MoreVideosCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    // 图片
    UIImageView * picView = [[UIImageView alloc] init];
    [self addSubview:picView];
    _picView = picView;
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
//    titleLbl.backgroundColor = [UIColor redColor];
    titleLbl.numberOfLines = 0;
    titleLbl.font = Font13;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
}

- (void)cellForViedoInfoShowCollectionCell:(HotVideoModel *)model{
    
    if (model) {
        [_picView sd_setImageWithURL:[NSURL URLWithString:model.picname] placeholderImage:[UIImage imageNamed:@"123"]];
        _titleLbl.text = model.title;
//        _titleLbl.text = @"这只是测试信息，这是某一个视频专辑";
    } else{
        NSLog(@"...");
    }
}

- (void)setHotVideoModel:(HotVideoModel *)hotVideoModel{
    _hotVideoModel = hotVideoModel;
    [self layoutSubviews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 图片
    CGFloat picX = 0;
    CGFloat picY = 0;
    CGFloat picW = 334 / 2 * IPHONE6_W_SCALE;
    CGFloat picH = 190 / 2 * IPHONE6_H_SCALE;
    _picView.frame = CGRectMake(picX, picY, picW, picH);
    
    [_picView sd_setImageWithURL:[NSURL URLWithString:_hotVideoModel.picname] placeholderImage:[UIImage imageNamed:@"123"]];
    
    // 标题
    CGFloat titleX = picX;
    CGFloat titleY = CGRectGetMaxY(_picView.frame) + 18/2 * IPHONE6_H_SCALE;
    CGFloat titleW = picW;
    CGFloat titleH = 26;
    _titleLbl.frame = CGRectMake(titleX, titleY, titleW, titleH);
    _titleLbl.text = _hotVideoModel.title;
//    [_titleLbl sizeToFit];
}
@end
