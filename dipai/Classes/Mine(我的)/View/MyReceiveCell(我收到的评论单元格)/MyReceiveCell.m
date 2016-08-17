//
//  MyReceiveCell.m
//  dipai
//
//  Created by 梁森 on 16/7/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyReceiveCell.h"

// 收到评论的模型
#import "MyReceiveModel.h"

#import "Masonry.h"
@interface MyReceiveCell()

// 用户名
@property (nonatomic, strong) UILabel * nameLbl;
// 点击用户名的按钮
@property (nonatomic, strong) UIButton * nameBtn;

// 回复内容的类型  三种类型：帖子、评论、回复
@property (nonatomic, strong) UILabel * typeLbl;

// 回复的标题
@property (nonatomic, strong) UILabel * titleLbl;

// 回复的内容
@property (nonatomic, strong) UILabel * contentLbl;

// 回复时间
@property (nonatomic, strong) UILabel * timeLbl;
// 分割线
@property (nonatomic, strong) UIView * separateView;
@end

@implementation MyReceiveCell


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
    
    // 用户名
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.font = Font15;
    nameLbl.textColor = Color178;
    [self addSubview:nameLbl];
    _nameLbl = nameLbl;
    
    UIButton * nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameBtn addTarget:self action:@selector(showStarVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nameBtn];
    _nameBtn = nameBtn;
    
    // 回复内容的类型
    UILabel * typeLbl = [[UILabel alloc] init];
    typeLbl.font = Font15;
    typeLbl.textColor = [UIColor redColor];
    [self addSubview:typeLbl];
    _typeLbl = typeLbl;
    
    // 回复的标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.font = Font15;
    titleLbl.textColor = [UIColor colorWithRed:42 / 255.f green:144 / 255.f blue:216 / 255.f alpha:1];
    [self addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    // 回复的内容
    UILabel * contentLbl = [[UILabel alloc] init];
    contentLbl.font = Font13;
    [self addSubview:contentLbl];
    _contentLbl = contentLbl;
    
    // 回复时间
    UILabel * timeLbl = [[UILabel alloc] init];
    timeLbl.font = Font11;
    timeLbl.textColor = Color178;
    [self addSubview:timeLbl];
    _timeLbl = timeLbl;
    
    // 分割线
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = SeparateColor;
    [self addSubview:separateView];
    _separateView = separateView;
    
}

- (void)setReceiveModel:(MyReceiveModel *)receiveModel{
    _receiveModel = receiveModel;
    
}
// 跳转到用户主页
- (void)showStarVC{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickNameWithModel:)]) {
        [self.delegate tableViewCell:self didClickNameWithModel:_receiveModel];
    }else{
        NSLog(@"MyReceiveCell的代理没有响应...");
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 用户名
    CGFloat nameX =15 * IPHONE6_W_SCALE ;
    CGFloat nameY = 14 * IPHONE6_H_SCALE;
    CGFloat nameW = 45 * IPHONE6_W_SCALE;
    CGFloat nameH = 15 * IPHONE6_W_SCALE;
    _nameLbl.frame = CGRectMake(nameX, nameY, nameW, nameH);
    _nameLbl.text = _receiveModel.username;
    [_nameLbl sizeToFit];
    
    [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLbl.mas_left).offset(-5);
        make.top.equalTo(_nameLbl.mas_top).offset(-5);
        make.right.equalTo(_nameLbl.mas_right).offset(5);
        make.bottom.equalTo(_nameLbl.mas_bottom).offset(5);
    }];
    
    // 回复内容的类型
    CGFloat typeX = CGRectGetMaxX(_nameLbl.frame);
    CGFloat typeW = 110 * IPHONE6_W_SCALE;
    _typeLbl.frame = CGRectMake(typeX, nameY, typeW, nameH);
    _typeLbl.text = @"回复了你的回复";
    if ([_receiveModel.type isEqualToString:@"0"]) {
        _typeLbl.text = [@"回复了你的" stringByAppendingString:[NSString stringWithFormat:@"帖子"]];
    } else{
        _typeLbl.text = [@"回复了你的" stringByAppendingString:[NSString stringWithFormat:@"回复"]];
    }
    
    [_typeLbl sizeToFit];
    
    // 回复的标题
#warning 暂时只做一行的处理，如果评论的特别长
    CGFloat titleX = CGRectGetMaxX(_typeLbl.frame);
    _titleLbl.frame = CGRectMake(titleX, nameY, WIDTH - titleX, nameH);
    _titleLbl.text = @"\"ajdkfjkjflljlafj\"";
    if (_receiveModel.p_title.length > 13) {
        
        _titleLbl.text = [NSString stringWithFormat:@"\"%@\"",[_receiveModel.p_title substringToIndex:12]];
    }else{
       _titleLbl.text = [NSString stringWithFormat:@"\"%@\"",_receiveModel.p_title ];
    }
    
    [_titleLbl sizeToFit];
    
    // 回复的内容
    CGFloat contentY = CGRectGetMaxY(_nameLbl.frame) + 10 * IPHONE6_H_SCALE;
    _contentLbl.frame = CGRectMake(nameX, contentY, WIDTH - 2 * nameX, 13 * IPHONE6_H_SCALE);
    _contentLbl.text = @"aj垃圾分类；阿娇福利卡就是浪费";
    _contentLbl.text = _receiveModel.content;
//    NSLog(@"%@", _receiveModel.content);
//    _contentLbl.backgroundColor = [UIColor greenColor];
    // 回复时间
    CGFloat timeY = CGRectGetMaxY(_contentLbl.frame) + 14 * IPHONE6_H_SCALE;
    _timeLbl.frame = CGRectMake(nameX, timeY, WIDTH - nameX, 11 * IPHONE6_H_SCALE);
    _timeLbl.text = @"adfj";
    _timeLbl.text = _receiveModel.addtime;
    
    // 分割线
    CGFloat separateY = CGRectGetMaxY(_timeLbl.frame) + 12 * IPHONE6_H_SCALE;
    _separateView.frame = CGRectMake(0, separateY, WIDTH, 5 * IPHONE6_H_SCALE);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
