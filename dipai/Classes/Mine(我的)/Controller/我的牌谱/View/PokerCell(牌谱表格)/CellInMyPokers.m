//
//  CellInMyPokers.m
//  dipai
//
//  Created by 梁森 on 16/9/9.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CellInMyPokers.h"

#import "ModelOfPoker.h"
#import "ModelInPoker.h"

#import "Masonry.h"

#import "UIImageView+WebCache.h"

@interface CellInMyPokers()
{
    
    NSInteger _id;
}
@property (nonatomic, strong) UIView * redLine;

// 红点
@property (nonatomic, strong) UIView * redPoint;

// 日期标签
@property (nonatomic, strong) UILabel * dateLbl;

@property (nonatomic, strong) UIImageView * dateV;

@property (nonatomic, strong) NSMutableArray * picVArr;
/**
 *  按钮数组
 */
@property (nonatomic, strong) NSMutableArray * btnArr;

@property (nonatomic, strong) NSMutableArray * idArr;

@end

@implementation CellInMyPokers

- (NSMutableArray *)picVArr{
    
    if (_picVArr == nil) {
        _picVArr = [NSMutableArray array];
    }
    return _picVArr;
}

- (NSMutableArray *)btnArr{
    
    if (_btnArr == nil) {
        _btnArr = [NSMutableArray array];
    }
    
    return _btnArr;
}

- (NSMutableArray *)idArr{
    
    if (_idArr == nil) {
        _idArr = [NSMutableArray array];
    }
    return _idArr;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
//    NSLog(@"创建新的单元格");
//    NSInteger row = indexPath.row;
//    NSString * cellID = [NSString stringWithFormat:@"%lu",row*10];
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpChildControl];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}


- (void)setPresent:(NSString *)present{
    
    _present = present;
    if (_present.length > 0) {
        for (UIButton * btn in self.btnArr) {
            btn.hidden = NO;
        }
    }
}

- (void)setModel:(ModelOfPoker *)model{
    
    _model = model;
    
//    NSLog(@"%lu", model.rows.count);
//    NSLog(@"2ci:%lu", _didRow);
    
    
//    NSString * date = [[NSUserDefaults standardUserDefaults]objectForKey:Date];
    
//    NSLog(@"date:%@", date);
//    if (_didRow != 0) {
//        
//        if ([date isEqualToString:_model.name]) {
//            _redPoint.hidden = YES;
//            _dateV.hidden = YES;
//            _dateLbl.hidden = YES;
//            for (int i = 0; i < _model.rows.count; i ++) {
//                
//            }
//        }else{
//            _redPoint.hidden = NO;
//            _dateV.hidden = NO;
//            _dateLbl.hidden = NO;
//        }
//        
//    }else{
//        
//        _redPoint.hidden = NO;
//        _dateV.hidden = NO;
//        _dateLbl.hidden = NO;
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:_model.name forKey:Date];
    
    _dateLbl.text = model.name;
    for (UIImageView * imageV in self.picVArr) {
        [imageV removeFromSuperview];
    }
    [self.picVArr removeAllObjects];
    
    
    for (int i = 0; i < _model.rows.count; i ++) {
        ModelInPoker * pModel = [_model.rows objectAtIndex:i];
        UIImageView * picV = [[UIImageView alloc] init];
        picV.clipsToBounds = YES;
        picV.contentMode = UIViewContentModeScaleAspectFill;
        
//        picV.layer.masksToBounds = YES;
//        picV.layer.cornerRadius = 4;
        
        [picV sd_setImageWithURL:[NSURL URLWithString:pModel.picname]];
        [self.picVArr addObject:picV];
        
        [self.idArr addObject:pModel.iD];
        
        picV.tag = i;
        picV.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPics:)];
        tap.numberOfTapsRequired = 1;
        [picV addGestureRecognizer:tap];
        
//        if (_present.length > 0) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;    // 按钮的tag和UIImageView的tag是一样的
            [picV addSubview:btn];
            [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"image_unselect@3x"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"image_selected@3x"] forState:UIControlStateSelected];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(picV.mas_top);
                make.right.equalTo(picV.mas_right);
                make.width.equalTo(@(30 * IPHONE6_W_SCALE));
                make.height.equalTo(@(30 * IPHONE6_W_SCALE));
            }];
            
            [self.btnArr addObject:btn];
        btn.hidden = YES;
//        }
        
    }
}

- (void)buttonClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    
//    NSLog(@"按钮的tag:%lu", sender.tag);
    
    UIImageView * picV = [[UIImageView alloc] init];
    for (UIImageView * pic in self.picVArr) {
        if (pic.tag == sender.tag) {
            picV = pic;
        }
    }
    
    NSInteger iD = [[self.idArr objectAtIndex:picV.tag] integerValue];
    
//    NSLog(@"图片ID%lu", iD);
    
    ModelInPoker * model = [_model.rows objectAtIndex:picV.tag];
    
    //因为冲用的问题,不能根据选中状态来记录
    if (sender.selected == YES) {//选中了记录
        NSLog(@"选中...");
        [sender setImage:[UIImage imageNamed:@"image_selected@3x"] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(tableViewCell:withImage:withPicId:withModel:)]) {
            [self.delegate tableViewCell:self withImage:picV.image withPicId:iD withModel:model];
        }else{
            
            NSLog(@"CellInMyPokers的代理没有响应...");
        }
    }else{//否则移除记录
        NSLog(@"mei选中...");
        [sender setImage:[UIImage imageNamed:@"image_unselect@3x"] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(tableViewCell:withImage:withPicId:withModel:)]) {
            [self.delegate tableViewCell:self withImage:picV.image withPicId:iD withModel:model];
        }else{
            
            NSLog(@"CellInMyPokers的代理没有响应...");
        }
    }
    
    
}


- (void)showPics:(UITapGestureRecognizer *)tap{
    
    UIImageView * picV = (UIImageView *)tap.view;
    NSInteger tag = picV.tag;
    
//    NSLog(@"kan%lu---%lu", tag, _didRow);
    
    if ([self.delegate respondsToSelector:@selector(tableViewCell:withTag:withDidRow:)]) {
        [self.delegate tableViewCell:self withTag:tag withDidRow:_didRow];
    }else{
        
        NSLog(@"CellInMyPokers的代理没有响应...");
    }
}

- (void)setUpChildControl{
    
    // 左侧竖线
    UIView * redLine = [[UIView alloc] init];
    redLine.backgroundColor = [UIColor redColor];
    [self addSubview:redLine];
    _redLine = redLine;
    
    // 红点
    UIView * redPoint = [[UIView alloc] init];
    redPoint.backgroundColor = [UIColor redColor];
    redPoint.layer.masksToBounds = YES;
    redPoint.layer.cornerRadius = 2.5 * IPHONE6_W_SCALE;
    [self addSubview:redPoint];
    _redPoint = redPoint;
    
   
    
    UIImageView * dateV = [[UIImageView alloc] init];
    dateV.image = [UIImage imageNamed:@"biaoqian"];
    [self addSubview:dateV];
    _dateV = dateV;
    // 日期标签
    UILabel * dateLbl = [[UILabel alloc] init];
    dateLbl.font = Font11;
    dateLbl.textColor = [UIColor whiteColor];
    dateLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dateLbl];
    _dateLbl = dateLbl;
    
}

- (void)setSelectedPokerId:(NSMutableArray *)selectedPokerId{
    
    _selectedPokerId = selectedPokerId;
    
    for (int i = 0; i < self.picVArr.count; i ++) {
        ModelInPoker * model = [_model.rows objectAtIndex:i];
        UIImageView * imageV = self.picVArr[i];
        
        for (NSString * iD in _selectedPokerId) {
            if ([iD isEqualToString:model.iD]) {
                for (UIButton * btn in self.btnArr) {
                    
                    if (btn.tag == imageV.tag) {
                        [btn setImage:[UIImage imageNamed:@"image_selected@3x"] forState:UIControlStateNormal];
                    }
                }
                
            }
        }
        
    }
    
}

- (void)setSelectedPokerArr:(NSMutableArray *)selectedPokerArr{
    

}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_redLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(1));
    }];
    
    [_dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_redLine.mas_right).offset(11 * IPHONE6_W_SCALE);
        make.top.equalTo(self.mas_top).offset(14 * IPHONE6_H_SCALE);
        make.width.equalTo(@(83 * IPHONE6_W_SCALE));
        make.height.equalTo(@(22 * IPHONE6_W_SCALE));
    }];
    [_dateV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dateLbl.mas_left);
        make.top.equalTo(_dateLbl.mas_top);
        make.right.equalTo(_dateLbl.mas_right);
        make.bottom.equalTo(_dateLbl.mas_bottom);
    }];
    
    [_redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_dateLbl.mas_centerY);
        make.centerX.equalTo(_redLine.mas_centerX);
        make.width.equalTo(@(5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(5 * IPHONE6_W_SCALE));
    }];
    
    
    for (int i = 0; i < _model.rows.count; i ++) {
        UIImageView * picV = [self.picVArr objectAtIndex:i];
        int k = i % 4;
        int j = i / 4;
        
//        if (_dateLbl.hidden == YES) {
//            picV.frame = CGRectMake(47 * 0.5 * IPHONE6_W_SCALE + k * (171 * 0.5 * IPHONE6_W_SCALE), -10 * IPHONE6_H_SCALE + j * (170 * 0.5 * IPHONE6_W_SCALE), 80 * IPHONE6_W_SCALE, 80 * IPHONE6_W_SCALE);
//        }else{
        
            picV.frame = CGRectMake(47 * 0.5 * IPHONE6_W_SCALE + k * (171 * 0.5 * IPHONE6_W_SCALE), 94 *0.5 * IPHONE6_H_SCALE + j * (170 * 0.5 * IPHONE6_W_SCALE), 80 * IPHONE6_W_SCALE, 80 * IPHONE6_W_SCALE);
//        }
        
        
        
        [self addSubview:picV];
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
