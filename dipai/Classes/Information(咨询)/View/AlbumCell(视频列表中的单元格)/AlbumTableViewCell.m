//
//  AlbumTableViewCell.m
//  dipai
//
//  Created by 梁森 on 16/6/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AlbumTableViewCell.h"
#import "AlbumModel.h"


#import "UIImageView+WebCache.h"
@interface AlbumTableViewCell()

@end

@implementation AlbumTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * cellID = @"cell";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
                NSLog(@"...");
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:27 / 255.0 green:27 / 255.0 blue:27 / 255.0 alpha:1];
        
        // 添加子控件
        [self setUpChildView];
    }
    return self;
}
#pragma mark --- 设置子控件
- (void)setUpChildView{
    // 图片
    UIImageView * picView = [[UIImageView alloc] init];
    [self addSubview:picView];
    //    picView.backgroundColor = [UIColor redColor];
    _picView = picView;
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.textColor = Color123;
    //    titleLbl.backgroundColor = [UIColor greenColor];
    titleLbl.font = Font16;
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
}

#pragma mark --- 重写Album Model的set方法
- (void)setAlbumModel:(AlbumModel *)albumModel{
    _albumModel = albumModel;
//    NSLog(@"传递过来的视频模型----%@", _albumModel);
    
    // 设置数据
    [self setData];
    
    // 设置大小
    [self setFrame];
    
}

#pragma mark --- 设置数据
- (void)setData{
    // 图片
    NSURL * url = [NSURL URLWithString:_albumModel.picname];
    [_picView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"123"]];
    
    // 标题
    _titleLbl.text = _albumModel.title;
}

#pragma mark --- 设置大小
- (void)setFrame{
    // 图片
    CGFloat picX = Margin30 * IPHONE6_W_SCALE;
    CGFloat picY = 18 / 2 * IPHONE6_H_SCALE;
    CGFloat picW = 178 / 2 * IPHONE6_W_SCALE;
    CGFloat picH = 134 / 2 * IPHONE6_H_SCALE;
    _picView.frame = CGRectMake(picX, picY, picW, picH);
    
    // 标题
    CGFloat titleX = CGRectGetMaxX(_picView.frame) + 28 / 2 * IPHONE6_W_SCALE;
    CGFloat titleY = Margin24 * IPHONE6_H_SCALE;
    CGFloat titleW = WIDTH - titleX - Margin30 * IPHONE6_W_SCALE;
    
    NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
    titleDic[NSFontAttributeName] = Font16;
    CGRect titleRect = [_titleLbl.text boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
    _titleLbl.frame = (CGRect){{titleX, titleY}, titleRect.size};
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
