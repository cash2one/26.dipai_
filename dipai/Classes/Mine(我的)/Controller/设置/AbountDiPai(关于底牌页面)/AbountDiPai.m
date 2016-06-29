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
    introduceLbl.text = @"将；发福啊；飞机啊老师讲阿里风景；阿福啊减肥；啊是减肥；;lkjl;kl;jl;jl; ";
    
    
//    NSMutableAttributedString * attributedString= [[NSMutableAttributedString alloc] initWithString:introduceLbl.text];
//    NSMutableParagraphStyle * paragraphStyle= [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:10];//调整行间距
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,[introduceLbl.text length])];
//    introduceLbl.attributedText = attributedString;
    
    CGFloat introduceX = 20 * IPHONE6_W_SCALE;
    CGFloat introduceY = CGRectGetMaxY(imageV.frame) + 40 * IPHONE6_H_SCALE;
    CGFloat introduceW = WIDTH - 2 * introduceX;
    introduceLbl.numberOfLines = 0;
    NSMutableDictionary * contentsDic = [NSMutableDictionary dictionary];
    contentsDic[NSFontAttributeName] = Font15;
    CGRect contentsRect = [introduceLbl.text boundingRectWithSize:CGSizeMake(introduceW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentsDic context:nil];
    introduceLbl.frame = (CGRect){{introduceX, introduceY}, contentsRect.size};
    
    // 商业合作
    UILabel * cooperationLbl = [[UILabel alloc] init];
    cooperationLbl.font = Font15;
    cooperationLbl.text = @"商业合作:";
    [self.view addSubview:cooperationLbl];
    UILabel * dipaiLbl = [[UILabel alloc] init];
    dipaiLbl.font = Font15;
    dipaiLbl.textColor = [UIColor colorWithRed:42 / 255.f green:144 / 255.f blue:216 / 255.f alpha:1];
    dipaiLbl.text = @"bd@dipai.tv";
    [self.view addSubview:dipaiLbl];
    CGFloat cooperationY = CGRectGetMaxY(introduceLbl.frame) + 134 * 0.5 * IPHONE6_H_SCALE;
    cooperationLbl.frame = CGRectMake(20 * IPHONE6_W_SCALE, cooperationY, 100, 15);
    [cooperationLbl sizeToFit];
    CGFloat dipaiX = CGRectGetMaxX(cooperationLbl.frame);
    dipaiLbl.frame = CGRectMake(dipaiX, cooperationY, 200*IPHONE6_W_SCALE, 15*IPHONE6_W_SCALE);
    
    UILabel * bottomLbl = [[UILabel alloc] init];
    [self.view addSubview:bottomLbl];
    bottomLbl.font = Font15;
    bottomLbl.text = @"如果您在使用当中遇到任何问题，请发送邮件到support@dipai.tv";
    bottomLbl.numberOfLines = 0;
    CGFloat bottomX = 20 * IPHONE6_W_SCALE;
    CGFloat bottomY = CGRectGetMaxY(cooperationLbl.frame);
    CGFloat bottomW = WIDTH - 2 * bottomX;
    introduceLbl.numberOfLines = 0;
    NSMutableDictionary * bottomDic = [NSMutableDictionary dictionary];
    bottomDic[NSFontAttributeName] = Font15;
    CGRect bottomRect = [bottomLbl.text boundingRectWithSize:CGSizeMake(bottomW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:bottomDic context:nil];
    bottomLbl.frame = (CGRect){{bottomX, bottomY}, bottomRect.size};
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
