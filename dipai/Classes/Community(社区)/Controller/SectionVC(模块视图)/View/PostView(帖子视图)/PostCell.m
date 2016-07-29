//
//  PostCell.m
//  dipai
//
//  Created by 梁森 on 16/6/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "PostCell.h"
#import "PostsModel.h"

#import "PostFrameModel.h"
//  用户模型
#import "UserModel.h"


#import "Masonry.h"

#import "LSPhotoView.h"

#import "UIImageView+WebCache.h"
@interface PostCell()

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

@implementation PostCell

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
    commentsView.font = Font10;
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
    textView.numberOfLines = 0;
    textView.font = Font13;
    textView.textColor = Color123;
    [self addSubview:textView];
    _textView = textView;
    
    // 图片
    LSPhotoView * picView = [[LSPhotoView alloc] init];
//    picView.backgroundColor = [UIColor redColor];
    picView.contentMode = UIViewContentModeScaleAspectFill;
    picView.clipsToBounds = YES;
    [self addSubview:picView];
    _picView = picView;
    
    // 底部横线
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
    [self addSubview:line];
    _line = line;
    
    

}
- (void)setFrameModel:(PostFrameModel *)frameModel{
    _frameModel = frameModel;
    
    // 设置数据
//    [self setData];
}

- (void)showStarVC:(UIGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickFaceWith:)]) {
        [self.delegate tableViewCell:self didClickFaceWith:_frameModel.postsModel];
    }else{
        NSLog(@"PostCell的代理没有响应...");
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 头像
    _iconView.frame = _frameModel.faceFrame;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_frameModel.postsModel.face] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
    
    // 昵称
    _nameView.frame = _frameModel.nameFrame;
    _nameView.text = _frameModel.postsModel.username;
    // 时间
    CGFloat timeX = _nameView.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(_nameView.frame) + Margin14 * IPHONE6_H_SCALE;
    NSMutableDictionary * timeDic = [NSMutableDictionary dictionary];
    timeDic[NSFontAttributeName] = Font11;
    CGSize timeSize = [_frameModel.postsModel.addtime sizeWithAttributes:timeDic];
    _timeView.frame = (CGRect){{timeX,timeY},timeSize};
        
    _timeView.text = _frameModel.postsModel.addtime;
    
    // 评论数
    [_commentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(23 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-15*IPHONE6_W_SCALE);
        make.width.equalTo(@100);
        make.height.equalTo(@(15*IPHONE6_W_SCALE));
    }];
    _commentsView.text = [NSString stringWithFormat:@"%@评论", _frameModel.postsModel.comment];
    
    // 标题
    _titleView.frame = _frameModel.titleFrame;
    _titleView.text = _frameModel.postsModel.title;
    
    // 简介
    _textView.frame = _frameModel.contentsFrame;
    _textView.text = _frameModel.postsModel.introduction;
    
    // 图片
    if (_frameModel.postsModel.picname && _frameModel.postsModel.picname.count > 0) {
        _picView.hidden = NO;
        _picView.frame = _frameModel.picsFrame;
         _picView.picArr = (NSArray *)_frameModel.postsModel.picname;
    }else{
        _picView.hidden = YES;
    }
    
    
    NSLog(@"%lu", _frameModel.postsModel.picname.count);
    
   
   
    
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
