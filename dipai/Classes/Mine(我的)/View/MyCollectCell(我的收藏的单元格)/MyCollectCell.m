//
//  MyCollectCell.m
//  dipai
//
//  Created by 梁森 on 16/7/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyCollectCell.h"
#import "MyCollectionModel.h"

#import "LSPhotoView.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface MyCollectCell()
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
/**
 *  图集得标题
 */
@property (nonatomic, strong) UILabel * picTitle;
/**
 *  装图片的视图
 */
@property (nonatomic, strong) UIView * picsView;
/**
 *  图集的标识
 */
@property (nonatomic, strong) UIImageView * picMark;
/**
 *  显示图片的个数
 */
@property (nonatomic, strong) UILabel * num;

/***********视频**************/
/**
 *  视频标志
 */
@property (nonatomic, strong) UIImageView * videoPic;
/**
 *  分类标签
 */
@property (nonatomic, strong) UIImageView * markView;

/***********帖子**************/
/**
 *  头像
 */
@property (nonatomic, strong) UIImageView *iconView;
/**
 *  昵称
 */
@property (nonatomic, strong) UILabel *nameView;
/**
 *  时间
 */
@property (nonatomic, strong) UILabel *timeView;
/**
 *  评论数
 */
@property (nonatomic, strong) UILabel * commentsView;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel * titleView;
/**
 *  正文
 */
@property (nonatomic, strong) UILabel *textView;
/**
 *  帖子的图片视图
 */
@property (nonatomic, strong) LSPhotoView * photoView;
@end

@implementation MyCollectCell

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
        //        self.backgroundColor = [UIColor yellowColor];
        // 添加子控件
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView{
    
    /******************资讯*****************/
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
    
    /******************视频*****************/
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
    
    /******************图集*****************/
    // 图集标题
    UILabel * picTitle = [[UILabel alloc] init];
    [self addSubview:picTitle];
    _picTitle = picTitle;
    // 图集装图片的视图
    UIView * picsView = [[UIView alloc] init];
    [self addSubview:picsView];
    _picsView = picsView;
    for (int i = 0; i < 3; i ++) {
        UIImageView * pic = [[UIImageView alloc] init];
        [picsView addSubview:pic];
        CGFloat imageViewX = 0;
        CGFloat imageViewY = 0;
        CGFloat imageViewW = Margin224 * IPHONE6_W_SCALE;
        CGFloat imageViewH = Margin168 * IPHONE6_H_SCALE;
        pic.frame = CGRectMake((imageViewX + imageViewW + Margin19 * IPHONE6_W_SCALE) * i , imageViewY, imageViewW, imageViewH);
        if (i == 2) {
            // 显示图片的个数
            UILabel * num = [[UILabel alloc] init];
            [pic addSubview:num];
            num.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.8];
            num.font = Font11;
            num.textAlignment = NSTextAlignmentCenter;
            num.textColor = Color255;
            [num mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(pic.mas_right);
                make.bottom.equalTo(pic.mas_bottom);
                make.width.equalTo(@(Margin70 * IPHONE6_W_SCALE));
                make.height.equalTo(@(Margin32 * IPHONE6_H_SCALE));
            }];
            _num = num;
        }
    }
    // 图集的标识
    UIImageView * picMark = [[UIImageView alloc] init];
    picMark.image = [UIImage imageNamed:@"tuji"];
    [self addSubview:picMark];
    _picMark = picMark;
    
    
    /******************帖子*****************/
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.cornerRadius = 19 * IPHONE6_W_SCALE;
    iconView.layer.masksToBounds = YES;
    [self addSubview:iconView];
    _iconView = iconView;
    
    iconView.userInteractionEnabled = YES;
    // 显示个人主页
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStarVC:)];
    [iconView addGestureRecognizer:tap];
    
    // 昵称
    UILabel *nameView = [[UILabel alloc] init];
    nameView.font = Font15;
    nameView.textColor = [UIColor redColor];
    //    nameView.backgroundColor = [UIColor redColor];
    [self addSubview:nameView];
    _nameView = nameView;
    
    // 时间
    UILabel *timeView = [[UILabel alloc] init];
    timeView.font = Font11;
    timeView.textColor = Color153;
    [self addSubview:timeView];
    _timeView = timeView;
    
    // 评论数
    UILabel * commentsView = [[UILabel alloc] init];
    commentsView.textAlignment = NSTextAlignmentRight;
    commentsView.font = Font15;
    commentsView.textColor = Color178;
    [self addSubview:commentsView];
    _commentsView = commentsView;
    
    // 标题
    UILabel * titleView = [[UILabel alloc] init];
    titleView.font = Font16;
    [self addSubview:titleView];
    _titleView = titleView;
    
    // 简介
    UILabel *textView = [[UILabel alloc] init];
    textView.font = Font13;
    textView.textColor = Color123;
    [self addSubview:textView];
    _textView = textView;
    
    // 图片
    LSPhotoView * photoView = [[LSPhotoView alloc] init];
//        picView.backgroundColor = [UIColor redColor];
    [self addSubview:photoView];
    _photoView = photoView;
    
    
}
- (void)showStarVC:(UIGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickFaceWith:)]) {
        
        [self.delegate tableViewCell:self didClickFaceWith:_collectionModel];
    }else{
        NSLog(@"MyCollectCell的代理没有响应...");
    }
    
}
- (void)setCollectionModel:(MyCollectionModel *)collectionModel{
    
    _collectionModel = collectionModel;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if ([_collectionModel.type isEqualToString:@"2"]) { // 资讯
        
        [self setFrame];
        
        [self hidden4];
        [self hidden11];
        [self hidden17];
        [self show2];
      
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = Font16;
        CGSize size = [_collectionModel.title sizeWithAttributes:dic];
        if (size.width + _titleLbl.frame.origin.x + 10 * IPHONE6_W_SCALE > WIDTH) {
            _detailLbl.hidden = YES;
        }else{
            _detailLbl.hidden = NO;
        }
//        if (_collectionModel.title.length > 15) {
//            _detailLbl.hidden = YES;
//        }else{
//            _detailLbl.hidden = NO;
//        }
        
    } else if ([_collectionModel.type isEqualToString:@"11"]){   // 视频
    
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
        
        [self hidden4];
        [self show11];
        [self hidden17];
        [self show2];
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = Font16;
        CGSize size = [_collectionModel.title sizeWithAttributes:dic];
        if (size.width + _titleLbl.frame.origin.x + 10 * IPHONE6_W_SCALE > WIDTH) {
            _detailLbl.hidden = YES;
        }else{
            _detailLbl.hidden = NO;
        }
//        if (_collectionModel.title.length > 15) {
//            _detailLbl.hidden = YES;
//        }else{
//            _detailLbl.hidden = NO;
//        }
        
        } else if ([_collectionModel.type isEqualToString:@"4"]){  // 图集
//        self.backgroundColor = [UIColor yellowColor];
        // 图集标题
        CGFloat titleX = Margin20 * IPHONE6_W_SCALE;
        CGFloat titleY = Margin28 * IPHONE6_H_SCALE;
            CGFloat titleW = WIDTH - titleX;
            CGFloat titleH = 81 * 0.5 * IPHONE6_H_SCALE;
        NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
        titleDic[NSFontAttributeName] = Font16;
        NSString * str = _collectionModel.title;
        _picTitle.frame = CGRectMake(titleX, titleY, titleW, titleH);
        _picTitle.text = str;
        _num.text = [NSString stringWithFormat:@"%lu图", _collectionModel.covers.count];
            
        // 图集
        CGFloat picsX = titleX;
        CGFloat picsY = CGRectGetMaxY(_picTitle.frame);
        CGFloat picsW = WIDTH - 2 * titleX;
        CGFloat picsH = Margin168 * IPHONE6_W_SCALE;
        _picsView.frame = CGRectMake(picsX, picsY, picsW, picsH);
//        _picsView.backgroundColor = [UIColor redColor];
        for (int i = 0; i < 3; i ++) {
            UIImageView * imageView = _picsView.subviews[i];
            NSString * urlStr = [_collectionModel.covers objectForKey:@"cover3"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"123"]];
        }
        // 分类图片
        CGFloat markX = titleX;
        CGFloat markY = CGRectGetMaxY(_picsView.frame) + Margin14 * IPHONE6_H_SCALE;
        CGFloat markW = Margin58 * IPHONE6_W_SCALE;
        CGFloat markH = Margin28 * IPHONE6_W_SCALE;
        _picMark.frame = CGRectMake(markX, markY, markW, markH);
        // 评论
        NSString * commentNum = [NSString stringWithFormat:@"%@评论", _collectionModel.commentNumber];
        _commentsLbl.text = commentNum;
        if (_collectionModel.commentNumber == nil) {
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
            make.height.equalTo(@(5*IPHONE6_H_SCALE));
        }];
            
            [self hidden2];
            [self hidden11];
            [self hidden17];
            [self show4];
        
    }else{  // 帖子
//        self.backgroundColor = [UIColor greenColor];
        
        // 头像
        CGFloat faceX = 10 * IPHONE6_W_SCALE;
        CGFloat faceY = 13 * IPHONE6_H_SCALE;
        CGFloat faceW = 38 * IPHONE6_W_SCALE;
        CGFloat faceH = faceW;
        _iconView.frame = CGRectMake(faceX, faceY, faceW, faceH);
        [_iconView sd_setImageWithURL:[NSURL URLWithString:_collectionModel.face] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
        
        // 姓名
        CGFloat nameX = CGRectGetMaxX(_iconView.frame) + Margin22 * IPHONE6_W_SCALE;
        CGFloat nameY = 18 * IPHONE6_H_SCALE;
        
        NSMutableDictionary * nameDic = [NSMutableDictionary dictionary];
        nameDic[NSFontAttributeName] = Font15;
        CGSize nameSize = [_collectionModel.shorttitle sizeWithAttributes:nameDic];
        _nameView.frame = (CGRect){{nameX, nameY}, nameSize};
        _nameView.text = _collectionModel.shorttitle;
        
        // 帖子标题
        CGFloat titleX = 118 * 0.5 * IPHONE6_W_SCALE;
        CGFloat titleY = CGRectGetMaxY(_iconView.frame);
        CGFloat titleW = WIDTH - titleX - 10 * IPHONE6_W_SCALE;
        
        NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
        titleDic[NSFontAttributeName] = Font16;
        CGRect titleRect = [_collectionModel.title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
        _titleView.frame = (CGRect){{titleX, titleY}, titleRect.size};
        _titleView.text = _collectionModel.title;
//        _titleView.backgroundColor = [UIColor redColor];
        
        // 帖子内容
        CGFloat contentsX = titleX;
        CGFloat contentsY = CGRectGetMaxY(_titleView.frame) + 10 * IPHONE6_H_SCALE;
        CGFloat contentsW = WIDTH - contentsX - 15 * IPHONE6_W_SCALE;
        
        NSMutableDictionary * contentsDic = [NSMutableDictionary dictionary];
        contentsDic[NSFontAttributeName] = Font13;
        CGRect contentsRect = [_collectionModel.descriptioN boundingRectWithSize:CGSizeMake(contentsW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentsDic context:nil];
        _textView.frame = (CGRect){{contentsX, contentsY}, contentsRect.size};
        _textView.text = _collectionModel.descriptioN;
//        _textView.backgroundColor = [UIColor greenColor];
        
        // 帖子图片
        CGFloat h;
//        _photoView.backgroundColor =[UIColor redColor];
        if (_collectionModel.covers && _collectionModel.covers.count > 0) {    // 如果有图片
            CGFloat photosX = titleX;
            CGFloat photosY = CGRectGetMaxY(_textView.frame) + 7 * IPHONE6_H_SCALE;
            // 计算配图视图的大小（根据图片的数量）
            CGSize photosSize = [self photosSizeWithCount:_collectionModel.covers.count];
            _photoView.frame = (CGRect){{photosX,photosY},photosSize};
            NSMutableArray * arr = [NSMutableArray array];
            if (_collectionModel.covers.count == 1) {
                [arr addObject:[_collectionModel.covers objectForKey:@"cover1"]];
            }else if (_collectionModel.covers.count == 2){
                [arr addObject:[_collectionModel.covers objectForKey:@"cover1"]];
                [arr addObject:[_collectionModel.covers objectForKey:@"cover2"]];
            }else{
                [arr addObject:[_collectionModel.covers objectForKey:@"cover1"]];
                [arr addObject:[_collectionModel.covers objectForKey:@"cover2"]];
                [arr addObject:[_collectionModel.covers objectForKey:@"cover3"]];
            }
            _photoView.picArr = (NSArray *)arr;
            h = CGRectGetMaxY(_photoView.frame) + 13;
        }else{
            h = CGRectGetMaxY(_textView.frame) + 13;
        }
        
//        self.frame = CGRectMake(0, 0, WIDTH, h);
        // 评论数
        [_commentsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(23 * IPHONE6_H_SCALE);
            make.right.equalTo(self.mas_right).offset(-15*IPHONE6_W_SCALE);
            make.width.equalTo(@100);
            make.height.equalTo(@(15*IPHONE6_W_SCALE));
        }];
        NSString * commentNum = [NSString stringWithFormat:@"%@评论", _collectionModel.commentNumber];
        _commentsView.text = commentNum;
        if (_collectionModel.commentNumber == nil) {
            _commentsView.text = @"0评论";
        }        // 底部横线
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@(5*IPHONE6_H_SCALE));
        }];
        [self hidden2];
        [self hidden4];
        [self hidden11];
        [self show17];
    }
}

#pragma mark - 计算配图的尺寸
- (CGSize)photosSizeWithCount:(NSUInteger)count
{
    CGFloat w;
    CGFloat h;
    if (count == 1) {   // 只有一张图片
        w = 120 * IPHONE6_W_SCALE;
        h = 80 * IPHONE6_W_SCALE;
    }  else if (count == 2){    // 只有两张图片
        w = 170 * IPHONE6_W_SCALE;
        h = 80 * IPHONE6_W_SCALE;
    } else{ // 其它情况
        w = 170*0.5*3 * IPHONE6_W_SCALE;
        h = 80 * IPHONE6_W_SCALE;
    }
    return CGSizeMake(w, h);
    
}

- (void)hidden2{    // 隐藏资讯
    
    _picView.hidden = YES;
    _titleLbl.hidden = YES;
    _detailLbl.hidden = YES;
    _commentsLbl.hidden = YES;
    _line.hidden = YES;
}
- (void)show2{  // 显示资讯
    _picView.hidden = NO;
    _titleLbl.hidden = NO;
    _detailLbl.hidden = NO;
    _commentsLbl.hidden = NO;
    _line.hidden = NO;
}
// 隐藏图集
- (void)hidden4{
    _picTitle.hidden = YES;
    _picsView.hidden = YES;
    _picMark.hidden = YES;
    _num.hidden = YES;
    _line.hidden = YES;
}
// 显示图集
- (void)show4{
    _picTitle.hidden = NO;
    _picsView.hidden = NO;
    _picMark.hidden = NO;
    _num.hidden = NO;
    _line.hidden = NO;
}
// 隐藏视频
- (void)hidden11{
    _videoPic.hidden = YES;
    _markView.hidden = YES;
    _line.hidden = YES;
}
// 显示视频
- (void)show11{
    _videoPic.hidden = NO;
    _markView.hidden = NO;
    _line.hidden = NO;
}
//  隐藏帖子
- (void)hidden17{

    _iconView.hidden = YES;

    _nameView.hidden = YES;

    _timeView.hidden = YES;

    _commentsView.hidden = YES;

    _titleView.hidden = YES;

    _textView.hidden = YES;
    _photoView.hidden = YES;
    _line.hidden = YES;
}
// 显示帖子
- (void)show17{
    _iconView.hidden = NO;
    
    _nameView.hidden = NO;
    
    _timeView.hidden = NO;
    
    _commentsView.hidden = NO;
    
    _titleView.hidden = NO;
    
    _textView.hidden = NO;
    _photoView.hidden = NO;
    _line.hidden = NO;
}

- (void)setFrame{
    // 图片
    CGFloat picX = 10 * IPHONE6_W_SCALE;
    CGFloat picY = 13 * IPHONE6_H_SCALE;
    CGFloat picW = 93 * IPHONE6_W_SCALE;
    CGFloat picH = 70 * IPHONE6_W_SCALE;
    _picView.frame = CGRectMake(picX, picY, picW, picH);
    [_picView sd_setImageWithURL:[NSURL URLWithString:_collectionModel.covers [@"cover1"]] placeholderImage:[UIImage imageNamed:@"123"]];
    _picView.backgroundColor = [UIColor redColor];
    
    // 标题
    CGFloat titleX = CGRectGetMaxX(_picView.frame) + Margin30 * IPHONE6_W_SCALE;
    CGFloat titleY = Margin36 * IPHONE6_H_SCALE;
    CGFloat titleW = WIDTH - titleX - Margin20 * IPHONE6_W_SCALE;
    NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
    titleDic[NSFontAttributeName] = Font16;
    NSString * str = _collectionModel.title;
    
//    CGSize titleSize = [str sizeWithAttributes:titleDic];
    CGRect titleRect = [str boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
    _titleLbl.frame = (CGRect){{titleX, titleY}, titleRect.size};
    _titleLbl.text = str;
    // 详情
    CGFloat detailX = titleX;
    CGFloat detailY = CGRectGetMaxY(_titleLbl.frame) + 13 * IPHONE6_H_SCALE;
    CGFloat detailW = WIDTH - detailX - Margin20 * IPHONE6_W_SCALE;
    NSMutableDictionary * detailDic = [NSMutableDictionary dictionary];
    detailDic[NSFontAttributeName] = Font13;
    
    NSString * detail;
    if (_collectionModel.descriptioN.length > 30) {
        
        detail = [_collectionModel.descriptioN substringToIndex:30];
    }else{
        
        detail = _collectionModel.descriptioN;
    }
    
    CGRect detailRect = [detail boundingRectWithSize:CGSizeMake(detailW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:detailDic context:nil];
    _detailLbl.frame = (CGRect){{detailX,detailY},detailRect.size};
    _detailLbl.text = detail;
    
    // 评论数
    NSString * commentNum = [NSString stringWithFormat:@"%@评论", _collectionModel.commentNumber];
    _commentsLbl.text = commentNum;
    
    if (_collectionModel.commentNumber == nil) {
        _commentsLbl.text = @"0评论";
    }
    [_commentsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-Margin20 * IPHONE6_W_SCALE);
        make.bottom.equalTo(self.mas_bottom).offset(-Margin33 * IPHONE6_H_SCALE);
        make.height.equalTo(@(Margin20));
        make.width.equalTo(_commentsLbl.mas_width);
    }];
    
    // 分割线
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(5*IPHONE6_H_SCALE));
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
