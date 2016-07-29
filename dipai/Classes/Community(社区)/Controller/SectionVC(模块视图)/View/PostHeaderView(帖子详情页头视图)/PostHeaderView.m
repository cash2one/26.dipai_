//
//  PostHeaderView.m
//  dipai
//
//  Created by 梁森 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "PostHeaderView.h"
#import "PostDaraModel.h"

#import "LSPhotoView.h"
#import "UIImageView+WebCache.h"

// 详情页中图片视图
#import "DetailPhotoView.h"

#import "UIImageView+getSize.h"

#import "Masonry.h"
@interface PostHeaderView()

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
 *  帖子的图片视图
 */
@property (nonatomic, strong) DetailPhotoView * picView;
/**
 *  底部横线
 */
@property (nonatomic, strong) UIView * line;
/**
 *  编辑按钮
 */
@property (nonatomic, strong) UIButton * editBtn;
/**
 *  全部评论视图
 */
@property (nonatomic, strong) UIView * commentsView;
/**
 *  全部评论标题
 */
@property (nonatomic, strong) UILabel * commentsLbl;

/**
 *  底部分割线
 */
@property (nonatomic, strong) UIView * bottomLine;

@property (nonatomic, strong) NSMutableArray * imageArr;

@end

@implementation PostHeaderView

- (NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}



- (void)setDataModel:(PostDaraModel *)dataModel{
    _dataModel = dataModel;
    [self layoutSubviews];
    // 利用block传值
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpChildControl];
    }
    return self;
}

- (void)setUpChildControl{
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 19 * IPHONE6_W_SCALE;
    [self addSubview:iconView];
    _iconView = iconView;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStarVC:)];
    iconView.userInteractionEnabled = YES;
    [iconView addGestureRecognizer:tap];
    
    // 昵称
    UILabel *nameView = [[UILabel alloc] init];
    nameView.textColor = [UIColor redColor];
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
    DetailPhotoView * picView = [[DetailPhotoView alloc] init];
//    picView.backgroundColor = [UIColor greenColor];
    [self addSubview:picView];
    _picView = picView;
    
    
    for (int i = 0; i < 9; i ++) {
        UIImageView * imageV = [[UIImageView alloc] init];
        [self addSubview:imageV];
        [self.imageArr addObject:imageV];
    }
    
    // 分割线
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    [self addSubview:line];
    _line = line;
    
    
    // 全部评论视图
    UIView * commentsView = [[UIView alloc] init];
    commentsView.backgroundColor = [UIColor whiteColor];
    [self addSubview:commentsView];
    _commentsView = commentsView;
    // 全部评论标题
    UILabel * commentsLbl = [[UILabel alloc] init];
    commentsLbl.textColor = [UIColor blackColor];
    commentsLbl.font = Font16;
    commentsLbl.text = @"全部评论";
    [commentsView addSubview:commentsLbl];
    _commentsLbl = commentsLbl;
    
    // 底部的分割线
    UIView * bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = Color238;
    [self addSubview:bottomLine];
    _bottomLine = bottomLine;
}
#pragma mark --- 设置子控件


#pragma mark -- 跳转到个人主页
- (void)showStarVC:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(PostHeaderView:didClickFaceWith:)]) {
        [self.delegate PostHeaderView:self didClickFaceWith:_dataModel];
    } else{
        NSLog(@"PostHeaderView的代理没有响应...");
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 头像
    CGFloat faceX = Margin30 * IPHONE6_W_SCALE;
    CGFloat faceY = 28 * 0.5 * IPHONE6_H_SCALE;
    CGFloat faceW = 76 * 0.5 * IPHONE6_W_SCALE;
    CGFloat faceH = faceW;
    _iconView.frame = CGRectMake(faceX, faceY, faceW, faceH);
    // 这个方法容易报错 <Error>: CGContextDrawImage: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_dataModel.face] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
    
    // 昵称
    CGFloat nameX = CGRectGetMaxX(_iconView.frame) + Margin22 * IPHONE6_W_SCALE;
    CGFloat nameY = 38 * 0.5 * IPHONE6_H_SCALE;
    NSMutableDictionary * nameDic = [NSMutableDictionary dictionary];
    nameDic[NSFontAttributeName] = Font15;
    CGSize nameSize = [_dataModel.username sizeWithAttributes:nameDic];
    _nameView.frame = (CGRect){{nameX, nameY}, nameSize};
//    NSLog(@"username:%@", _dataModel.username);
    
    _nameView.text = _dataModel.username;
    
    // 时间
    CGFloat timeX = _nameView.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(_nameView.frame) + Margin14 * IPHONE6_H_SCALE;
    NSMutableDictionary * timeDic = [NSMutableDictionary dictionary];
    timeDic[NSFontAttributeName] = Font11;
    CGSize timeSize = [_dataModel.addtime sizeWithAttributes:timeDic];
    _timeView.frame = (CGRect){{timeX,timeY},timeSize};
    _timeView.text = _dataModel.addtime;
    
    // 标题
    CGFloat titleX = Margin30 * IPHONE6_W_SCALE;
    CGFloat titleY = CGRectGetMaxY(_iconView.frame) + Margin30 * IPHONE6_H_SCALE;
    CGFloat titleW = WIDTH - titleX - 15 * IPHONE6_W_SCALE;
    NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
    titleDic[NSFontAttributeName] = Font16;
    CGRect titleRect = [_dataModel.title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
    _titleView.frame = (CGRect){{titleX, titleY}, titleRect.size};
    _titleView.text = _dataModel.title;
    
    // 简介
    CGFloat contentsX = titleX;
    CGFloat contentsY = CGRectGetMaxY(_titleView.frame) + 12 * IPHONE6_H_SCALE;
    CGFloat contentsW = WIDTH - contentsX - 15 * IPHONE6_W_SCALE;
    
    NSMutableDictionary * contentsDic = [NSMutableDictionary dictionary];
    contentsDic[NSFontAttributeName] = Font13;
    CGRect contentsRect = [_dataModel.content boundingRectWithSize:CGSizeMake(contentsW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentsDic context:nil];
    _textView.frame = (CGRect){{contentsX, contentsY}, contentsRect.size};
    _textView.text = _dataModel.content;
    
    // 图片
   
    if (_dataModel.imgs) {    // 如果有图片
        
        CGFloat photosY = CGRectGetMaxY(_textView.frame) + 11 * IPHONE6_H_SCALE;
         CGFloat height = 0;
        for ( int i = 0; i < _dataModel.imgs.count; i ++) {
            CGSize size = [UIImageView downloadImageSizeWithURL:[NSURL URLWithString:_dataModel.imgs[i]]];
//            CGSize size = [UIImageView downloadImageSizeWithURL:[NSURL URLWithString:@"http://dipaiapp.replays.net/public/upload/user_forum/15/20160727/14696227505843215.jpeg"]];
            // http://www.coolsc.net/imguploads/Image/0811/zm/3/23/12.jpg
            // http://dipaiapp.replays.net/public/upload/user_forum/15/20160727/14696227505843215.jpeg
            
            CGFloat h = size.height;
            CGFloat w = size.width;
            
            if (w == 0) {
                w = WIDTH - 30 * IPHONE6_W_SCALE;
            }
            
            if (h == 0) {
                h = w;
            }
//            NSLog(@"width--%f", size.width);
            CGFloat scale = 1.0;
            if (size.width<WIDTH-30*IPHONE6_W_SCALE) {
                
//                NSLog(@"scale1---%f", scale);
                
                scale = (WIDTH - 30 * IPHONE6_W_SCALE)/w;
                
//                NSLog(@"%f", WIDTH - 30 * IPHONE6_W_SCALE);
//                NSLog(@"%f", w);
//                NSLog(@"%f", scale);
                
                 h = h * scale;
            } else{
                scale = 1.0;
                h = h;
            }
//            NSLog(@"scale==%f", scale);
            
           
            height = height + h + 8 * IPHONE6_H_SCALE;
            _picView.frame = CGRectMake(15 * IPHONE6_W_SCALE, photosY , WIDTH - 30 * IPHONE6_W_SCALE,  height);
        }
        
        
//        NSLog(@"%f", height);
        _picView.picArr = _dataModel.imgs;
    }
    
    
    
    // 底部的分割线
    
    CGFloat botLineY;
    if (_dataModel.imgs) {
        
//        NSLog(@"%@", _dataModel.imgs);
       botLineY = CGRectGetMaxY(_picView.frame) + 14 * IPHONE6_H_SCALE;
    } else{
        botLineY = CGRectGetMaxY(_textView.frame) + 14 * IPHONE6_H_SCALE;
    }
    _bottomLine.frame = CGRectMake(0, botLineY, WIDTH, 0.5);
//    _bottomLine.backgroundColor = [UIColor greenColor];
    
    _viewHeight = CGRectGetMaxY(_bottomLine.frame);

    // 可以再layoutSubviews方法中直接返回该视图的frame
        self.frame = CGRectMake(0, 0, WIDTH, _viewHeight);
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
@end
