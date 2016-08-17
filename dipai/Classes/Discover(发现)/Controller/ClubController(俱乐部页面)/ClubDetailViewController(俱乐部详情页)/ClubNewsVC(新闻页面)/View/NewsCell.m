//
//  NewsCell.m
//  dipai
//
//  Created by 梁森 on 16/6/17.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NewsCell.h"
#import "NewsModel.h"

#import "Masonry.h"

#import "UIImageView+WebCache.h"
@interface NewsCell()

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


@end

@implementation NewsCell

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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 添加子控件
        [self setUpChildView];
    }
    return self;
}
#pragma mark --- 添加子控件
- (void)setUpChildView{
    /***********资讯**************/
    // 图片
    UIImageView * picView = [[UIImageView alloc] init];
    [self addSubview:picView];
    //    picView.backgroundColor = [UIColor redColor];
    _picView = picView;
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.numberOfLines = 0;
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
}

- (void)setNewsModel:(NewsModel *)newsModel{
    _newsModel = newsModel;
}

- (void)layoutSubviews{
    // 图片
    CGFloat imageX = InfoCellPicLeft * IPHONE6_W_SCALE;
    CGFloat imageY = InfoCellPicTop * IPHONE6_H_SCALE;
    CGFloat imageW = InfoCellPicWidth * IPHONE6_W_SCALE;
    CGFloat imageH = InfoCellPicHeight * IPHONE6_H_SCALE;
    _picView.frame = CGRectMake(imageX, imageY, imageW, imageH);
//    [_picView sd_setImageWithURL:[NSURL URLWithString:_newsModel.picname] placeholderImage:[UIImage imageNamed:@"123"]];
    [_picView sd_setImageWithURL:[NSURL URLWithString:_newsModel.covers[@"cover1"]] placeholderImage:[UIImage imageNamed:@"123"]];
    // 标题
    CGFloat titleX = CGRectGetMaxX(_picView.frame) + Margin30 * IPHONE6_W_SCALE;
    CGFloat titleY = Margin36 * IPHONE6_H_SCALE;
    CGFloat titleW = WIDTH - titleX - 10 * IPHONE6_W_SCALE;
    NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
    titleDic[NSFontAttributeName] = Font16;
    NSString * str = _newsModel.title;
    CGSize titleSize = [str sizeWithAttributes:titleDic];
    CGRect titleRect = [str boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
    _titleLbl.frame = (CGRect){{titleX, titleY}, titleRect.size};
    _titleLbl.text = _newsModel.title;
    // 描述
    CGFloat detailX = titleX;
    CGFloat detailY = CGRectGetMaxY(_titleLbl.frame) + Margin30 * IPHONE6_H_SCALE;
    CGFloat detailW = WIDTH - detailX - Margin20 * IPHONE6_W_SCALE;
    NSMutableDictionary * detailDic = [NSMutableDictionary dictionary];
    detailDic[NSFontAttributeName] = Font13;
    NSString * detail = _newsModel.descriptioN;
    CGRect detailRect = [detail boundingRectWithSize:CGSizeMake(detailW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:detailDic context:nil];
    _detailLbl.frame = (CGRect){{detailX,detailY},detailRect.size};
    _detailLbl.text = detail;
    
    if (titleSize.width + titleX + 10 * IPHONE6_W_SCALE > WIDTH) {
        _detailLbl.hidden = YES;
    }else{
        _detailLbl.hidden = NO;
    }
    
    // 评论数
    NSString * commentNum = [NSString stringWithFormat:@"%@评论", _newsModel.commentNumber];
    _commentsLbl.text = commentNum;
    if (_newsModel.commentNumber == nil) {
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
