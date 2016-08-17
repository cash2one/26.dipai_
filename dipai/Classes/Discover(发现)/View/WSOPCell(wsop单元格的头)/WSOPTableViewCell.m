//
//  WSOPTableViewCell.m
//  dipai
//
//  Created by 梁森 on 16/6/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "WSOPTableViewCell.h"
#import "WSOPModel.h"

#import "HotVideoModel.h"
#import "UIImageView+WebCache.h"
@interface WSOPTableViewCell()
/**
 *  封面图
 */
@property (nonatomic, strong) UIImageView * picView;
/**
 *  描述
 */
@property (nonatomic, strong) UILabel * desLbl;
// 装图片的数组
@property (nonatomic, strong) NSMutableArray * imageArr;
// 装标题的数组
@property (nonatomic, strong) NSMutableArray * titleArr;

@end

@implementation WSOPTableViewCell
- (NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (NSMutableArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"tournamentCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        //        NSLog(@"...");
    }
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 设置子控件
        [self setUpChildControl];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark --- 设置子控件
- (void)setUpChildControl{
    
    // redView
    UIView * redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self addSubview:redView];
    _redView = redView;
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.font = Font16;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    // 图片
    UIImageView * picView = [[UIImageView alloc] init];
    [self addSubview:picView];
    _picView = picView;
    
    // 描述
    UILabel * desLbl = [[UILabel alloc] init];
    //    titleLbl.backgroundColor = [UIColor redColor];
    desLbl.numberOfLines = 0;
    desLbl.font = Font13;
    [self addSubview:desLbl];
    _desLbl = desLbl;
}
// 重写wsopModel属性
- (void)setWsopModel:(WSOPModel *)wsopModel{
    _wsopModel = wsopModel;
    
    // 没有下面的代码会出现多张图片和多个标题的情况
    if (self.imageArr && self.imageArr.count > 0) {
        for (UIImageView * imageV in self.imageArr) {
            [imageV removeFromSuperview];
        }
    }
    if (self.titleArr && self.titleArr.count > 0) {
        for (UILabel * titleLbl in self.titleArr) {
            [titleLbl removeFromSuperview];
        }
    }
    
    [self setFrame];
//    NSLog(@"%@", _wsopModel);
}

- (void)setFrame{
    
    // redView
    CGFloat redViewX = Margin20 * IPHONE6_W_SCALE;
    CGFloat redViewY = 28 * 0.5 * IPHONE6_H_SCALE;
    CGFloat redViewW = 8 * 0.5 * IPHONE6_W_SCALE;
    CGFloat redViewH = Margin32 * IPHONE6_H_SCALE;
    _redView.frame = CGRectMake(redViewX, redViewY, redViewW, redViewH);
    
    // 标题
    CGFloat titleX = CGRectGetMaxX(_redView.frame) + 18 * 0.5 * IPHONE6_W_SCALE;
    CGFloat titleY = 26 * 0.5 * IPHONE6_H_SCALE;
    CGFloat titleW = 100;
    CGFloat titleH = 16 * IPHONE6_H_SCALE;
    _titleLbl.frame = CGRectMake(titleX, titleY, titleW, titleH);
    _titleLbl.text = _wsopModel.label;
    [_titleLbl sizeToFit];
    
    for (int i = 0 ; i < _wsopModel.data.count; i ++) {
        UIImageView * imageBtn = [[UIImageView alloc] init];
        //        imageBtn.backgroundColor = [UIColor redColor];
        imageBtn.tag = i;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        imageBtn.userInteractionEnabled = YES;
        [imageBtn addGestureRecognizer:tap];
        [self addSubview:imageBtn];
        [self.imageArr addObject:imageBtn];
        
        CGFloat btnX = Margin20 * IPHONE6_W_SCALE;
        CGFloat btnY = CGRectGetMaxY(_redView.frame) + Margin24 * IPHONE6_H_SCALE;
        CGFloat btnW = 346 / 2 * IPHONE6_W_SCALE;
        CGFloat btnH = 196 / 2 * IPHONE6_W_SCALE;
        //        imageBtn.backgroundColor = [UIColor redColor];
        int j = i % 2;
        int k = i / 2;
        imageBtn.frame = CGRectMake(btnX + j *(btnW + 18 / 2 * IPHONE6_W_SCALE), btnY + k * (btnH + 95/2 * IPHONE6_H_SCALE), btnW, btnH);
        
        HotVideoModel * model = _wsopModel.data[i];
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:model.picname] placeholderImage:[UIImage imageNamed:@"123"]];
        
        // 四个图片的标题
        UILabel * titleLbl = [[UILabel alloc] init];
//        titleLbl.backgroundColor = [UIColor redColor];
        titleLbl.numberOfLines = 0;
        titleLbl.font = Font13;
        CGFloat titleX = btnX + j *(btnW + 18 / 2 * IPHONE6_W_SCALE);
        CGFloat titleY = CGRectGetMaxY(imageBtn.frame) + Margin14 * IPHONE6_H_SCALE;
        titleLbl.frame = CGRectMake(titleX, titleY, btnW, 30);
        titleLbl.text = model.title;
        [titleLbl sizeToFit];
        [self addSubview:titleLbl];
        [self.titleArr addObject:titleLbl];
    }
}
#pragma mark ---- 为图片添加的点击事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIImageView * imageBtn = (UIImageView *)tap.view;
//    NSLog(@"tag---%lu", imageBtn.tag);
    
    HotVideoModel * model = _wsopModel.data[imageBtn.tag];
    
    if ([self.delegate respondsToSelector:@selector(turnPageToVideoDetailWith:)]) {
        [self.delegate turnPageToVideoDetailWith:model.wapurl];
    } else{
        NSLog(@"WSOPTableViewCell的代理没有响应....");
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
