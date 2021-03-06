//
//  LiveCell.m
//  dipai
//
//  Created by 梁森 on 16/6/22.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "LiveCell.h"

#import "LiveInfoModel.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface LiveCell()
// 左侧竖线
@property (nonatomic, strong) UIView * leftLine;
// 非精彩牌局的左侧竖线
@property (nonatomic, strong) UIView * feLfLine;
// 红点
@property (nonatomic, strong) UIView * redView;
// 直播员姓名
@property (nonatomic, strong) UILabel * nameLbl;
// 直播员
@property (nonatomic, strong) UILabel * zhiboLbl;
// 赛事内容
@property (nonatomic, strong) UILabel * bodyLbl;

// 非精彩牌局的图片
@property (nonatomic, strong) UIImageView * feImage;

// 图片
@property (nonatomic, strong) UIImageView * image;
// 分享图片
@property (nonatomic, strong) UIButton * sharePic;
// 标题
@property (nonatomic, strong) UILabel * titleLbl;
// 精彩牌局
@property (nonatomic, strong) UILabel * goodLbl;
// 背景图
@property (nonatomic, strong) UIView * backView;
// 精彩牌局中的内容
@property (nonatomic, strong) UILabel * contentLbl;

@end

@implementation LiveCell

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


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 设置子控件
        [self setUpChildControl];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

#pragma mark --- 设置子控件
- (void)setUpChildControl{
    
    // 左侧竖线
    UIView * leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor colorWithRed:229 / 255.f green:229 / 255.f blue:229 / 255.f alpha:1];
//    leftLine.backgroundColor = [UIColor blackColor];
    [self addSubview:leftLine];
    _leftLine = leftLine;
    
    UIView * feLfLine = [[UIView alloc] init];
    feLfLine.backgroundColor = [UIColor colorWithRed:229 / 255.f green:229 / 255.f blue:229 / 255.f alpha:1];
//    leftLine.backgroundColor = [UIColor blackColor];
    [self addSubview:feLfLine];
    _feLfLine = feLfLine;
    
    // 小红点
    UIView * redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    redView.layer.masksToBounds = YES;
    redView.layer.cornerRadius = 3 * IPHONE6_W_SCALE;
    [self addSubview:redView];
    _redView = redView;
    
    // 直播员姓名
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.textColor = [UIColor redColor];
    nameLbl.font = Font12;
    [self addSubview:nameLbl];
    _nameLbl = nameLbl;
    
    // 直播员
    UILabel * zhiboLbl = [[UILabel alloc] init];
    zhiboLbl.text = @"直播员";
    zhiboLbl.font = Font10;
    zhiboLbl.textColor = Color153;
    [self addSubview:zhiboLbl];
    _zhiboLbl = zhiboLbl;
    
    // 赛事内容
    UILabel * bodyLbl = [[UILabel alloc] init];
    bodyLbl.numberOfLines = 0;
    bodyLbl.font = Font14;
    [self addSubview:bodyLbl];
    _bodyLbl = bodyLbl;
    // 非精彩牌局图片
    UIImageView * feImage = [[UIImageView alloc] init];
    [self addSubview:feImage];
    UITapGestureRecognizer * feTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPic)];
    [feImage addGestureRecognizer:feTap];
    feImage.userInteractionEnabled = YES;
    _feImage = feImage;
    
    /****精彩牌局****/
    // 背景图片
    UIView * backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:255 / 255.F green:248 / 255.F blue:248 / 255.F alpha:1];
    backView.layer.borderWidth = 0.5;
    backView.layer.borderColor = [[UIColor colorWithRed:216 / 255.f green:216 / 255.f blue:216 / 255.f alpha:1] CGColor];
    [self addSubview:backView];
    _backView = backView;
    // 分享图片
    UIButton * sharePic = [[UIButton alloc] init];
    [sharePic setBackgroundImage:[UIImage imageNamed:@"zhuanfa"] forState:UIControlStateNormal];
    [sharePic addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:sharePic];
    _sharePic = sharePic;
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = Font14;
    [_backView addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    // 内容
    UILabel * contentLbl = [[UILabel alloc] init];
    contentLbl.numberOfLines = 0;
    contentLbl.font = Font12;
    contentLbl.textColor = Color123;
    [_backView addSubview:contentLbl];
    _contentLbl = contentLbl;
    
    
    // 精彩牌局标识
    UILabel * goodLbl = [[UILabel alloc] init];
    goodLbl.text = @"精彩牌局";
    goodLbl.textAlignment = NSTextAlignmentCenter;
    goodLbl.font = Font12;
    goodLbl.textColor = [UIColor whiteColor];
    goodLbl.backgroundColor = [UIColor redColor];
    [_backView addSubview:goodLbl];
    _goodLbl = goodLbl;
    
    // 图片
    UIImageView * image = [[UIImageView alloc] init];
//    image.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPic)];
    [image addGestureRecognizer:tap];
    image.userInteractionEnabled = YES;
    [_backView addSubview:image];
    _image = image;

}

#pragma mark --- 分享事件
- (void)shareAction{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickShareWithModel:)]) {
        [self.delegate tableViewCell:self didClickShareWithModel:_liveInfoModel];
    }else{
        NSLog(@"LiveCell的代理没有响应");
    }
}
#pragma mark --- 显示大图
- (void)showBigPic{
    
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickPicWithModel:)]) {
        [self.delegate tableViewCell:self didClickPicWithModel:_liveInfoModel];
    }else{
    
        NSLog(@"代理没有响应...");
    }
}

- (void)setLiveInfoModel:(LiveInfoModel *)liveInfoModel{
    
    _liveInfoModel = liveInfoModel;
//    NSLog(@"%@", _liveInfoModel);
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    if (_liveInfoModel.title && _liveInfoModel.title.length > 0) { // 精彩牌局
        
        _bodyLbl.hidden = YES;  // 隐藏非精彩赛事的内容
        _feImage.hidden = YES;  // 隐藏非精彩牌局的图片
        _feLfLine.hidden = YES; // 隐藏非精彩牌局的左侧竖线
        _leftLine.hidden = NO;  // 显示精彩牌局的左侧竖线
        
        // 红点
        CGFloat redX = 15.5 * IPHONE6_W_SCALE;
        CGFloat redY = 16 * IPHONE6_H_SCALE;
        CGFloat redW = 5 * IPHONE6_W_SCALE;
        CGFloat redH = redW;
        _redView.frame = CGRectMake(redX, redY, redW, redH);
        
        // 直播员
        CGFloat nameX = CGRectGetMaxX(_redView.frame) + 11 * IPHONE6_H_SCALE;
        CGFloat nameY = 14 * IPHONE6_W_SCALE;
        CGFloat nameW = 100;
        CGFloat nameH = 12 * IPHONE6_W_SCALE;
        _nameLbl.frame = CGRectMake(nameX, nameY, nameW, nameH);
        _nameLbl.text = _liveInfoModel.username;
        [_nameLbl sizeToFit];
        
        // 显示直播员
        CGFloat zhiboX = CGRectGetMaxX(_nameLbl.frame) + 11 * IPHONE6_W_SCALE;
        CGFloat zhiboY = 16.5 * IPHONE6_H_SCALE;
        CGFloat zhiboW = WIDTH - zhiboX;
        CGFloat zhiboH = 10 * IPHONE6_W_SCALE;
        _zhiboLbl.frame = CGRectMake(zhiboX, zhiboY, zhiboW, zhiboH);
//        _zhiboLbl.backgroundColor = [UIColor redColor];
        /****精彩牌局****/
        
        CGFloat contentW = WIDTH - 77 * IPHONE6_W_SCALE;
        NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
        contentDic[NSFontAttributeName] = Font12;
        CGRect contentRect = [_liveInfoModel.body boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil];
        
         // 背景图片
        if (_liveInfoModel.imgs) {  // 如果有图片
            CGFloat backY = CGRectGetMaxY(_nameLbl.frame) + 9 * IPHONE6_H_SCALE;
            CGFloat backW = WIDTH - nameX - 15 * IPHONE6_W_SCALE;
            CGFloat backH = 94 * IPHONE6_H_SCALE + contentRect.size.height + 216*0.5*IPHONE6_W_SCALE;
            _backView.frame = CGRectMake(nameX, backY, backW, backH);
        }else{
            CGFloat backY = CGRectGetMaxY(_nameLbl.frame) + 9 * IPHONE6_H_SCALE;
            CGFloat backW = WIDTH - nameX - 15 * IPHONE6_W_SCALE;
            CGFloat backH = 94 * IPHONE6_H_SCALE + contentRect.size.height -10 * IPHONE6_H_SCALE;
            _backView.frame = CGRectMake(nameX, backY, backW, backH);
        }
        _backView.hidden = NO;
        
        
        // 左侧竖线
        CGFloat lineX = 35 * 0.5 * IPHONE6_W_SCALE;
        CGFloat lineY = 0;
        CGFloat lineW = 1 * IPHONE6_W_SCALE;
        CGFloat lineH = CGRectGetMaxY(_backView.frame) + 24 * IPHONE6_H_SCALE;
        _leftLine.frame = CGRectMake(lineX, lineY, lineW, lineH);
//        _leftLine.backgroundColor = [UIColor greenColor];
        // 分享图片
        [_sharePic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_backView.mas_right).offset(-11 * IPHONE6_W_SCALE);
            make.top.equalTo(_backView.mas_top).offset(10 * IPHONE6_H_SCALE);
            make.width.equalTo(@(23 * IPHONE6_W_SCALE));
            make.height.equalTo(@(21 * IPHONE6_W_SCALE));
        }];
        
        
        // 精彩牌局标识
        [_goodLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left);
            make.top.equalTo(_backView.mas_top).offset(9 * IPHONE6_H_SCALE);
            make.width.equalTo(@(134 * 0.5 * IPHONE6_W_SCALE));
            make.height.equalTo(@(22 * IPHONE6_H_SCALE));
        }];
        
        // 标题
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(15 * IPHONE6_W_SCALE);
            make.top.equalTo(_goodLbl.mas_bottom).offset(14 * IPHONE6_H_SCALE);
            make.width.equalTo(@(WIDTH - 154 * 0.5 * IPHONE6_W_SCALE));
            make.height.equalTo(@(14 * IPHONE6_H_SCALE));
        }];
        _titleLbl.text = _liveInfoModel.title;
        
        // 内容
        CGFloat contentX = 15 * IPHONE6_W_SCALE;
        CGFloat contentY = 138 * 0.5 * IPHONE6_H_SCALE;
        _contentLbl.frame = (CGRect){{contentX, contentY}, contentRect.size};
        _contentLbl.text = _liveInfoModel.body;
        
        // 图片
        if (_liveInfoModel.imgs) {  // 如果有图片
            _image.hidden = NO; // 不隐藏图片
            [_image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_backView.mas_left).offset(15 * IPHONE6_W_SCALE);
                make.top.equalTo(_contentLbl.mas_bottom).offset(10 *IPHONE6_H_SCALE);
                make.width.equalTo(@(150 * IPHONE6_W_SCALE));
                make.height.equalTo(@(216 *  0.5 * IPHONE6_W_SCALE));
            }];
            [_image sd_setImageWithURL:[NSURL URLWithString:_liveInfoModel.imgs[@"pimg2"]] placeholderImage:[UIImage imageNamed:@"123"]];
//            _image.contentMode = UIViewContentModeScaleAspectFill;
//            _image.backgroundColor = [UIColor redColor];
        }else{
            _image.hidden = YES;    // 隐藏图片
        }
        
        
    }else{  // 非精彩牌局
        
        _bodyLbl.hidden = NO;   // 显示非精彩赛事的内容
        _backView.hidden = YES;// 隐藏精彩牌局的背景图
        _feImage.hidden = NO;   // 显示非精彩牌局的图片
        _feLfLine.hidden = NO;  // 显示非精彩牌局的左侧竖线
        _leftLine.hidden = YES; // 隐藏精彩牌局的左侧竖线
        
        // 红点
        CGFloat redX = 15 * IPHONE6_W_SCALE;
        CGFloat redY = 16 * IPHONE6_H_SCALE;
        CGFloat redW = 5 * IPHONE6_W_SCALE;
        CGFloat redH = redW;
        _redView.frame = CGRectMake(redX, redY, redW, redH);
        
        // 直播员
        CGFloat nameX = CGRectGetMaxX(_redView.frame) + 11 * IPHONE6_H_SCALE;
        CGFloat nameY = 14 * IPHONE6_W_SCALE;
        CGFloat nameW = 100;
        CGFloat nameH = 12 * IPHONE6_W_SCALE;
        _nameLbl.frame = CGRectMake(nameX, nameY, nameW, nameH);
        _nameLbl.text = _liveInfoModel.username;
        [_nameLbl sizeToFit];
        
        // 显示直播员
        CGFloat zhiboX = CGRectGetMaxX(_nameLbl.frame) + 11 * IPHONE6_W_SCALE;
        CGFloat zhiboY = 14.5 * IPHONE6_H_SCALE;
        CGFloat zhiboW = WIDTH - zhiboX;
        CGFloat zhiboH = 10 * IPHONE6_W_SCALE;
        _zhiboLbl.frame = CGRectMake(zhiboX, zhiboY, zhiboW, zhiboH);
        // 赛事内容
        CGFloat bodyX = nameX;
        CGFloat bodyY = CGRectGetMaxY(_nameLbl.frame) + 9 * IPHONE6_H_SCALE;
        CGFloat bodyW = WIDTH - bodyX - 15 * IPHONE6_W_SCALE;
        
        NSMutableDictionary * bodyDic = [NSMutableDictionary dictionary];
        bodyDic[NSFontAttributeName] = Font14;
        CGRect bodyRect = [_liveInfoModel.body boundingRectWithSize:CGSizeMake(bodyW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:bodyDic context:nil];
        _bodyLbl.frame = (CGRect){{bodyX, bodyY}, bodyRect.size};
        _bodyLbl.text = _liveInfoModel.body;
        
        
        CGFloat lineH;
        // 图片
        if (_liveInfoModel.imgs) {
            _feImage.hidden = NO;   // 图片不隐藏
            CGFloat imageX = nameX;
            CGFloat imageY = CGRectGetMaxY(_bodyLbl.frame) + 10 * IPHONE6_H_SCALE;
            CGFloat imageW = 150 * IPHONE6_W_SCALE;
            CGFloat imageH = 216 * 0.5 * IPHONE6_W_SCALE;
            _feImage.frame = CGRectMake(imageX, imageY, imageW, imageH);
            lineH = CGRectGetMaxY(_feImage.frame) + 15 * IPHONE6_H_SCALE;
            [_feImage sd_setImageWithURL:[NSURL URLWithString:_liveInfoModel.imgs[@"pimg2"]] placeholderImage:[UIImage imageNamed:@"123"]];
        }else{
            // 图片隐藏
            _feImage.hidden = YES;
            lineH = CGRectGetMaxY(_bodyLbl.frame) + 24 * IPHONE6_H_SCALE;
        }
        
//        NSLog(@"%f", lineH);
        // 左侧竖线
        CGFloat lineX = 35 * 0.5 * IPHONE6_W_SCALE;
        CGFloat lineY = 0;
        CGFloat lineW = 1 * IPHONE6_W_SCALE;
        
        _feLfLine.frame = CGRectMake(lineX, lineY, lineW, lineH);
//        _feLfLine.backgroundColor = [UIColor blackColor];
    }
    
}

- (void)setFrame{
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
