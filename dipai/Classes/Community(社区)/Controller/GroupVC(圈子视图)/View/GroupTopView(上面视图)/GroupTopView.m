//
//  GroupTopView.m
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "GroupTopView.h"
#import "GroupFrameModel.h"
#import "GrpPostFrmModel.h"
#import "GroupModel.h"

#import "UIImageView+WebCache.h"

#import "PicView.h"

#import "Masonry.h"
@interface GroupTopView()

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
 *  标题
 */
@property (nonatomic, strong) UILabel * titleView;

/**
 *  正文
 */
@property (nonatomic, strong) UILabel *textView;

/**
 *  用来装图片的视图
 */
@property (nonatomic, strong) PicView * picView;

/**
 *  评论数
 */
@property (nonatomic, strong) UILabel * commentsView;

@end

@implementation GroupTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self setUpChildView];
        
        //        self.backgroundColor = [UIColor lightGrayColor];
    }
    
    return self;
}

- (void)setFrameModel:(GroupFrameModel *)frameModel{
    _frameModel = frameModel;
    
    [self setUpFrame];
    [self setUpData];
}

- (void)setGrpFrmModel:(GrpPostFrmModel *)grpFrmModel{
    
//    NSLog(@"%@", grpFrmModel);
    
    _grpFrmModel = grpFrmModel;
    
    // 头像
    _iconView.frame = _grpFrmModel.faceFrame;
    
    // 昵称
    _nameView.frame = _grpFrmModel.nameFrame;
    
    // 图片
    _picView.frame = _grpFrmModel.picsFrame;
    _picView.picArr = _grpFrmModel.groupModel.picname;
    
    // 时间
    NSString * str =[_grpFrmModel.groupModel.addtime stringByAppendingString:[NSString stringWithFormat:@"  发布帖子"]];
    CGFloat timeX = _nameView.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(_nameView.frame) + Margin14 * IPHONE6_H_SCALE;
    NSMutableDictionary * timeDic = [NSMutableDictionary dictionary];
    timeDic[NSFontAttributeName] = Font11;
    CGSize timeSize = [str sizeWithAttributes:timeDic];
    _timeView.frame = (CGRect){{timeX,timeY},timeSize};
    
    // 标题
    _titleView.frame = _grpFrmModel.titleFrame;
    _titleView.numberOfLines = 0;
//    _titleView.backgroundColor = [UIColor redColor];
    
    // 正文
    _textView.frame = _grpFrmModel.contentsFrame;
    
    // 评论数
    [_commentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(23 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-15*IPHONE6_W_SCALE);
        make.width.equalTo(@100);
        make.height.equalTo(@(15*IPHONE6_W_SCALE));
    }];
    
    
    // 头像
    NSURL * url = [NSURL URLWithString:_grpFrmModel.groupModel.face];
    [_iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
    
    // 昵称
    _nameView.text = _grpFrmModel.groupModel.username;
    _nameView.textColor = [UIColor colorWithRed:228 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1];
    
    // 时间
    
    NSString * str1 =[_grpFrmModel.groupModel.addtime stringByAppendingString:[NSString stringWithFormat:@"  发布帖子"]];
    _timeView.text = str1;
    // 标题
    _titleView.frame = _grpFrmModel.titleFrame;
    _titleView.text = _grpFrmModel.groupModel.title;
    //    NSLog(@"%@", _frameModel.groupModel.addtime);
    
    // 正文
    _textView.text = _grpFrmModel.groupModel.introduction;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = Font13;
    _textView.textColor = Color123;
}

#pragma mark --- 添加子控件
- (void)setUpChildView{
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
//    iconView.backgroundColor = [UIColor redColor];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 19*IPHONE6_W_SCALE;
    [self addSubview:iconView];
    _iconView = iconView;
    
    iconView.userInteractionEnabled = YES;
    // 显示个人主页
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStarVC:)];
    [iconView addGestureRecognizer:tap];
    
    // 昵称
    UILabel *nameView = [[UILabel alloc] init];
    nameView.font = Font15;
    [self addSubview:nameView];
    _nameView = nameView;
    
    // 时间
    UILabel *timeView = [[UILabel alloc] init];
//    timeView.backgroundColor = [UIColor redColor];
    timeView.font = Font11;
    timeView.textColor = Color153;
    [self addSubview:timeView];
    _timeView = timeView;
    
    // 标题
    UILabel * titleView = [[UILabel alloc] init];
    titleView.font = Font16;
    timeView.numberOfLines = 0;
    [self addSubview:titleView];
    _titleView = titleView;
    
    // 正文
    UILabel *textView = [[UILabel alloc] init];
    textView.font = Font13;
    textView.textColor = Color123;
    textView.numberOfLines = 0;
    [self addSubview:textView];
    _textView = textView;
    
    PicView * picView = [[PicView alloc] init];
//    picView.backgroundColor = [UIColor redColor];
    [self addSubview:picView];
    _picView = picView;
    
    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyAction:)];
    //    _textView.userInteractionEnabled = YES;
    //    [_textView addGestureRecognizer:tap];
    
    // 评论数
    UILabel * commentsView = [[UILabel alloc] init];
    commentsView.textAlignment = NSTextAlignmentRight;
    commentsView.font = Font15;
    commentsView.textColor = Color178;
    [self addSubview:commentsView];
    _commentsView = commentsView;
}

- (void)showStarVC:(UIGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(didClickFace)]) {
        [self.delegate didClickFace];
    }else{
        NSLog(@"TopView的代理没有响应...");
    }
}


#pragma mark --- 设置frame
- (void)setUpFrame{
    
    // 头像
    _iconView.frame = _frameModel.faceFrame;
    
    // 昵称
    _nameView.frame = _frameModel.nameFrame;
    
    // 图片
    _picView.frame = _frameModel.picsFrame;
    _picView.picArr = _frameModel.groupModel.picname;
    
    // 时间
    NSString * str =[_frameModel.groupModel.addtime stringByAppendingString:[NSString stringWithFormat:@"  回复帖子"]];
    CGFloat timeX = _nameView.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(_nameView.frame) + Margin14 * IPHONE6_H_SCALE;
    NSMutableDictionary * timeDic = [NSMutableDictionary dictionary];
    timeDic[NSFontAttributeName] = Font11;
    CGSize timeSize = [str sizeWithAttributes:timeDic];
    _timeView.frame = (CGRect){{timeX,timeY},timeSize};
    
    // 标题
    _titleView.frame = _frameModel.titleFrame;
    
    // 正文
    _textView.frame = _frameModel.contentsFrame;
    
    // 评论数
    [_commentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(23 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-15*IPHONE6_W_SCALE);
        make.width.equalTo(@100);
        make.height.equalTo(@(15*IPHONE6_W_SCALE));
    }];

}
#pragma mark --- 设置数据
- (void)setUpData{
    
    // 头像
    NSURL * url = [NSURL URLWithString:_frameModel.groupModel.face];
    [_iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
    
    // 昵称
    _nameView.text = _frameModel.groupModel.username;
    _nameView.textColor = [UIColor colorWithRed:228 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1];
    
    // 时间
   
    NSString * str =[_frameModel.groupModel.addtime stringByAppendingString:[NSString stringWithFormat:@"  回复帖子"]];
    _timeView.text = str;
    
//    NSLog(@"%@", _frameModel.groupModel.addtime);
    
    // 正文
    _textView.text = _frameModel.groupModel.content;
//    _textView.backgroundColor = [UIColor redColor];
    _textView.font = Font16;
    _textView.textColor = [UIColor blackColor];
    
}

@end







