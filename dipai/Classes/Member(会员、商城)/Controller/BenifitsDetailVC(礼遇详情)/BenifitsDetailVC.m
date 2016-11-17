//
//  BenifitsDetailVC.m
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "BenifitsDetailVC.h"
#import "Masonry.h"

#import "DataTool.h"
#import "UIImageView+WebCache.h"
@interface BenifitsDetailVC ()
// 详细说明
@property (nonatomic, strong) UITextView * textV;
// 图片
@property (nonatomic, strong) UIImageView * picV;
// 礼遇名称
@property (nonatomic, strong) UILabel * nameLbl;

@property (nonatomic, strong) NSDictionary * dataDic;

@end

@implementation BenifitsDetailVC

- (NSDictionary *)dataDic{
    
    if (_dataDic == nil) {
        _dataDic = [NSDictionary dictionary];
    }
    return _dataDic;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self getData];
}

- (void)getData{
    
    [DataTool getBenefitDetailDataWithStr:self.wapurl parameters:nil success:^(id responseObject) {
//        NSLog(@"%@", responseObject);
        self.dataDic = responseObject;
        [self setData];
        
    } failure:^(NSError * error) {
        
        NSLog(@"错误信息：%@", error);
    }];
}

- (void)setData{
    
    NSString * picStr = self.dataDic[@"picname"];
    NSString * nameStr = self.dataDic[@"name"];
    NSString * contentStr = self.dataDic[@"content"];
//    NSLog(@"%@----%@---%@", picStr, nameStr, contentStr);
    [_picV sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"123"]];
    _nameLbl.text = nameStr;
    _textV.text = contentStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationBar];
    
    [self setUpUI];
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"礼遇详情";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setUpUI{
    
    // 上方背景图
    UIView * topV = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 351 * 0.5 * IPHONE6_H_SCALE)];
    topV.backgroundColor = RGBA(240, 238, 245, 1);
    [self.view addSubview:topV];
    
    // 图片
    UIImageView * picV = [[UIImageView alloc] init];
    [topV addSubview:picV];
    [picV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topV.mas_centerX);
        make.top.equalTo(topV.mas_top).offset(30 * IPHONE6_H_SCALE);
        make.width.equalTo(@(172 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(172 * 0.5 * IPHONE6_W_SCALE));
    }];
    picV.layer.cornerRadius = 43 * IPHONE6_W_SCALE;
    picV.layer.masksToBounds = YES;
    picV.layer.borderColor = [UIColor redColor].CGColor;
    picV.layer.borderWidth = 1;
    _picV = picV;
    
    // 礼遇名称
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.textAlignment = NSTextAlignmentCenter;
    [topV addSubview:nameLbl];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topV.mas_centerX);
        make.top.equalTo(picV.mas_bottom).offset(16 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(15 * IPHONE6_H_SCALE));
    }];
    _nameLbl = nameLbl;
    
    // 礼遇说明
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.font = Font16;
    titleLbl.text = @"礼遇说明";
    [self.view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(topV.mas_bottom);
        make.width.equalTo(@(WIDTH - 15 * IPHONE6_W_SCALE));
        make.height.equalTo(@(83 * 0.5 * IPHONE6_W_SCALE));
    }];
    
    UIView * lineV = [[UIView alloc] init];
    lineV.backgroundColor = Color229;
    [self.view addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(titleLbl.mas_bottom);
        make.height.equalTo(@(1));
    }];
    
    // 详细内容
    UITextView * textV = [[UITextView alloc] init];
//    textV.backgroundColor = [UIColor redColor];
    textV.userInteractionEnabled = NO;
    [self.view addSubview:textV];
    
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15 * IPHONE6_W_SCALE-6.5*IPHONE6_W_SCALE);
        make.top.equalTo(lineV.mas_bottom).offset(13 * IPHONE6_H_SCALE-10);
        make.width.equalTo(@(WIDTH - 30 * IPHONE6_W_SCALE+13*IPHONE6_W_SCALE));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
//    textV.text = @";ajfjsa;jfkajlfj;sajfljsdklfjklajsklfjd";
    [textV sizeToFit];
    _textV = textV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
