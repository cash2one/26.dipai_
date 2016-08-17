//
//  HotVideoCell.m
//  dipai
//
//  Created by 梁森 on 16/6/12.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "HotVideoCell.h"
#import "Masonry.h"

#import "HotVideoModel.h"

#import "UIImageView+WebCache.h"
@interface HotVideoCell()
/**
 *  装按钮的数组
 */
@property (nonatomic, strong) NSMutableArray * btnArray;
/**
 *  装标题的数组
 */
@property (nonatomic, strong) NSMutableArray * titleArray;

/**
 *  红色竖条
 */
@property (nonatomic, strong) UIView * redView;
/**
 *  热门专辑的label
 */
@property (nonatomic, strong) UILabel * hotLbl;
/**
 *  更多内容的文字
 */
@property (nonatomic, strong) UILabel * moreLbl;
/**
 *   更多内容指示图
 */
@property (nonatomic, strong) UIImageView * nextView;
/**
 *  更多内容的按钮
 */
//@property (nonatomic, strong) UIButton * moreBtn;

@property (nonatomic, strong) UIView * separateView;

@end

@implementation HotVideoCell

- (NSMutableArray *)btnArray{
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"tournamentCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        //        NSLog(@"...");
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        [self setUpChildView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return  self;
}

#pragma mark --- 添加子控件
- (void)setUpChildView{
    // redView
    UIView * redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self addSubview:redView];
    _redView = redView;
    
    // 热门专辑的label
    UILabel * hotLbl = [[UILabel alloc] init];
//    hotLbl.backgroundColor = [UIColor redColor];
    hotLbl.text = @"视频专辑";
    hotLbl.font = Font16;
    [self addSubview:hotLbl];
    _hotLbl = hotLbl;
    
    // 更多内容按钮
    // 文字
    UILabel * moreLbl = [[UILabel alloc] init];
//    moreLbl.backgroundColor = [UIColor redColor];
    moreLbl.textAlignment = NSTextAlignmentRight;
    moreLbl.text = @"全部专辑";
    moreLbl.textColor = Color153;
    moreLbl.font = Font12;
    [self addSubview:moreLbl];
    _moreLbl = moreLbl;
    // 指示图
    UIImageView * nextView = [[UIImageView alloc] init];
//    nextView.backgroundColor = [UIColor greenColor];
    nextView.image = [UIImage imageNamed:@"gengduoneirong"];
    [self addSubview:nextView];
    _nextView = nextView;
    // 按钮
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:moreBtn];
    _moreBtn = moreBtn;
    
    
    // 创建四个图片按钮
    for (int i = 0; i < 4;  i ++) {
        UIImageView * imageBtn = [[UIImageView alloc] init];
//        imageBtn.backgroundColor = [UIColor redColor];
        imageBtn.tag = i + 100;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        imageBtn.userInteractionEnabled = YES;
        [imageBtn addGestureRecognizer:tap];
        [self addSubview:imageBtn];
        // 将四个按钮（UIImageView）装到按钮数组中
        [self.btnArray addObject:imageBtn];
        
        // 四个图片的标题
        UILabel * titleLbl = [[UILabel alloc] init];
//        titleLbl.backgroundColor = [UIColor redColor];
        titleLbl.numberOfLines = 0;
        titleLbl.font = Font13;
        if (HEIGHT == 480.f && (i == 2 || i == 3)) {
            titleLbl.hidden = YES;
        }else{
            titleLbl.hidden = NO;
        }
        [self addSubview:titleLbl];
        //
        [self.titleArray addObject:titleLbl];
        
    }
    
    // 分割线
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    [self addSubview:separateView];
    _separateView = separateView;
}

#pragma mark ---- 为图片添加的点击事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    if (_videoModelArr.count > 0) {
        UIImageView * imageBtn = (UIImageView *)tap.view;
        switch (imageBtn.tag) {
            case 100:
                NSLog(@"0");
                if ([self.delegate respondsToSelector:@selector(turePageToVideoVCWithTag:andWapURL:)]) {
                    HotVideoModel * hotVideoModel = _videoModelArr[0];
                    [self.delegate turePageToVideoVCWithTag:imageBtn.tag andWapURL:hotVideoModel.wapurl];
                } else{
                    NSLog(@"HotVideoCell的代理没有响应，%lu", imageBtn.tag);
                }
                break;
            case 101:
                NSLog(@"1");
                if ([self.delegate respondsToSelector:@selector(turePageToVideoVCWithTag:andWapURL:)]) {
                    HotVideoModel * hotVideoModel = _videoModelArr[1];
                    [self.delegate turePageToVideoVCWithTag:imageBtn.tag andWapURL:hotVideoModel.wapurl];
                } else{
                    NSLog(@"HotVideoCell的代理没有响应，%lu", imageBtn.tag);
                }
                break;
            case 102:
                NSLog(@"2");
                if ([self.delegate respondsToSelector:@selector(turePageToVideoVCWithTag:andWapURL:)]) {
                    HotVideoModel * hotVideoModel = _videoModelArr[2];
                    [self.delegate turePageToVideoVCWithTag:imageBtn.tag andWapURL:hotVideoModel.wapurl];
                } else{
                    NSLog(@"HotVideoCell的代理没有响应，%lu", imageBtn.tag);
                }
                break;
            case 103:
                NSLog(@"3");
                if ([self.delegate respondsToSelector:@selector(turePageToVideoVCWithTag:andWapURL:)]) {
                    HotVideoModel * hotVideoModel = _videoModelArr[3];
                    [self.delegate turePageToVideoVCWithTag:imageBtn.tag andWapURL:hotVideoModel.wapurl];
                } else{
                    NSLog(@"HotVideoCell的代理没有响应，%lu", imageBtn.tag);
                }
                break;
            default:
                break;
        }
    } else{
        NSLog(@"没有数据，按钮无法点击....");
    }
    
    
}

- (void)setVideoModelArr:(NSArray *)videoModelArr{
   
    _videoModelArr = videoModelArr;
    
//    NSLog(@"%lu", _videoModelArr.count);
    // 设置数据
    if (_videoModelArr.count > 0) {
        [self setData];
    } else{
        NSLog(@"没有数据...");
    }
}
// 设置数据
- (void)setData{
    
    for (int i = 0; i < self.btnArray.count; i ++) {
        // 最后0会改成i
        // 图片
        HotVideoModel * videoModel = _videoModelArr[i];
        UIImageView * imageBtn = self.btnArray[i];
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:videoModel.picname] placeholderImage:[UIImage imageNamed:@"123"]];
        
        // 标题
        UILabel * titleLbl = self.titleArray[i];
        titleLbl.text = videoModel.title;
//        titleLbl.text = @"dsjlakfjalajflasjlfas;fskfj;slfa;jflks";
        [titleLbl sizeToFit];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // redView
    _redView.frame = CGRectMake(Margin20 * IPHONE6_W_SCALE, 28 / 2 * IPHONE6_H_SCALE, 8/2*IPHONE6_W_SCALE, Margin32 * IPHONE6_H_SCALE);

    // 热门专辑的label
    CGFloat hotLblX = CGRectGetMaxX(_redView.frame) + 18 / 2 * IPHONE6_W_SCALE;
    CGFloat hotLblY = 26 / 2 * IPHONE6_H_SCALE;
    
    NSMutableDictionary * hotLblDic = [NSMutableDictionary dictionary];
    hotLblDic[NSFontAttributeName] = Font16;
    CGSize hotLblSize = [_hotLbl.text sizeWithAttributes:hotLblDic];
    
    _hotLbl.frame = (CGRect){{hotLblX, hotLblY}, hotLblSize};
    
    // 更多内容按钮
    // 图片
    [_nextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(Margin32 * IPHONE6_H_SCALE);
        make.right.equalTo(self.mas_right).offset(-Margin20 * IPHONE6_W_SCALE);
        make.width.equalTo(@(12 / 2 * IPHONE6_W_SCALE));
        make.height.equalTo(@(21 / 2 * IPHONE6_H_SCALE));
    }];
    // 文字
    [_moreLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nextView.mas_top).offset(-1);
        make.right.equalTo(_nextView.mas_left).offset(-Margin14 * IPHONE6_W_SCALE);
        make.height.equalTo(@(12 * IPHONE6_H_SCALE));
        make.width.equalTo(@(100 * IPHONE6_H_SCALE));
    }];
    // 按钮
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moreLbl.mas_left).offset(-10);
        make.top.equalTo(_moreLbl.mas_top).offset(-10);
        make.right.equalTo(_nextView.mas_right).offset(10);
        make.bottom.equalTo(_nextView.mas_bottom).offset(10);
    }];
    
    
    for (int i = 0; i < self.btnArray.count; i ++) {
        UIImageView * imageBtn = self.btnArray[i];
        CGFloat btnX = Margin20 * IPHONE6_W_SCALE;
        CGFloat btnY = CGRectGetMaxY(_redView.frame) + Margin24 * IPHONE6_H_SCALE;
        CGFloat btnW = 346 / 2 * IPHONE6_W_SCALE;
        CGFloat btnH = 196 / 2 * IPHONE6_W_SCALE;
        //        imageBtn.backgroundColor = [UIColor redColor];
        int j = i % 2;
        int k = i / 2;
        imageBtn.frame = CGRectMake(btnX + j *(btnW + 18 / 2 * IPHONE6_W_SCALE), btnY + k * (btnH + 95/2 * IPHONE6_H_SCALE), btnW, btnH);

        if (_videoModelArr && _videoModelArr.count > 0) {
            HotVideoModel * videoModel = _videoModelArr[i];
            UILabel * titleLbl = self.titleArray[i];
            CGFloat titleX = btnX + j *(btnW + 18 / 2 * IPHONE6_W_SCALE);
            CGFloat titleY = CGRectGetMaxY(imageBtn.frame) + Margin14 * IPHONE6_H_SCALE;
            CGFloat titleW = btnW;
            NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
            titleDic[NSFontAttributeName] = Font13;
            CGRect titleRect = [videoModel.title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
            titleLbl.frame = (CGRect){{titleX, titleY}, titleRect.size};
        }
        
//        titleLbl.frame = CGRectMake(titleX, titleY, btnW, 30);
//        [titleLbl sizeToFit];
    }
    
    // 分割线
    CGFloat separateX = 0;
    CGFloat separateY = 660 / 2 * IPHONE6_H_SCALE;
    CGFloat separateW = WIDTH;
    CGFloat separateH = Margin20 * IPHONE6_H_SCALE;
    _separateView.frame = CGRectMake(separateX, separateY, separateW, separateH);
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
