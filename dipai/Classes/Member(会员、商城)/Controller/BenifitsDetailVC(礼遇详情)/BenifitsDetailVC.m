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
//    contentStr = @"；啊结束的；了啊撒放假；啊山东积分撒酒疯了；撒娇垃圾分类；数据的了；积分；啊算风；了解啊疯了似的啊；加夫里什分了结束了咖啡机辣椒放假啊疯了快撒的两件事；拉夫啊积分；撒啊看积分；啊算✈️；啊健身房；连卡时光疯了就；刘嘉玲卡积分；就啊康师傅✈️家啊发；连卡精神发啊；两放假阿斯利康积分巨轮啊；积分；立刻睡觉啊理发店发送；两放假啊算了； ；啊康师傅啊结束的；了啊撒放假；啊山东积分撒酒疯了；撒娇垃圾分类；数据的了；积分；啊算风；了解啊疯了似的啊；加夫里什分了结束了咖啡机辣椒放假啊疯了快撒的两件事；拉夫啊积分；撒啊看积分；啊算✈️；啊健身房；连卡时光疯了就；刘嘉玲卡积分；就啊康师傅✈️家啊发；连卡精神发啊；两放假阿斯利康积分巨轮啊；积分；立刻睡觉啊理发店发送；两放假啊算了； ；啊康师傅✈️；啊健身房；连卡时光疯了就；刘嘉玲卡积分；就啊康师傅✈️家啊发；连卡精神发啊；两放假阿斯利康积分巨轮啊；积分；立刻睡觉啊理发店发送；两放假啊算了； ；啊康师傅啊结束的；了啊撒放假；啊山东积分撒酒疯了；撒娇垃圾分类；数据的了；积分；啊算风；了解啊疯了似的啊；加夫里什分了结束了咖啡机辣椒放假啊疯了快撒的两件事；拉夫啊积分；撒啊看积分；啊算✈️";
//    NSLog(@"%@----%@---%@", picStr, nameStr, contentStr);
    [_picV sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"123"]];
    _nameLbl.text = nameStr;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.5*IPHONE6_W_SCALE;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15*IPHONE6_W_SCALE],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _textV.attributedText = [[NSAttributedString alloc] initWithString:contentStr attributes:attributes];
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
    textV.font = Font14;
//    textV.selectable = NO;
    [textV setEditable:NO];
    [self.view addSubview:textV];
    
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15 * IPHONE6_W_SCALE-6.5*IPHONE6_W_SCALE+5*IPHONE6_W_SCALE);
        make.top.equalTo(lineV.mas_bottom).offset(13 * IPHONE6_H_SCALE-10);
        make.width.equalTo(@(WIDTH - 30 * IPHONE6_W_SCALE+13*IPHONE6_W_SCALE));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
//    textV.text = @";ajfjsa;jfkajlfj;sajfljsdklfjklajsklfjd";
//    [textV sizeToFit];
    _textV = textV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
