//
//  MyReplyTopView.m
//  dipai
//
//  Created by 梁森 on 16/7/1.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyReplyTopView.h"

#import "MyReplyFrameModel.h"
#import "MyReplyModel.h"

#import "PicView.h"

#import "UIImageView+WebCache.h"
@interface MyReplyTopView()

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
 *  正文
 */
@property (nonatomic, strong) UILabel *textView;

/**
 *  用来装图片的视图
 */
@property (nonatomic, strong) PicView * picView;


@property (nonatomic, strong) NSMutableArray * picArr;

@end

@implementation MyReplyTopView

- (NSMutableArray *)picArr{
    if (_picArr == nil) {
        _picArr = [NSMutableArray array];
    }
    return _picArr;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self setUpChildView];
        
        //        self.backgroundColor = [UIColor lightGrayColor];
    }
    
    return self;
}
#pragma mark --- 添加子控件
- (void)setUpChildView{
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 19*IPHONE6_W_SCALE;
    [self addSubview:iconView];
    _iconView = iconView;
    
    // 昵称
    UILabel *nameView = [[UILabel alloc] init];
    nameView.font = Font15;
    [self addSubview:nameView];
    _nameView = nameView;
    
    // 时间
    // 时间
    UILabel *timeView = [[UILabel alloc] init];
    timeView.font = Font11;
    timeView.textColor = Color153;
    [self addSubview:timeView];
    _timeView = timeView;
    
    // 正文
    UILabel *textView = [[UILabel alloc] init];
    textView.font = Font16;
    textView.numberOfLines = 0;
    [self addSubview:textView];
    _textView = textView;
    
    PicView * picView = [[PicView alloc] init];
    picView.backgroundColor = [UIColor redColor];
    [self addSubview:picView];
    _picView = picView;
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyAction:)];
//    _textView.userInteractionEnabled = YES;
//    [_textView addGestureRecognizer:tap];
}
- (void)setMyReFrameModel:(MyReplyFrameModel *)myReFrameModel{
    _myReFrameModel = myReFrameModel;
    // 设置frame
    [self setUpFrame];
    // 设置data
    [self setUpData];
}
#pragma mark --- 设置frame
- (void)setUpFrame{
    
    MyReplyModel * myReModel = _myReFrameModel.myreplyModel;
    
    // 头像
    _iconView.frame = _myReFrameModel.faceFrame;
    
    // 昵称
    _nameView.frame = _myReFrameModel.nameFrame;
    
    // 图片
    _picView.frame = _myReFrameModel.picsFrame;
    _picView.picArr = _myReFrameModel.myreplyModel.picname;
    
    // 时间
    CGFloat timeX = _nameView.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(_nameView.frame) + Margin14 * IPHONE6_H_SCALE;
    NSMutableDictionary * timeDic = [NSMutableDictionary dictionary];
    timeDic[NSFontAttributeName] = Font11;
    CGSize timeSize = [myReModel.addtime sizeWithAttributes:timeDic];
    _timeView.frame = (CGRect){{timeX,timeY},timeSize};
    
    // 正文
    _textView.frame = _myReFrameModel.contentsFrame;
    
    
    
}
#pragma mark --- 设置数据
- (void)setUpData{
    
    MyReplyModel * myReModel = _myReFrameModel.myreplyModel;
    
    // 头像
    NSURL * url = [NSURL URLWithString:myReModel.face];
    [_iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
    
    // 昵称
    _nameView.text = myReModel.username;
    _nameView.textColor = [UIColor colorWithRed:228 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1];
    
    // 时间
    _timeView.text = myReModel.addtime;
    
    // 正文
    _textView.text = myReModel.content;
    
}


@end
