//
//  InformationCell.m
//  dipai
//
//  Created by 梁森 on 16/4/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "InformationCell.h"
// 第三方
#import "Masonry.h"
#import "UIImageView+WebCache.h"
// 列表模型
#import "NewsListModel.h"
// 视频详情页中的视频模型
#import "AssociatedModel.h"

// 图集单元格
#import "PicturesCell.h"
// 视频单元格
#import "VideoCell.h"



@interface InformationCell()

/***********资讯**************/
/**
 *  图片
 */
@property (nonatomic, strong) UIImageView * picView;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel * titleLbl;
/**
 *  描述
 */
@property (nonatomic, strong) UILabel * detailLbl;
/**
 *   评论数
 */
@property (nonatomic, strong) UILabel * commentsLbl;
/**
 *  分割线
 */
@property (nonatomic, strong) UIView * line;

/***********图集**************/
@property (nonatomic, strong) PicturesCell * picsCell;

/***********视频**************/
/**
 *  视频标志
 */
@property (nonatomic, strong) UIImageView * videoPic;
/**
 *  分类标签
 */
@property (nonatomic, strong) UIImageView * markView;

@end
@implementation InformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor yellowColor];
        // 添加子控件
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView
{
    /***********资讯**************/
    // 图片
    UIImageView * picView = [[UIImageView alloc] init];
    [self addSubview:picView];
//    picView.backgroundColor = [UIColor redColor];
    _picView = picView;
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
//    titleLbl.backgroundColor = [UIColor greenColor];
    titleLbl.font = Font16;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    // 详情
    UILabel * detailLbl = [[UILabel alloc] init];
//    detailLbl.backgroundColor = [UIColor greenColor];
    detailLbl.numberOfLines = 0;
    detailLbl.font = Font13;
    detailLbl.textColor = Color123;
    [self addSubview:detailLbl];
    _detailLbl = detailLbl;
    // 评论数
    UILabel * commentsLbl = [[UILabel alloc] init];
    commentsLbl.textColor = Color178;
    commentsLbl.font = Font10;
//    commentsLbl.backgroundColor = [UIColor greenColor];
    [self addSubview:commentsLbl];
    _commentsLbl = commentsLbl;
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
//    line.backgroundColor = [UIColor redColor];
    [self addSubview:line];
    _line = line;
    /***********图集**************/
    
    
    /***********视频**************/
    // 视频标志
    UIImageView * videoPic = [[UIImageView alloc] init];
    videoPic.image = [UIImage imageNamed:@"bofang"];
    [_picView addSubview:videoPic];
    _videoPic = videoPic;
    
    // 分类标签
    UIImageView * markView = [[UIImageView alloc] init];
    markView.image = [UIImage imageNamed:@"shipin"];
    [self addSubview:markView];
    _markView = markView;
}

// 重写set方法，在传递模型的时候调用此方法，
- (void)setNewslistModel:(NewsListModel *)newslistModel
{
    _newslistModel = newslistModel;
    // 资讯单元格上子控件的数据
    
    if ([newslistModel.type isEqualToString:@"2"]) {
        [self setInfoData];
        [self setInfoFrame];
    } else
    {
        [self setVideoData];
        [self setVideoFrame];
    }
    
//    NSLog(@"单元格的高度%f", self.frame.size.height);
    
}

// 相关视频
- (void)setAssociateModel:(AssociatedModel *)associateModel{
    
    // 如果video模型和news list模型数据一致会更简单
    [self setAssociateData];
    [self setAssociateFrame];
}
#pragma mark --- 设置视频单元格内容
- (void)setAssociateData{
    _titleLbl.text = _associateModel.title;
    _detailLbl.text = _associateModel.descriptioN;
    
    NSString * urlStr = _associateModel.covers;
    _commentsLbl.text = [NSString stringWithFormat:@"%@评论", _newslistModel.commentNumber];
    [_picView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"123"]];
}
#pragma mark --- 设置视频单元格大小
- (void)setAssociateFrame{
    // 图片
    CGFloat imageX = Margin30 * IPHONE6_W_SCALE;
    CGFloat imageY = 28/2 * IPHONE6_H_SCALE;
    CGFloat imageW = InfoCellPicWidth * IPHONE6_W_SCALE;
    CGFloat imageH = InfoCellPicHeight * IPHONE6_H_SCALE;
    _picView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    // 标题
    CGFloat titleX = CGRectGetMaxX(_picView.frame) + Margin30 * IPHONE6_W_SCALE;
    CGFloat titleY = Margin36 * IPHONE6_H_SCALE;
    NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
    titleDic[NSFontAttributeName] = Font16;
    NSString * str = _newslistModel.title;
    CGSize titleSize = [str sizeWithAttributes:titleDic];
    _titleLbl.frame = (CGRect){{titleX, titleY}, titleSize};
    // 描述
    CGFloat detailX = titleX;
    CGFloat detailY = CGRectGetMaxY(_titleLbl.frame) + Margin30 * IPHONE6_H_SCALE;
    CGFloat detailW = WIDTH - detailX - Margin20 * IPHONE6_W_SCALE;
    NSMutableDictionary * detailDic = [NSMutableDictionary dictionary];
    detailDic[NSFontAttributeName] = Font13;
    NSString * detail = _newslistModel.descriptioN;
    CGRect detailRect = [detail boundingRectWithSize:CGSizeMake(detailW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:detailDic context:nil];
    _detailLbl.frame = (CGRect){{detailX,detailY},detailRect.size};
    _detailLbl.text = detail;
    // 评论数
    NSString * commentNum = [NSString stringWithFormat:@"%@评论", _newslistModel.commentNumber];
    _commentsLbl.text = commentNum;
    if (_newslistModel.commentNumber == nil) {
        _commentsLbl.text = @"0评论";
    }
    [_commentsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-Margin30 * IPHONE6_W_SCALE);
        make.bottom.equalTo(self.mas_bottom).offset(-Margin33 * IPHONE6_H_SCALE);
        make.height.equalTo(@(Margin20));
        make.width.equalTo(_commentsLbl.mas_width);
    }];
    // 分隔线
    _line.backgroundColor = Color238;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
    
    [_videoPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_picView.mas_left).offset(Margin16 * IPHONE6_W_SCALE);
        make.bottom.equalTo(_picView.mas_bottom).offset(-Margin14 * IPHONE6_H_SCALE);
        make.width.equalTo(@(Margin36 * IPHONE6_W_SCALE));
        make.height.equalTo(@(Margin36 * IPHONE6_W_SCALE));
    }];
    // 视频分类标签
    [_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-Margin28 * IPHONE6_H_SCALE);
        make.right.equalTo(_commentsLbl.mas_left).offset(-Margin19 * IPHONE6_W_SCALE);
        make.width.equalTo(@(Margin58 * IPHONE6_W_SCALE));
        make.height.equalTo(@(Margin28 * IPHONE6_H_SCALE));
    }];
}

- (void)setInfoData
{
    [self setData];
}

#pragma mark ----- 设置子控件的位置  应该在传递模型的时候调用此方法
- (void)setInfoFrame
{
    [self setFrame];
}

- (void)setVideoData
{
    [self setData];
    
}
- (void)setVideoFrame
{
    [self setFrame];
    // 视频标志图片
    [_videoPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_picView.mas_left).offset(Margin16 * IPHONE6_W_SCALE);
        make.bottom.equalTo(_picView.mas_bottom).offset(-Margin14 * IPHONE6_H_SCALE);
        make.width.equalTo(@(Margin36 * IPHONE6_W_SCALE));
        make.height.equalTo(@(Margin36 * IPHONE6_W_SCALE));
    }];
    // 视频分类标签
    [_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-Margin28 * IPHONE6_H_SCALE);
        make.right.equalTo(_commentsLbl.mas_left).offset(-Margin19 * IPHONE6_W_SCALE);
        make.width.equalTo(@(Margin58 * IPHONE6_W_SCALE));
        make.height.equalTo(@(Margin28 * IPHONE6_H_SCALE));
    }];
}

#pragma mark -------- 设置公共部分（数据和Frame）
- (void)setData
{
    _titleLbl.text = _newslistModel.title;
    _detailLbl.text = _newslistModel.descriptioN;
        
    NSString * urlStr = [_newslistModel.covers objectForKey:@"cover1"];
    _commentsLbl.text = [NSString stringWithFormat:@"%@评论", _newslistModel.commentNumber];
    if (_newslistModel.commentNumber == nil) {
        _commentsLbl.text = @"0评论";
    }
    [_picView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"123"]];
}

- (void)setFrame
{
    // 图片
    CGFloat imageX = InfoCellPicLeft * IPHONE6_W_SCALE;
    CGFloat imageY = InfoCellPicTop * IPHONE6_H_SCALE;
    CGFloat imageW = InfoCellPicWidth * IPHONE6_W_SCALE;
    CGFloat imageH = InfoCellPicHeight * IPHONE6_H_SCALE;
    _picView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    // 标题
    CGFloat titleX = CGRectGetMaxX(_picView.frame) + Margin30 * IPHONE6_W_SCALE;
    CGFloat titleY = Margin36 * IPHONE6_H_SCALE;
    CGFloat titleW = WIDTH - titleX - Margin20 * IPHONE6_W_SCALE;
    NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
    titleDic[NSFontAttributeName] = Font16;
    NSString * str = _newslistModel.title;
    CGRect titleRect = [str boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
    _titleLbl.numberOfLines = 0;
    _titleLbl.frame = (CGRect){{titleX, titleY}, titleRect.size};
    // 描述
    CGFloat detailX = titleX;
    CGFloat detailY = CGRectGetMaxY(_titleLbl.frame) + Margin30 * IPHONE6_H_SCALE;
    CGFloat detailW = WIDTH - detailX - Margin20 * IPHONE6_W_SCALE;
    NSMutableDictionary * detailDic = [NSMutableDictionary dictionary];
    detailDic[NSFontAttributeName] = Font13;
    NSString * detail = _newslistModel.descriptioN;
    CGRect detailRect = [detail boundingRectWithSize:CGSizeMake(detailW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:detailDic context:nil];
    _detailLbl.frame = (CGRect){{detailX,detailY},detailRect.size};
    _detailLbl.text = detail;
    
    if (_newslistModel.title.length > 15) {
        _detailLbl.hidden = YES;
    }else{
        _detailLbl.hidden = NO;
    }
    
    // 评论数
    NSString * commentNum = [NSString stringWithFormat:@"%@评论", _newslistModel.commentNumber];
    _commentsLbl.text = commentNum;
    if (_newslistModel.commentNumber == nil) {
        _commentsLbl.text = @"0评论";
    }
    [_commentsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-Margin20 * IPHONE6_W_SCALE);
        make.bottom.equalTo(self.mas_bottom).offset(-Margin33 * IPHONE6_H_SCALE);
        make.height.equalTo(@(Margin20));
        make.width.equalTo(_commentsLbl.mas_width);
    }];
    // 分隔线
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
}

//- (void)setTitlelLblTextColor
//{
//    _titleLbl.textColor = Color178;
//}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"cellID";
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
