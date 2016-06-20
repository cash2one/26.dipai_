//
//  TwoBtnCell.m
//  dipai
//
//  Created by 梁森 on 16/6/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "TwoBtnCell.h"
#import "HotVideoModel.h"

#import "UIImageView+WebCache.h"
@interface TwoBtnCell()

@property (nonatomic, strong) NSMutableArray * btnArray;

@property (nonatomic, strong) NSMutableArray * titleArray;

@property (nonatomic, strong) UIButton * btn;

@end

@implementation TwoBtnCell

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
    
    
    
    for (int i = 0; i < 2; i ++) {
        UIImageView * imageBtn = [[UIImageView alloc] init];
        imageBtn.backgroundColor = [UIColor redColor];
        imageBtn.tag = i + 100;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        imageBtn.userInteractionEnabled = YES;
        [imageBtn addGestureRecognizer:tap];
        
        [self addSubview:imageBtn];
        // 将四个按钮（UIImageView）装到按钮数组中
        [self.btnArray addObject:imageBtn];
        
        // 图片的标题
        UILabel * titleLbl = [[UILabel alloc] init];
        titleLbl.numberOfLines = 0;
        titleLbl.font = Font13;
        
        [self addSubview:titleLbl];
        //
        [self.titleArray addObject:titleLbl];
    }
}

#pragma mark ---- 为图片添加的点击事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIImageView * imageBtn = (UIImageView *)tap.view;
    
    if (_modelArr.count == 2) {
        HotVideoModel * model1 = [_modelArr objectAtIndex:0];
        NSString * wapurl1 = model1.wapurl;
        HotVideoModel * model2 = [_modelArr objectAtIndex:1];
        NSString * wapurl2 = model2.wapurl;
        switch (imageBtn.tag) {
            case 100:
                
                if ([self.delegate respondsToSelector:@selector(tableViewCell:DidClickWithURL:)]) {
                    [self.delegate tableViewCell:self DidClickWithURL:wapurl1];
                } else{
                    NSLog(@"TwoBtnCell的代理没有响应1");
                }
                break;
            case 101:
                if ([self.delegate respondsToSelector:@selector(tableViewCell:DidClickWithURL:)]) {
                    [self.delegate tableViewCell:self DidClickWithURL:wapurl2];
                } else{
                    NSLog(@"TwoBtnCell的代理没有响应1");
                }
                break;
                
            default:
                break;
        }
    } else{
        HotVideoModel * model1 = [_modelArr objectAtIndex:0];
        NSString * wapurl1 = model1.wapurl;
        if ([self.delegate respondsToSelector:@selector(tableViewCell:DidClickWithURL:)]) {
            [self.delegate tableViewCell:self DidClickWithURL:wapurl1];
        } else{
            NSLog(@"TwoBtnCell的代理没有响应1");
        }
    }
    
    
}

- (void)setModelArr:(NSArray *)modelArr{
    _modelArr = modelArr;
    
    // 设置数据
    [self setData];
    
}
#pragma mark --- 设置数据
- (void)setData{

    for (int i = 0; i < _modelArr.count; i ++) {
        if (_modelArr.count == 1) { // 如果数组中只有一个数据
            HotVideoModel * videoModel = _modelArr[0];
            UIImageView * imageBtn = self.btnArray[i];
            [imageBtn sd_setImageWithURL:[NSURL URLWithString:videoModel.picname] placeholderImage:[UIImage imageNamed:@"123"]];
            
            // 标题
            UILabel * titleLbl = self.titleArray[i];
            titleLbl.text = videoModel.title;
            [titleLbl sizeToFit];
        } else{ // 如果有两个数据
            HotVideoModel * videoModel = _modelArr[i];
            UIImageView * imageBtn = self.btnArray[i];
            [imageBtn sd_setImageWithURL:[NSURL URLWithString:videoModel.picname] placeholderImage:[UIImage imageNamed:@"123"]];
            
            // 标题
            UILabel * titleLbl = self.titleArray[i];
            titleLbl.text = videoModel.title;
            [titleLbl sizeToFit];
        }
        
    }
  
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i = 0; i < _modelArr.count; i ++) {
        UIImageView * imageBtn = self.btnArray[i];
        CGFloat btnX = Margin20 * IPHONE6_W_SCALE;
        CGFloat btnY = 0;
        CGFloat btnW = 346 / 2 * IPHONE6_W_SCALE;
        CGFloat btnH = 196 / 2 * IPHONE6_H_SCALE;
        imageBtn.backgroundColor = [UIColor redColor];
        int j = i % 2;
        imageBtn.frame = CGRectMake(btnX + j *(btnW + 18 / 2 * IPHONE6_W_SCALE), btnY, btnW, btnH);
        
        UILabel * titleLbl = self.titleArray[i];
        CGFloat titleX = btnX + j *(btnW + 18 / 2 * IPHONE6_W_SCALE);
        CGFloat titleY = CGRectGetMaxY(imageBtn.frame) + Margin14 * IPHONE6_H_SCALE;
        titleLbl.frame = CGRectMake(titleX, titleY, btnW, 30);
        [titleLbl sizeToFit];
    }
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
