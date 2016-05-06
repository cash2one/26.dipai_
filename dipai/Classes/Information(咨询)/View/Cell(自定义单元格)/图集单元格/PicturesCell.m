//
//  PicturesCell.m
//  dipai
//
//  Created by 梁森 on 16/4/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "PicturesCell.h"
// 第三方
#import "Masonry.h"
#import "UIImageView+WebCache.h"


#import "NewsListModel.h"
@interface PicturesCell()
// 标题
@property (nonatomic, strong) UILabel * title;
// 图集
@property (nonatomic, strong) UIView * picsView;
// 分类图片
@property (nonatomic, strong) UIImageView * markView;
// 评论
@property (nonatomic, strong) UILabel * commentLbl;
/**
 *  分割线
 */
@property (nonatomic, strong) UIView * line;

@property (nonatomic, strong) NSMutableArray * imageArr;

@end

@implementation PicturesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpChildView];
    }
    
    return self;
}

#pragma mark ------ 设置子控件
- (void)setUpChildView
{
    // 标题
    UILabel * title = [[UILabel alloc] init];
//    title.backgroundColor = [UIColor greenColor];
    title.font = Font16;
    [self addSubview:title];
    _title = title;
    
    // 图集
    UIView * picsView = [[UIView alloc] init];
//    picsView.backgroundColor = [UIColor redColor];
    [self addSubview:picsView];
    _picsView = picsView;
    _imageArr = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        [_imageArr addObject:imageView];
//        imageView.tag = ImageViewTag + i;
        CGFloat imageViewX = 0;
        CGFloat imageViewY = 0;
        CGFloat imageViewW = Margin224 * IPHONE6_W_SCALE;
        CGFloat imageViewH = Margin168 * IPHONE6_H_SCALE;
        imageView.frame = CGRectMake((imageViewX + imageViewW + Margin19 * IPHONE6_W_SCALE) * i , imageViewY, imageViewW, imageViewH);
        [_picsView addSubview:imageView];
    }
    // 分类图片
    UIImageView * markView = [[UIImageView alloc] init];
    [self addSubview:markView];
    _markView = markView;
    // 评论
    UILabel * commentsLbl = [[UILabel alloc] init];
    commentsLbl.font = Font10;
    commentsLbl.textColor = Color178;
    [self addSubview:commentsLbl];
    _commentLbl = commentsLbl;
    
    // 分隔线
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
//    line.backgroundColor = [UIColor redColor];
    [self addSubview:line];
    _line = line;
}
// 重写set方法，接收传递过来的模型
- (void)setNewslistModel:(NewsListModel *)newslistModel
{
//    NSLog(@"%s", __func__);
    _newslistModel = newslistModel;
    
    // 设置子控件的数据
    [self setCellData];
    // 设置子控件位置和大小
    [self setCellFrame];
}
#pragma mark ------设置子控件位置和大小
- (void)setCellFrame
{
//    NSLog(@"%s", __func__);
    // 标题
    CGFloat titleX = Margin20 * IPHONE6_W_SCALE;
    CGFloat titleY = Margin28 * IPHONE6_H_SCALE;
    NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
    titleDic[NSFontAttributeName] = Font16;
    NSString * str = _newslistModel.title;
    CGSize titleSize = [str sizeWithAttributes:titleDic];
    _title.frame = (CGRect){{titleX, titleY}, titleSize};
    // 图集
    CGFloat picsX = titleX;
    CGFloat picsY = CGRectGetMaxY(_title.frame) + Margin24 * IPHONE6_H_SCALE;
    CGFloat picsW = WIDTH - 2 * titleX;
    CGFloat picsH = Margin168 * IPHONE6_W_SCALE;
    _picsView.frame = CGRectMake(picsX, picsY, picsW, picsH);
    // 分类图片
    CGFloat markX = titleX;
    CGFloat markY = CGRectGetMaxY(_picsView.frame) + Margin14 * IPHONE6_H_SCALE;
    CGFloat markW = Margin58 * IPHONE6_W_SCALE;
    CGFloat markH = Margin28 * IPHONE6_H_SCALE;
    _markView.frame = CGRectMake(markX, markY, markW, markH);
    // 评论
    [_commentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_picsView.mas_bottom).offset(Margin20 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-Margin20 * IPHONE6_W_SCALE);
        make.height.equalTo(@(Margin20));
        make.width.equalTo(_commentLbl.mas_width);
    }];
    
    // 分隔线
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
}
#pragma mark -----设置子控件的数据
- (void)setCellData
{
//    NSLog(@"%s", __func__);
    // 标题
    _title.text = _newslistModel.title;
    
    // 图集
//    NSLog(@"图片数组：%@", _newslistModel.picname);
    for (int i = 0; i < _imageArr.count; i ++) {
        UIImageView * imageView = _imageArr[i];
        NSString * urlStr = _newslistModel.picname[0];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"123"]];
    }
    // 评论
    _commentLbl.text = [NSString stringWithFormat:@"%d评论", _newslistModel.comment];
    // 分类  此处需要进行判断
    _markView.image = [UIImage imageNamed:@"tuji"];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"picsCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        //        NSLog(@"...");
    }
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
