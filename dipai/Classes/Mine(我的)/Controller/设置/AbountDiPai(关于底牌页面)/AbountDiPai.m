//
//  AbountDiPai.m
//  dipai
//
//  Created by 梁森 on 16/6/27.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AbountDiPai.h"

#import "Masonry.h"
@interface AbountDiPai ()

@end

@implementation AbountDiPai

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setNavigationBar];
    
    // 设置UI
    [self setUpUI];
}
#pragma mark --- 设置导航条
- (void)setNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
    
    // 左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui"] target:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:38/2];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"关于底牌";
    self.navigationItem.titleView = titleLabel;
}
#pragma mark --- 返回
- (void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 设置UI
- (void)setUpUI{
    // logo
    UIImageView * imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"dipai_logo"];
    [self.view addSubview:imageV];
    CGFloat imageX = 215*0.5*IPHONE6_W_SCALE;
    CGFloat imageY = 39*IPHONE6_H_SCALE;
    CGFloat imageW = 160 * IPHONE6_W_SCALE;
    CGFloat imageH = 61 * IPHONE6_W_SCALE;
    imageV.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    // 底牌介绍
    UILabel * introduceLbl = [[UILabel alloc] init];
    introduceLbl.font = Font15;
    [self.view addSubview:introduceLbl];
    introduceLbl.text = @"底牌是德州扑克游戏的爱好者聚集地。通过底牌让更多喜欢这款游戏的朋友，了解德州扑克，学习德州扑克，爱上德州扑克。";
    
    
    CGFloat introduceX = 25 * IPHONE6_W_SCALE;
    CGFloat introduceY = CGRectGetMaxY(imageV.frame) + 41 * IPHONE6_H_SCALE;
    CGFloat introduceW = WIDTH - 2 * introduceX;
    introduceLbl.numberOfLines = 0;
    NSMutableDictionary * contentsDic = [NSMutableDictionary dictionary];
    contentsDic[NSFontAttributeName] = Font15;
    CGRect contentsRect = [introduceLbl.text boundingRectWithSize:CGSizeMake(introduceW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentsDic context:nil];
    introduceLbl.frame = (CGRect){{introduceX, introduceY}, contentsRect.size};
    
    // 投稿
    UILabel * contribute = [[UILabel alloc] init];
    [self.view addSubview:contribute];
    contribute.text = @"投稿";
    contribute.font = Font16;
    [contribute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introduceLbl.mas_bottom).offset(41 * IPHONE6_H_SCALE);
        make.left.equalTo(self.view.mas_left).offset(37 * IPHONE6_W_SCALE);
        make.width.equalTo(@(WIDTH - 37 * IPHONE6_W_SCALE));
        make.height.equalTo(@(16 * IPHONE6_W_SCALE));
    }];
    
    UIView * square1 = [[UIView alloc] init];
    [self.view addSubview:square1];
    square1.backgroundColor = [UIColor blackColor];
    [square1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25 * IPHONE6_W_SCALE);
        make.centerY.equalTo(contribute.mas_centerY);
        make.width.equalTo(@(5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(5 * IPHONE6_W_SCALE));
    }];
    
    UILabel * con1 = [[UILabel alloc] init];
    [self.view addSubview:con1];
    NSMutableAttributedString * text1 = [[NSMutableAttributedString alloc] initWithString:@"投稿请发送到article@dipai.tv"];
    [text1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:42 / 255.f green:144 / 255.f blue:216 / 255.f alpha:1] range:NSMakeRange(6, 16)];
    con1.attributedText = text1;
    con1.font = Font13;
    [con1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contribute.mas_left);
        make.top.equalTo(contribute.mas_bottom).offset(10 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 37 * IPHONE6_W_SCALE));
        make.height.equalTo(@(14 * IPHONE6_W_SCALE));
    }];
    UILabel * con2 = [[UILabel alloc] init];
    [self.view addSubview:con2];
    con2.text = @"一经采用，稿酬从优";
    con2.font = Font13;
    [con2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(con1.mas_left);
        make.top.equalTo(con1.mas_bottom).offset(3 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 37 * IPHONE6_W_SCALE));
        make.height.equalTo(@(14 * IPHONE6_W_SCALE));
    }];
    
    // 合作
    UILabel * coorperate = [[UILabel alloc] init];
    [self.view addSubview:coorperate];
    coorperate.text = @"合作";
    coorperate.font = Font16;
    [coorperate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contribute.mas_left);
        make.top.equalTo(con2.mas_bottom).offset(22 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 37 * IPHONE6_W_SCALE));
        make.height.equalTo(@(16 * IPHONE6_W_SCALE));
    }];
    UIView * square2 = [[UIView alloc] init];
    [self.view addSubview:square2];
    square2.backgroundColor = [UIColor blackColor];
    [square2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(square1.mas_left);
        make.centerY.equalTo(coorperate.mas_centerY);
        make.width.equalTo(@(5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(5 * IPHONE6_W_SCALE));
    }];
    
    UILabel * coor = [[UILabel alloc] init];
    [self.view addSubview:coor];
    NSMutableAttributedString * coorText = [[NSMutableAttributedString alloc] initWithString:@"广告投放／赛事、游戏等合作请发送到bd@dipai.tv"];
    [coorText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:42 / 255.f green:144 / 255.f blue:216 / 255.f alpha:1] range:NSMakeRange(17, 11)];
    coor.attributedText = coorText;
    coor.font = Font13;
    [coor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coorperate.mas_left);
        make.top.equalTo(coorperate.mas_bottom).offset(10 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 37 * IPHONE6_W_SCALE));
        make.height.equalTo(@(14 * IPHONE6_W_SCALE));
    }];
    
    // 投诉与建议
    UILabel * advice = [[UILabel alloc] init];
    [self.view addSubview:advice];
    advice.text = @"投诉与建议";
    advice.font = Font16;
    [advice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coorperate.mas_left);
        make.top.equalTo(coor.mas_bottom).offset(22 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 37 * IPHONE6_W_SCALE));
        make.height.equalTo(@(16 * IPHONE6_W_SCALE));
    }];
    UIView * square3 = [[UIView alloc] init];
    [self.view addSubview:square3];
    square3.backgroundColor = [UIColor blackColor];
    [square3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(square1.mas_left);
        make.centerY.equalTo(advice.mas_centerY);
        make.width.equalTo(@(5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(5 * IPHONE6_W_SCALE));
    }];
    UILabel * advice1 = [[UILabel alloc] init];
    [self.view addSubview:advice1];
    advice1.text = @"底牌致力于维护知识产权以及尊重他人的知识产权";
    advice1.font = Font13;
    [advice1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(advice.mas_left);
        make.top.equalTo(advice.mas_bottom).offset(10 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 37 * IPHONE6_W_SCALE));
        make.height.equalTo(@(14 * IPHONE6_W_SCALE));
    }];
    UILabel * advice2 = [[UILabel alloc] init];
    [self.view addSubview:advice2];
    NSMutableAttributedString * advice2Text = [[NSMutableAttributedString alloc] initWithString:@"如有版权等问题，请联系support@dipai.tv"];
    [advice2Text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:42 / 255.f green:144 / 255.f blue:216 / 255.f alpha:1] range:NSMakeRange(11, 16)];
    advice2.attributedText = advice2Text;
    advice2.font = Font13;
    [advice2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(advice1.mas_left);
        make.top.equalTo(advice1.mas_bottom).offset(3 * IPHONE6_H_SCALE);
        make.width.equalTo(advice1.mas_width);
        make.height.equalTo(advice1.mas_height);
    }];
    
    // 用户交流
    UILabel * communicate = [[UILabel alloc] init];
    [self.view addSubview:communicate];
    communicate.text = @"用户交流";
    communicate.font = Font16;
    [communicate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(advice.mas_left);
        make.top.equalTo(advice2.mas_bottom).offset(22 * IPHONE6_H_SCALE);
        make.width.equalTo(advice.mas_width);
        make.height.equalTo(advice.mas_height);
    }];
    UIView * square4 = [[UIView alloc] init];
    [self.view addSubview:square4];
    square4.backgroundColor = [UIColor blackColor];
    [square4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(square1.mas_left);
        make.centerY.equalTo(communicate.mas_centerY);
        make.width.equalTo(@(5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(5 * IPHONE6_W_SCALE));
    }];
    UILabel * office = [[UILabel alloc] init];
    [self.view addSubview:office];
    office.text = @"官方交流QQ群：522857513";
    office.font = Font13;
    [office mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(communicate.mas_left);
        make.top.equalTo(communicate.mas_bottom).offset(10 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 37 * IPHONE6_W_SCALE));
        make.height.equalTo(@(14 * IPHONE6_W_SCALE));
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
