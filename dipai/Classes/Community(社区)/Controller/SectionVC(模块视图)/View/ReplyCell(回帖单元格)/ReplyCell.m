//
//  ReplyCell.m
//  dipai
//
//  Created by 梁森 on 16/6/28.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ReplyCell.h"

// 用来装图片的视图
#import "DetailPhotoView.h"

#import "ReplyFrameModel.h"

#import "ReplyModel.h"

#import "Masonry.h"

#import "UIImageView+WebCache.h"
@interface ReplyCell()

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
 *  底部横线
 */
@property (nonatomic, strong) UIView * line;


/**
 *  回复按钮
 */
@property (nonatomic, strong) UIButton * replyBtn;
/**
 *  用来装图片的视图
 */
@property (nonatomic, strong) DetailPhotoView * picView;

@property (nonatomic, strong) NSArray * pics;

/****************对回帖的回复****************/
/**
 *  对回帖的回复的视图
 */
@property (nonatomic, strong)UIView * reReplyView;
@property (nonatomic, strong) UILabel * reNameView;
@property (nonatomic, strong) UILabel * reContentView;

@end

@implementation ReplyCell

- (NSArray *)pics{
    if (_pics == nil) {
        _pics = [NSArray array];
    }
    return _pics;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView WithArray:(NSArray *)array
{
    static NSString * cellID = @"cellID";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID WithArray:array];
//        NSLog(@"创建新的单元格....");
        
    }
    
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithArray:(NSArray *)array
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.pics = array;
        // 添加子控件
        [self setUpChildView];
        
//        self.backgroundColor = [UIColor yellowColor];
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}

- (void)setFrameModel:(ReplyFrameModel *)frameModel{
    
    // 获取到回复的frame模型
    _frameModel = frameModel;
}

- (void)setUpChildView{
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 19 * IPHONE6_W_SCALE;
    [self addSubview:iconView];
    _iconView = iconView;
    
    iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStarVC:)];
    [iconView addGestureRecognizer:tap];
    
    // 昵称
    UILabel *nameView = [[UILabel alloc] init];
    nameView.font = Font15;
    nameView.textColor = [UIColor redColor];
    [self addSubview:nameView];
    _nameView = nameView;
    
    // 时间
    UILabel *timeView = [[UILabel alloc] init];
    timeView.font = Font11;
    timeView.textColor = Color153;
    [self addSubview:timeView];
    _timeView = timeView;
    
    // 楼层
    UILabel * indexLbl = [[UILabel alloc] init];
    indexLbl.font = Font11;
    indexLbl.textColor = Color153;
    [self addSubview:indexLbl];
    _indexLbl = indexLbl;
    
    // 回复按钮
    UIButton * replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyBtn setImage:[UIImage imageNamed:@"huifu"] forState:UIControlStateNormal];
    [replyBtn addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:replyBtn];
    _replyBtn = replyBtn;
    
    
    // 回复内容
    UILabel *textView = [[UILabel alloc] init];
    textView.numberOfLines = 0;
    textView.font = Font15;
    [self addSubview:textView];
    _textView = textView;
    
    // 回帖图片
    
    DetailPhotoView * picView = [[DetailPhotoView alloc] init];
    picView.opaque = YES;
    [self addSubview:picView];
    _picView = picView;
    
    
    // 对回帖的回复
    
    UIView * reReplyView = [[UIView alloc] init];
    reReplyView.backgroundColor = [UIColor colorWithRed:255 / 255.f green:248 / 255.f blue:248 / 255.f alpha:1];
//     reReplyView.backgroundColor = [UIColor colorWithRed:288 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.7];
    reReplyView.layer.borderColor = [[UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1] CGColor];
    reReplyView.layer.borderWidth = 0.5;
    [self addSubview:reReplyView];
    _reReplyView = reReplyView;
    
    UILabel * reNameView = [[UILabel alloc] init];
    reNameView.font = Font13;
    reNameView.textColor = Color102;
    [reReplyView addSubview:reNameView];
    _reNameView = reNameView;
    
    UILabel * reContentView = [[UILabel alloc] init];
    reContentView.numberOfLines = 0;
    reContentView.font = Font14;
    reContentView.textColor = [UIColor blackColor];
    [reReplyView addSubview:reContentView];
    _reContentView = reContentView;
    
    
    // 底部横线
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
//    line.backgroundColor = [UIColor greenColor];
    [self addSubview:line];
    _line = line;
    
    
    for (UIView * view in self.subviews) {
        view.opaque = YES;
    }
    
}
#pragma mark --- 回复的事件
- (void)replyAction{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedContentWithID:andModel:)]) {
        [self.delegate tableViewCell:self didClickedContentWithID:@"" andModel:_frameModel.replyModel];
    } else{
        NSLog(@"ReplyCell的代理没有响应...");
    }
}
#pragma mark --- 跳到个人主页
- (void)showStarVC:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickFaceWithModel:)]) {
        [self.delegate tableViewCell:self didClickFaceWithModel:_frameModel.replyModel];
    } else{
        NSLog(@"点击头像时，ReplyCell的代理没有响应...");
    }
}

#pragma mark --- 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 头像
    _iconView.frame = _frameModel.faceFrame;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_frameModel.replyModel.face] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
    
    // 昵称
    _nameView.frame = _frameModel.nameFrame;
    _nameView.text = _frameModel.replyModel.username;
    
    CGFloat indexX = CGRectGetMaxX(_nameView.frame) + 14 * IPHONE6_W_SCALE;
    CGFloat indexY = 22 * IPHONE6_H_SCALE;
    CGFloat indexW = WIDTH-indexX;
    CGFloat indexH = 11 * IPHONE6_W_SCALE;
    _indexLbl.frame = CGRectMake(indexX, indexY, indexW, indexH);
    
    // 时间
    CGFloat timeX = _nameView.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(_nameView.frame) + Margin14 * IPHONE6_H_SCALE;
    NSMutableDictionary * timeDic = [NSMutableDictionary dictionary];
    timeDic[NSFontAttributeName] = Font11;
    CGSize timeSize = [_frameModel.replyModel.addtime sizeWithAttributes:timeDic];
    _timeView.frame = (CGRect){{timeX,timeY},timeSize};
    _timeView.text = _frameModel.replyModel.addtime;
    
    // 楼层
//    _indexLbl.frame = _frameModel.replyIndexFrame;
    
    // 回复按钮
    [_replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-15* IPHONE6_W_SCALE);
        make.width.equalTo(@(46 * IPHONE6_W_SCALE));
        make.height.equalTo(@(20 * IPHONE6_H_SCALE));
    }];

    
    // 回复内容
    _textView.frame = _frameModel.contentsFrame;
    _textView.text = _frameModel.replyModel.content;
    
    // 回帖图片
    _picView.frame = _frameModel.picsFrame;
    NSArray * picArr = _frameModel.replyModel.picname;
    _picView.picArr = picArr;

    
    
    // 对回帖的回复
    _reReplyView.frame = _frameModel.ReReplyFrame;
    _reNameView.text = _frameModel.replyModel.reply[@"username"];
    _reContentView.text = _frameModel.replyModel.reply[@"content"];
    _reNameView.frame = _frameModel.ReNameFrame;
    _reContentView.frame = _frameModel.ReContentFrame;
    
    
//    NSLog(@"rereplyframe.height:---%f", _frameModel.ReReplyFrame.size.height);
    
    CGFloat lineY = 0.0;
    // 底部横线
    if (_frameModel.ReReplyFrame.size.height) {
        lineY = CGRectGetMaxY(_frameModel.ReReplyFrame) + 14*IPHONE6_H_SCALE;
    }else{
        lineY = CGRectGetMaxY(_frameModel.ReplyFrame);
    }
    
//    _line.frame = CGRectMake(0, lineY, WIDTH, 0.5);
    
//    _line.backgroundColor = [UIColor greenColor];
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
