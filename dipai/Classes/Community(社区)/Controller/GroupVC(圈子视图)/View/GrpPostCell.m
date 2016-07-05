//
//  GrpPostCell.m
//  dipai
//
//  Created by 梁森 on 16/7/5.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "GrpPostCell.h"

#import "GrpPostFrmModel.h"

#import "GroupModel.h"
#import "LSPhotoView.h"

#import "UIImageView+WebCache.h"
#import "Masonry.h"
@interface GrpPostCell()

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
@property (nonatomic, strong) LSPhotoView * picView;
/**
 *  底部横线
 */
@property (nonatomic, strong) UIView * line;

@end

@implementation GrpPostCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"cellID";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //        self.backgroundColor = [UIColor redColor];
        // 添加子控件
        [self setUpChildView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setUpChildView{
    
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
    LSPhotoView * picView = [[LSPhotoView alloc] init];
    //    picView.backgroundColor = [UIColor redColor];
    [self addSubview:picView];
    _picView = picView;
    
    // 底部横线
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
    [self addSubview:line];
    _line = line;
    
    
    
}

- (void)setFrmModel:(GrpPostFrmModel *)frmModel{
    
    NSLog(@"%@", _frmModel);
    _frmModel = frmModel;
}


//- (void)showStarVC:(UIGestureRecognizer *)tap{
//    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickFaceWith:)]) {
//        [self.delegate tableViewCell:self didClickFaceWith:_frameModel.postsModel];
//    }else{
//        NSLog(@"PostCell的代理没有响应...");
//    }
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 头像
    _iconView.frame = _frmModel.faceFrame;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_frmModel.groupModel.face] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
    
    // 昵称
    _nameView.frame = _frmModel.nameFrame;
    _nameView.text = _frmModel.groupModel.username;
    
    // 时间
    NSString * str = [_frmModel.groupModel.addtime stringByAppendingString:@"  发表帖子"];
    CGFloat timeX = _nameView.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(_nameView.frame) + Margin14 * IPHONE6_H_SCALE;
    NSMutableDictionary * timeDic = [NSMutableDictionary dictionary];
    timeDic[NSFontAttributeName] = Font11;
    CGSize timeSize = [str sizeWithAttributes:timeDic];
    _timeView.frame = (CGRect){{timeX,timeY},timeSize};
    
    _timeView.text = str;
    
    // 评论数
    [_commentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(23 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-15*IPHONE6_W_SCALE);
        make.width.equalTo(@100);
        make.height.equalTo(@(15*IPHONE6_W_SCALE));
    }];
    _commentsView.text = [NSString stringWithFormat:@"%@评论", _frmModel.groupModel.comment];
    
    // 标题
    _titleView.frame = _frmModel.titleFrame;
    _titleView.text = _frmModel.groupModel.title;
    
    // 简介
    _textView.frame = _frmModel.contentsFrame;
    _textView.text = _frmModel.groupModel.introduction;
    
    // 图片
    _picView.frame = _frmModel.picsFrame;
    
//    NSLog(@"%lu", _frameModel.groupModel.picname.count);
    
    _picView.picArr = (NSArray *)_frmModel.groupModel.picname;
    
    
    // 底部横线
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@0.5);
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
