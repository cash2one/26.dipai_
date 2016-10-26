//
//  MemberLevelViewController.m
//  dipai
//
//  Created by 梁森 on 16/10/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MemberLevelViewController.h"

#import "NumberDetailVC.h"
// 更多礼遇页面
#import "MoreBenifitsVC.h"
// 礼遇详情
#import "BenifitsDetailVC.h"


// 会员等级模型
#import "MemberLevelModel.h"
// 礼遇模型
#import "BenifitModel.h"

// 圆形进度条
#import "PICircularProgressView.h"

#import "DataTool.h"

#define Rect(X, Y, W, H) CGRectMake((X), (Y), (W), (H))


#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface MemberLevelViewController ()
// 等级进度条
@property (nonatomic, strong) PICircularProgressView *progressView;//中间
// 等级
@property (nonatomic, strong) UILabel * levelLbl;
// 积分数
@property (nonatomic, strong) UILabel * numLbl;
// 达到下一级的要求
@property (nonatomic, strong) UILabel * requestLbl;
// 弹窗的背景图
@property (nonatomic, strong) UIView * showBackV;

// 等级模型
@property (nonatomic, strong) MemberLevelModel * levelModel;
// 礼遇模型
@property (nonatomic, strong) BenifitModel * beniModel;
// 礼遇模型数组
@property (nonatomic, strong) NSMutableArray * beniModelArr;

@end

@implementation MemberLevelViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    // 页面每次出现都要进行数据刷新，因为积分随时可能变
    [self getData];
}

- (NSMutableArray *)beniModelArr{
    
    if (_beniModelArr == nil) {
        _beniModelArr = [NSMutableArray array];
    }
    return _beniModelArr;
}

- (void)getData{
    
    [DataTool getMemberLevelDataWithStr:MemberLevel parameters:nil success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSString class]]) {  // 获取数据失败
            
        }else{
            
            NSMutableArray * dataArr = responseObject;
            MemberLevelModel * levelModel = [[MemberLevelModel alloc] init];
            _levelModel = levelModel;            
            _levelModel = dataArr[0];
            self.beniModelArr = dataArr[1];
            
            // 设置数据
            [self setData];
        }
        
    } failure:^(NSError * error) {
        
    }];
}
- ( void)setData{
    
    // 当前等级
    NSString * count_integral = _levelModel.count_integral;
    NSString * score_end = _levelModel.score_end;
    int integral = [count_integral intValue];
    int allScore = [score_end intValue];
    int progress = (CGFloat)(integral / allScore);
    if (progress == 0) {
        
        self.progressView.progressTopGradientColor =[UIColor blackColor];
        self.progressView.progressBottomGradientColor = [UIColor blackColor];
    }else{
        self.progressView.progressTopGradientColor = [UIColor colorWithRed:187 / 255.f  green:89 / 255.f blue:255 / 255.f alpha:1];
        self.progressView.progressBottomGradientColor = [UIColor colorWithRed:68 / 252.f green:220 / 252.f blue:252 / 255.f alpha:1];
         self.progressView.progress = progress;
    }
   
    
    _levelLbl.text = _levelModel.rolename;
    
    _numLbl.text = [NSString stringWithFormat:@"%@/%@", count_integral, score_end];
    
    _requestLbl.text = @"";
    
    // 礼遇内容
    for (int i = 0; i < self.beniModelArr.count ; i ++) {
        int j = i / 3;
        UIView * imgBackV = [[UIView alloc] initWithFrame:CGRectMake(0 + WIDTH / 3 * i, 542 * 0.5 * IPHONE6_H_SCALE + 110 * IPHONE6_H_SCALE *j , WIDTH / 3, 110 * IPHONE6_H_SCALE)];
//        imgBackV.backgroundColor = [UIColor redColor];
        imgBackV.tag = i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBeneDetail:)];
        [imgBackV addGestureRecognizer:tap];
        tap.numberOfTouchesRequired = 1;
        
        UIImageView * imgV = [[UIImageView alloc] init];
        imgV.layer.cornerRadius = 35 * IPHONE6_W_SCALE;
        imgV.layer.masksToBounds = YES;
        [imgBackV addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imgBackV.mas_centerX);
            make.top.equalTo(imgBackV.mas_top).offset(13 * IPHONE6_H_SCALE);
            make.width.equalTo(@(70 * IPHONE6_W_SCALE));
            make.height.equalTo(@(70 * IPHONE6_W_SCALE));
        }];
        BenifitModel * model = [self.beniModelArr objectAtIndex:i];
        [imgV sd_setImageWithURL:[NSURL URLWithString:model.picname] placeholderImage:[UIImage imageNamed:@"123"]];
        
        UILabel * titleLbl = [[UILabel alloc] init];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.text = model.name;
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [imgBackV addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imgBackV.mas_centerX);
            make.bottom.equalTo(imgBackV.mas_bottom);
            make.width.equalTo(imgBackV.mas_width);
            make.height.equalTo(@(17 * IPHONE6_W_SCALE));
        }];
        
        [self.view addSubview:imgBackV];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    
    [self setUpUI];
    
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"会员等级";
    self.naviBar.rightStr = @"积分明细";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar.rightBtn addTarget:self action:@selector(seeNumDetail) forControlEvents:UIControlEventTouchUpInside];
}

// 跳转到积分详情页面
- (void)seeNumDetail{
    
    NumberDetailVC * numDetailVC = [[NumberDetailVC alloc] init];
    [self.navigationController pushViewController:numDetailVC animated:YES];
}

- (void)setUpUI{
    
    // 上方的背景图片
    UIImageView * topV = [[UIImageView alloc] init];
//    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 290 * 0.5 * IPHONE6_H_SCALE)];
    topV.image = [UIImage imageNamed:@"membere_beijing"];
    [self.view addSubview:topV];
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.height.equalTo(@(290 * 0.5 * IPHONE6_H_SCALE));
        make.width.equalTo(@(WIDTH));
    }];
    
    // 进度条
    //进度条初始化
    PICircularProgressView * progressV = [[PICircularProgressView alloc] initWithFrame:CGRectMake(WIDTH / 2- 192 * 0.5 * 0.5 * IPHONE6_W_SCALE, 64 + 9 * IPHONE6_H_SCALE, 192 * 0.5 * IPHONE6_W_SCALE, 192 * 0.5 * IPHONE6_W_SCALE)];
    [topV addSubview:progressV];
    _progressView = progressV;
    self.progressView.textColor = [UIColor colorWithRed:192/255.0 green:212/255.0 blue:195/255.0 alpha:0.0];
    self.progressView.touchview.hidden = YES;
    self.progressView.triangleImageView.hidden = YES;
    // 开始颜色
    self.progressView.progressTopGradientColor =[UIColor greenColor];
    self.progressView.progressTopGradientColor = [UIColor colorWithRed:187 / 255.f  green:89 / 255.f blue:255 / 255.f alpha:1];
    self.progressView.progressBottomGradientColor = [UIColor colorWithRed:68 / 252.f green:220 / 252.f blue:252 / 255.f alpha:1];
    // 结束颜色
    [self.view addSubview:self.progressView];
    
    // 等级
    UILabel * levelLbl = [[UILabel alloc] init];
//    levelLbl.text = @"V0";
    // 斜体＋粗体
    levelLbl.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:35 * IPHONE6_W_SCALE];
    levelLbl.textColor = [UIColor whiteColor];
    levelLbl.textAlignment = NSTextAlignmentCenter;
//    levelLbl.backgroundColor = [UIColor redColor];
    levelLbl.frame = CGRectMake(0, 74 * 0.5 * IPHONE6_H_SCALE, WIDTH, 35 * IPHONE6_W_SCALE);
    [topV addSubview:levelLbl];
    _levelLbl = levelLbl;
    
    // 积分数
    UILabel * numLbl = [[UILabel alloc] init];
    numLbl.textAlignment = NSTextAlignmentCenter;
    numLbl.textColor = Color178;
    numLbl.font = Font9;
//    numLbl.backgroundColor = [UIColor greenColor];
//    numLbl.text = @"100/1000";
    [topV addSubview:numLbl];
    [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(WIDTH));
        make.top.equalTo(levelLbl.mas_bottom).offset(8 * IPHONE6_H_SCALE);
        make.height.equalTo(@(9 * IPHONE6_W_SCALE));
        make.centerX.equalTo(topV.mas_centerX);
    }];
    _numLbl = numLbl;
    
    // 达到下一等级的要求
    UILabel * requestLbl = [[UILabel alloc] init];
//    requestLbl.backgroundColor = [UIColor redColor];
    requestLbl.font = Font11;
    requestLbl.textAlignment = NSTextAlignmentCenter;
    requestLbl.textColor = Color178;
    requestLbl.text = @"需要1000积分精神值V1等级";
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = Font11;
    CGSize size = [requestLbl.text sizeWithAttributes:dic];
    CGFloat w = size.width;
    
    [topV addSubview:requestLbl];
    [requestLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topV.mas_bottom).offset(-33 * 0.5 * IPHONE6_H_SCALE);
        make.centerX.equalTo(topV.mas_centerX);
        make.width.equalTo(@(w + 10));
        make.height.equalTo(@(11 * IPHONE6_W_SCALE));
    }];
    [requestLbl sizeToFit];
    
    // 显示等级详细信息的按钮
    UIButton * showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showBtn setImage:[UIImage imageNamed:@"yiwen"] forState:UIControlStateNormal];
    [topV addSubview:showBtn];
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(requestLbl.mas_centerY);
        make.left.equalTo(requestLbl.mas_right).offset(-6 * IPHONE6_W_SCALE);
        make.width.equalTo(@(45 * IPHONE6_W_SCALE));
        make.height.equalTo(@(45 * IPHONE6_W_SCALE));
    }];
    [showBtn addTarget:self action:@selector(showDetailMessage) forControlEvents:UIControlEventTouchUpInside];
    topV.userInteractionEnabled = YES;
    
    // 分割线
    UIView * separateV = [[UIView alloc] init];
    separateV.backgroundColor = RGBA(240, 238, 245, 1);
    [self.view addSubview:separateV];
    [separateV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topV.mas_bottom);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(20 * IPHONE6_H_SCALE));
        make.left.equalTo(self.view.mas_left);
    }];
    
    // 会员礼遇标签
    UILabel * benifitsLbl = [[UILabel alloc] init];
//    benifitsLbl.backgroundColor = [UIColor redColor];
    benifitsLbl.font = Font16;
    benifitsLbl.text = @"会员礼遇";
    benifitsLbl.textColor = [UIColor blackColor];
    [self.view addSubview:benifitsLbl];
    [benifitsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateV.mas_bottom).offset(14 * IPHONE6_H_SCALE);
        make.left.equalTo(self.view.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.width.equalTo(@(200 * IPHONE6_W_SCALE));
        make.height.equalTo(@(16 * IPHONE6_H_SCALE));
    }];
    
    
    // 更多礼遇按钮
    UIImageView * moreV = [[UIImageView alloc] init];
    moreV.image = [UIImage imageNamed:@"gengduo"];
    [self.view addSubview:moreV];
    [moreV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.top.equalTo(separateV.mas_bottom).offset(16 * IPHONE6_H_SCALE);
        make.width.equalTo(@(6 * IPHONE6_W_SCALE));
        make.height.equalTo(@(11 * IPHONE6_W_SCALE));
    }];
    UILabel * moreLbl = [[UILabel alloc] init];
//    moreLbl.backgroundColor = [UIColor redColor];
    moreLbl.text = @"更多";
    moreLbl.font = Font12;
    moreLbl.textColor = Color153;
    moreLbl.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:moreLbl];
    [moreLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateV.mas_bottom).offset(16 * IPHONE6_H_SCALE);
        make.right.equalTo(moreV.mas_left).offset(-7 * IPHONE6_W_SCALE);
        make.width.equalTo(@(100));
        make.height.equalTo(@(12 * IPHONE6_W_SCALE));
    }];
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:moreBtn];
//    moreBtn.backgroundColor = [UIColor redColor];
    moreBtn.alpha = 0.5;
    [moreBtn addTarget:self action:@selector(seeMoreBenifits) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moreV.mas_right).offset(10);
        make.top.equalTo(separateV.mas_bottom);
        make.left.equalTo(moreLbl.mas_left);
        make.bottom.equalTo(moreLbl.mas_bottom).offset(15 * IPHONE6_H_SCALE);
    }];
    
    UIView * lineV = [[UIView alloc] init];
    lineV.backgroundColor = Color229;
    [self.view addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(WIDTH));
        make.top.equalTo(benifitsLbl.mas_bottom).offset(12 * IPHONE6_H_SCALE);
        make.height.equalTo(@(0.5));
    }];
    
    // 条款
    UILabel * aboutBeniLbl = [[UILabel alloc] init];
    aboutBeniLbl.font = Font12;
    aboutBeniLbl.textAlignment = NSTextAlignmentCenter;
    
    UIColor * color = RGBA(49, 145, 217, 1);
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"更多细则，请参见《会员礼遇条款》"];
    
    [AttributedStr addAttribute:NSFontAttributeName
                          value:Font12
                          range:NSMakeRange(9, 6)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:NSMakeRange(9, 6)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:Color153
                          range:NSMakeRange(0, 9)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:Color153
                          range:NSMakeRange(15, 1)];
    
    aboutBeniLbl.attributedText = AttributedStr;
    [self.view addSubview:aboutBeniLbl];
    [aboutBeniLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(lineV.mas_bottom).offset(224 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(12 * IPHONE6_W_SCALE));
    }];
    
    // 条款按钮
    UIButton * aboutBeniBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    aboutBeniBtn.backgroundColor = [UIColor redColor];
    aboutBeniBtn.alpha = 0.5;
    [aboutBeniBtn addTarget:self action:@selector(seeBenifitsClause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutBeniBtn];
    [aboutBeniBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-90 * IPHONE6_W_SCALE);
        make.top.equalTo(aboutBeniLbl.mas_top).offset(-10);
        make.bottom.equalTo(aboutBeniLbl.mas_bottom).offset(10);
        make.width.equalTo(@(100 * IPHONE6_W_SCALE));
    }];
}
// 跳转到更多礼遇页面
- (void)seeMoreBenifits{
    
    MoreBenifitsVC * moreVC = [[MoreBenifitsVC alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

// 显示等级详细信息
- (void)showDetailMessage{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView * showBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    showBackV.backgroundColor = RGBA(255, 255, 255, 0.5);
    [window addSubview:showBackV];
    _showBackV = showBackV;
    
    UIImageView * showV = [[UIImageView alloc] init];
    showV.userInteractionEnabled = YES;
    [showBackV addSubview:showV];
    if ([_levelLbl.text isEqualToString:@"V0"]) {
        showV.image = [UIImage imageNamed:@"tanchuang1"];
        
        [showV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(showBackV.mas_centerX);
            make.centerY.equalTo(showBackV.mas_centerY);
            make.width.equalTo(@(233 * IPHONE6_W_SCALE));
            make.height.equalTo(@(590 * 0.5 * IPHONE6_W_SCALE));
        }];
        
        // 当前等级
        UILabel * textL = [[UILabel alloc] init];
        textL.font = [UIFont boldSystemFontOfSize:18 * IPHONE6_W_SCALE];
        textL.text = @"当前等级";
        textL.textColor = RGBA(202, 156, 91, 1);
        textL.textAlignment = NSTextAlignmentCenter;
        [showV addSubview:textL];
        [textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(showV.mas_centerX);
            make.top.equalTo(showV.mas_top).offset(113 * IPHONE6_W_SCALE);
            make.width.equalTo(showV.mas_width);
            make.height.equalTo(@(18 * IPHONE6_W_SCALE));
        }];
        
        // 达到v1要求
        UILabel * requestLbl = [[UILabel alloc] init];
        requestLbl.font = Font11;
        requestLbl.textAlignment = NSTextAlignmentCenter;
        requestLbl.textColor = Color178;
        NSMutableAttributedString * text =[[NSMutableAttributedString alloc] initWithString:@"累积获得1000积分达到V1等级"];
        [text addAttribute:NSForegroundColorAttributeName value:RGBA(202, 156, 91, 1) range:NSMakeRange(12, 4)];
        requestLbl.attributedText = text;
        [showV addSubview:requestLbl];
        [requestLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(showV.mas_centerX);
            make.top.equalTo(showV.mas_top).offset(374 * 0.5 * IPHONE6_W_SCALE);
            make.width.equalTo(showV.mas_width);
            make.height.equalTo(@(11 * IPHONE6_W_SCALE));
        }];
        
    }else{
        
        showV.image =[UIImage imageNamed:@"tanchuang2"];
        [showV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(showBackV.mas_centerX);
            make.centerY.equalTo(showBackV.mas_centerY);
            make.width.equalTo(@(233 * IPHONE6_W_SCALE));
            make.height.equalTo(@(350* IPHONE6_W_SCALE));
        }];
    }
    
    // 等级
    UILabel * levelL = [[UILabel alloc] init];
    levelL.text = _levelLbl.text;
    levelL.textAlignment = NSTextAlignmentCenter;
    levelL.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:32 * IPHONE6_W_SCALE];
    levelL.textColor = RGBA(202, 156, 91, 1);
    [showV addSubview:levelL];
    [levelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(showV.mas_centerX);
        make.top.equalTo(showV.mas_top);
        make.width.equalTo(@(104 * IPHONE6_W_SCALE));
        make.height.equalTo(@(104 * IPHONE6_W_SCALE));
    }];
    
    // 我知道了按钮
    UIButton * knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [knowBtn setTitle:@"知道了" forState:UIControlStateNormal];
    knowBtn.titleLabel.font = Font12;
    knowBtn.layer.cornerRadius = 13 * IPHONE6_W_SCALE;
    knowBtn.layer.masksToBounds = YES;
    knowBtn.layer.borderColor = RGBA(202, 156, 91, 1).CGColor;
    knowBtn.layer.borderWidth = 0.5;
    [knowBtn setTitleColor:RGBA(202, 156, 91, 1) forState:UIControlStateNormal];
    knowBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [showV addSubview:knowBtn];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(showV.mas_centerX);
        make.bottom.equalTo(showV.mas_bottom).offset(-37 * 0.5 * IPHONE6_W_SCALE);
        make.width.equalTo(@(214 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(25 * IPHONE6_W_SCALE));
    }];
    
    [knowBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
}

// 跳转到条款页面
- (void)seeBenifitsClause{
    
    NSLog(@"跳转到条款页面..");
}

// 跳转到礼遇详情页
- (void)seeBeneDetail:(UITapGestureRecognizer *)tap{
    
    UIView * view = tap.view;
    NSLog(@"%lu", view.tag);
    BenifitsDetailVC * beniDetailVC = [[BenifitsDetailVC alloc] init];
    BenifitModel * model = [self.beniModelArr objectAtIndex:view.tag];;
    beniDetailVC.wapurl = model.wapurl;
    [self.navigationController pushViewController:beniDetailVC animated:YES];
}

// 移除提示框
- (void)removeAction{
    
    [_showBackV removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
