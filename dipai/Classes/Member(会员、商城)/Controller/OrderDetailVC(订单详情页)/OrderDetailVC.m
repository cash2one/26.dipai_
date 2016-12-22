//
//  OrderDetailVC.m
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "OrderDetailVC.h"

// 选择收货地址
#import "SelectAddressVC.h"


#import "Masonry.h"
#import "DataTool.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
@interface OrderDetailVC ()
// 添加地址提示
@property (nonatomic, strong) UILabel * alertLbl;
// 用户姓名
@property (nonatomic, strong) UILabel * nameLbl;
// 用户电话
@property (nonatomic, strong) UILabel * numLbl ;
// 用户地址
@property (nonatomic, strong) UILabel * addressLbl;
// 商品名称
@property (nonatomic, strong) UILabel * goodNameL;
// 商品图片
@property (nonatomic, strong)  UIImageView * goodsImage;
// 商品积分
@property (nonatomic, strong) UILabel * goodsNumL;
// 非会员积分
@property (nonatomic, strong) UILabel * feVIPLbl;
// 账户总积分
@property (nonatomic, strong) UILabel * allNumLbl ;
// 积分消耗
@property (nonatomic, strong) UILabel * needNumLbl;
// 提交订单按钮
@property (nonatomic, strong) UIButton * submitBtn;

// 数据字典
@property (nonatomic, strong) NSDictionary * dataDic;
@end

@implementation OrderDetailVC

- (NSDictionary *)dataDic{
    
    if (_dataDic == nil) {
        _dataDic = [NSDictionary dictionary];
    }
    return _dataDic;
}

//- (void)noLoginInOtherPhone{
//    
//    [self getData];
//}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self getData];
}

- (void)getData{
    
    NSString * url = [OrderSureURL stringByAppendingString:[NSString stringWithFormat:@"/%@",self.goodID]];
    NSLog(@"--->%@", url);
    [NSThread sleepForTimeInterval:0.05];
    [DataTool getOrderSureDataWithStr:url parameters:nil success:^(id responseObject) {
        
        self.dataDic = responseObject;
        [self setData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取数据的错误信息：%@", error);
    }];
}

- (void)setData{
    
    // 默认地址
    NSDictionary * addressDic = self.dataDic[@"address"];
    if ([addressDic isKindOfClass:[NSNull class]] || self.dataDic.count == 0) {    // 如果没有默认地址
        
        _alertLbl.hidden = NO;
        _nameLbl.hidden = YES;
        _addressLbl.hidden = YES;
    }else{
//        NSLog(@"%@", addressDic[@"address_name"]);
        _nameLbl.text = [NSString stringWithFormat:@"%@  %@", addressDic[@"address_name"], addressDic[@"mobile"]];
        _addressLbl.text = [NSString stringWithFormat:@"%@%@", addressDic[@"district"], addressDic[@"address"]];
        _alertLbl.hidden = YES;
        _nameLbl.hidden = NO;
        _addressLbl.hidden = NO;
    }
    
    // 商品信息
    NSDictionary * goodsDic = self.dataDic[@"goods"];
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:goodsDic[@"goods_img"]] placeholderImage:[UIImage imageNamed:@"123"]];
    _goodNameL.text = goodsDic[@"goods_name"];
    [_goodNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(274 * 0.5 * IPHONE6_W_SCALE);
        make.top.equalTo(_goodsImage.mas_top).offset(3 * IPHONE6_H_SCALE);
        make.right.equalTo(self.view.mas_right).offset(-15 * IPHONE6_W_SCALE);
    }];
    NSMutableAttributedString * goodsNumStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"积分：%@", goodsDic[@"shop_price"]]];
    [goodsNumStr addAttribute:NSFontAttributeName value:Font12 range:NSMakeRange(0, 3)];
    _goodsNumL.attributedText = goodsNumStr;
   
    NSString * vIPNum = [NSString stringWithFormat:@"积分：%@",goodsDic[@"shop_price"]];
    NSMutableDictionary * numDic = [NSMutableDictionary dictionary];
    numDic[NSFontAttributeName] = Font14;
    CGSize numSize = [vIPNum sizeWithAttributes:numDic];
    CGFloat numWidth = numSize.width;
    [_goodsNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsImage.mas_right).offset(12 * IPHONE6_W_SCALE);
        make.bottom.equalTo(_goodsImage.mas_bottom);
        make.width.equalTo(@(numWidth+2));
        make.height.equalTo(@(14 * IPHONE6_W_SCALE));
    }];
     // 非会员积分
    _feVIPLbl.text = @"2000";
    NSMutableDictionary * feNumDic = [NSMutableDictionary dictionary];
    feNumDic[NSFontAttributeName] = Font12;
    CGFloat feWidth = [_feVIPLbl.text sizeWithAttributes:feNumDic].width;
    [_feVIPLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsNumL.mas_right).offset(5 * IPHONE6_W_SCALE);
        make.bottom.equalTo(_goodsNumL.mas_bottom).offset(-1);
        make.width.equalTo(@(feWidth+1));
        make.height.equalTo(@(12 * IPHONE6_W_SCALE));
    }];

    
    NSMutableAttributedString * needNumStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"积分消耗：%@", goodsDic[@"shop_price"]]];
    [needNumStr addAttribute:NSFontAttributeName value:Font12 range:NSMakeRange(0, 5)];
    [needNumStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    _needNumLbl.attributedText = needNumStr;
    
    // 积分总数和提交订单地址
    NSDictionary * infoDic = self.dataDic[@"info"];
    if ([infoDic[@"sum_integral"] isKindOfClass:[NSString class]]) {
        NSLog(@"sum_integral是字符串类型...");
        _allNumLbl.text = infoDic[@"sum_integral"];
    }else{
        NSLog(@"sum_integral不是字符串类型...");
        _allNumLbl.text = [infoDic[@"sum_integral"] stringValue];
    }
    
    
    NSString * allNum = _allNumLbl.text;
    NSString * goods_price = goodsDic[@"shop_price"];
    int all = [allNum intValue];
    int price = [goods_price intValue];
    if (all < price) {
        [_submitBtn setTitle:@"积分不足" forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:RGBA(255, 150, 150, 1)];
        _submitBtn.userInteractionEnabled = NO;
    }else{
        [_submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:[UIColor redColor]];
        _submitBtn.userInteractionEnabled = YES;
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationBar];
    [self setUpUI];
//    NSLog(@"goodID:%@", self.goodID);
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [self addSuccessView];
//}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"确认订单";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setUpUI{
    
    UIView * addressV = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 75 * IPHONE6_H_SCALE)];
    addressV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addressV];
    
    // 添加地址提示
    UILabel * alertLbl = [[UILabel alloc] init];
    alertLbl.font = Font14;
    alertLbl.text = @"请添加收货地址";
    [addressV addSubview:alertLbl];
    [alertLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressV.mas_left).offset(13 * IPHONE6_W_SCALE);
        make.top.equalTo(addressV.mas_top);
        make.bottom.equalTo(addressV.mas_bottom);
        make.width.equalTo(@(150 * IPHONE6_W_SCALE));
    }];
    _alertLbl = alertLbl;
    
    // 前进图标
    UIImageView * accessV = [[UIImageView alloc] init];
    accessV.userInteractionEnabled = YES;
    accessV.image = [UIImage imageNamed:@"qianwangxinxi"];
    [addressV addSubview:accessV];
    [accessV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressV.mas_centerY);
        make.right.equalTo(addressV.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.width.equalTo(@(9 * IPHONE6_W_SCALE));
        make.height.equalTo(@(18 * IPHONE6_W_SCALE));
    }];
    // 添加地址按钮
    UIButton * addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.backgroundColor = [UIColor clearColor];
    [addressBtn addTarget:self action:@selector(addAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [addressV addSubview:addressBtn];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressV.mas_left);
        make.right.equalTo(addressV.mas_right);
        make.top.equalTo(addressV.mas_top);
        make.bottom.equalTo(addressV.mas_bottom);
    }];
    
    // 默认地址信息
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.font = Font14;
    [addressV addSubview:nameLbl];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressV.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(addressV.mas_top).offset(21 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 15 * IPHONE6_W_SCALE));
        make.height.equalTo(@(14 * IPHONE6_H_SCALE +2));
    }];
    _nameLbl = nameLbl;
    
    UILabel * numLbl = [[UILabel alloc] init];
    [addressV addSubview:numLbl];
    _numLbl = numLbl;
    
    UILabel * addressLbl = [[UILabel alloc] init];
//    addressLbl.backgroundColor = [UIColor redColor];
    addressLbl.font = Font12;
    addressLbl.textColor = Color153;
    [addressV addSubview:addressLbl];
    [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLbl.mas_left);
        make.top.equalTo(nameLbl.mas_bottom).offset(9 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 15 * IPHONE6_W_SCALE));
        make.height.equalTo(@(12 * IPHONE6_W_SCALE+2));
    }];
    _addressLbl = addressLbl;
    
    
    // 分割线
    UIView * sapareteV1 = [[UIView alloc] init];
    sapareteV1.backgroundColor = SeparateColor;
    [self.view addSubview:sapareteV1];
    [sapareteV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(addressV.mas_bottom);
        make.height.equalTo(@(10 * IPHONE6_H_SCALE));
    }];
    
    // 购买商品
    UIView * buyV = [[UIView alloc] init];
    buyV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buyV];
    [buyV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(sapareteV1.mas_bottom);
        make.height.equalTo(@(81 * IPHONE6_H_SCALE * 0.5));
    }];
    UILabel * buyLbl = [[UILabel alloc] init];
    buyLbl.font = Font15;
    buyLbl.text = @"购买商品";
    [buyV addSubview:buyLbl];
    [buyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buyV.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(buyV.mas_top);
        make.bottom.equalTo(buyV.mas_bottom).offset(-0.5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 15 * IPHONE6_W_SCALE));
    }];
    //
    UIView * line1 = [[UIView alloc] init];
    line1.backgroundColor = Color229;
    [buyV addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buyV.mas_left);
        make.right.equalTo(buyV.mas_right);
        make.bottom.equalTo(buyV.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
    
    // 商品图片
    UIImageView * goodsImage = [[UIImageView alloc] init];
//    goodsImage.backgroundColor = [UIColor redColor];
    [self.view addSubview:goodsImage];
    [goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(buyV.mas_bottom).offset(10 * IPHONE6_H_SCALE);
        make.width.equalTo(@(113 * IPHONE6_W_SCALE));
        make.height.equalTo(@(75 * IPHONE6_W_SCALE));
    }];
    _goodsImage = goodsImage;
    
    // 商品名称
    UILabel * goodNameL = [[UILabel alloc] initWithFrame:CGRectZero];
//    goodNameL.backgroundColor = [UIColor redColor];
    goodNameL.font = Font12;
    goodNameL.numberOfLines = 0;
    goodNameL.preferredMaxLayoutWidth = WIDTH - 152 * IPHONE6_W_SCALE;
    [goodNameL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.view addSubview:goodNameL];
    _goodNameL = goodNameL;
    // 商品积分
    UILabel * goodsNumL = [[UILabel alloc] init];
//    goodsNumL.backgroundColor = [UIColor greenColor];
    goodsNumL.textColor = [UIColor redColor];
    [self.view addSubview:goodsNumL];
    _goodsNumL = goodsNumL;
    // 非会员积分
    UILabel * feVIPLbl = [[UILabel alloc] init];
//    feVIPLbl.backgroundColor = [UIColor redColor];
    feVIPLbl.textColor = Color102;
    feVIPLbl.font = Font12;
    [self.view addSubview:feVIPLbl];
    _feVIPLbl = feVIPLbl;
    // 删除线
    UILabel * deleteLbl = [[UILabel alloc] init];
    deleteLbl.backgroundColor = Color102;
    [feVIPLbl addSubview:deleteLbl];
    [deleteLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(feVIPLbl.mas_centerX);
        make.centerY.equalTo(feVIPLbl.mas_centerY);
        make.width.equalTo(feVIPLbl.mas_width).offset(2);
        make.height.equalTo(@(1));
    }];
    
    UIView * line2 = [[UIView alloc] init];
    line2.backgroundColor = SeparateColor;
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(goodsImage.mas_bottom).offset(18 * IPHONE6_H_SCALE);
        make.height.equalTo(@(0.5 * IPHONE6_H_SCALE));
    }];
    
    UIView * allNumV = [[UIView alloc] init];
    [self.view addSubview:allNumV];
    [allNumV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(line2.mas_bottom);
        make.height.equalTo(@(40 * IPHONE6_H_SCALE));
    }];
    // 当前账户积分
    UILabel * allNumL = [[UILabel alloc] init];
    allNumL.text = @"账户当前积分";
    allNumL.font = Font15;
    [allNumV addSubview:allNumL];
    [allNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(allNumV.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(allNumV.mas_top);
        make.bottom.equalTo(allNumV.mas_bottom);
        make.width.equalTo(@(100 * IPHONE6_W_SCALE));
    }];
    
    UILabel * allNumLbl = [[UILabel alloc] init];
    allNumLbl.textAlignment = NSTextAlignmentRight;
    allNumLbl.font = Font13;
    [allNumV addSubview:allNumLbl];
    [allNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(allNumV.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.top.equalTo(allNumV.mas_top);
        make.bottom.equalTo(allNumV.mas_bottom);
        make.width.equalTo(@(WIDTH * 0.5));
    }];
    _allNumLbl = allNumLbl;
    
    UIView * separateV2 = [[UIView alloc] init];
    separateV2.backgroundColor = SeparateColor;
    [self.view addSubview:separateV2];
    [separateV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(allNumV.mas_bottom);
        make.height.equalTo(@(10 *IPHONE6_H_SCALE));
    }];
    
    //
    UILabel * messageLbl1 = [[UILabel alloc] init];
    messageLbl1.text = @"提示：提交订单后，我们会在24小时之内为您发货，发货前会与您进";
    messageLbl1.font = Font11;
    messageLbl1.textColor = Color153;
    [self.view addSubview:messageLbl1];
    [messageLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.right.equalTo(self.view.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.top.equalTo(separateV2.mas_bottom).offset(30 * IPHONE6_H_SCALE);
        make.height.equalTo(@(11 * IPHONE6_W_SCALE));
    }];
    UILabel * messageLbl2 = [[UILabel alloc] init];
    messageLbl2.text = @"行电话确认订单信息，请确保所填写的电话号码准确无误。";
    messageLbl2.font = Font11;
    messageLbl2.textColor = Color153;
    [self.view addSubview:messageLbl2];
    [messageLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(48 * IPHONE6_W_SCALE);
        make.top.equalTo(messageLbl1.mas_bottom).offset(5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 48 * IPHONE6_W_SCALE));
        make.height.equalTo(@(11 * IPHONE6_W_SCALE));
    }];
    
    UIView * backV = [[UIView alloc] init];
    backV.backgroundColor = SeparateColor;
    [self.view addSubview:backV];
    [backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(messageLbl2.mas_bottom).offset(20 * IPHONE6_H_SCALE);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    // 底部视图
    UIView * bottomV = [[UIView alloc] init];
    bottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(48 * IPHONE6_H_SCALE));
    }];
    
    UIView * lineV = [[UIView alloc] init];
    lineV.backgroundColor = Color216;
    [bottomV addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomV.mas_left);
        make.right.equalTo(bottomV.mas_right);
        make.top.equalTo(bottomV.mas_top);
        make.height.equalTo(@(0.5 * IPHONE6_H_SCALE));
    }];
    // 积分消耗
    UILabel * needNumLbl = [[UILabel alloc] init];
    needNumLbl.textColor = [UIColor redColor];
    needNumLbl.textAlignment = NSTextAlignmentRight;
    needNumLbl.font = Font14;
    [bottomV addSubview:needNumLbl];
    [needNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomV.mas_top);
        make.bottom.equalTo(bottomV.mas_bottom);
        make.right.equalTo(bottomV.mas_right).offset(-157 * IPHONE6_W_SCALE);
        make.width.equalTo(@(WIDTH - 157 * IPHONE6_W_SCALE));
    }];
    _needNumLbl = needNumLbl;
    
    // 提交订单按钮
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor = [UIColor redColor];
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    submitBtn.titleLabel.textColor = [UIColor whiteColor];
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomV.mas_right);
        make.bottom.equalTo(bottomV.mas_bottom);
        make.top.equalTo(bottomV.mas_top);
        make.width.equalTo(@(140 * IPHONE6_H_SCALE));
    }];
    _submitBtn = submitBtn;

}
// 提交订单事件
- (void)submitAction{
    
    [self submitOrder];
   
}

- (void)submitOrder{

    NSLog(@"提交订单...");
    if (_alertLbl.hidden == NO) {   // 如果没有收货地址
        [SVProgressHUD showErrorWithStatus:@"请填写收货地址"];
    }else{
        // 提交消耗积分
        NSDictionary * goodsDic = self.dataDic[@"goods"];
        NSString * shopPrice = goodsDic[@"shop_price"];
        NSString * message = [NSString stringWithFormat:@"提交订单后将会消耗您%@积分，确定提交吗？", shopPrice];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self submitOrderAction];
        }];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancleAction];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (void)submitOrderAction{
    
    NSDictionary * addressDic = self.dataDic[@"address"];
    NSDictionary * goodsDic = self.dataDic[@"goods"];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] =goodsDic[@"goods_id"]; // 商品ID
    parameters[@"address_id"] = addressDic[@"address_id"];  // 地址ID
    [DataTool submitOrderWithStr:submitOrderURL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"msg"] isEqualToString:@"success"]) {
            [self addSuccessView];
        }
    } failure:^(NSError * error) {
        NSLog(@"提交订单出错：%@", error);
    }];
}

// 提交订单成功后的提示框
- (void)addSuccessView{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIImageView * imageV = [[UIImageView alloc] init];
    [backView addSubview:imageV];
    [self.view addSubview:backView];
    imageV.image = [UIImage imageNamed:@"tijiaochenggong"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@(242 * IPHONE6_W_SCALE));
        make.height.equalTo(@(634*0.5*IPHONE6_W_SCALE));
    }];
    UIButton * returnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnView setImage:[UIImage imageNamed:@"fanhuixiangqing"] forState:UIControlStateNormal];
    [backView addSubview:returnView];
    [returnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageV.mas_centerX);
        make.bottom.equalTo(imageV.mas_bottom).offset(-51 *0.5* IPHONE6_W_SCALE);
        make.width.equalTo(@(286 * 0.5*IPHONE6_W_SCALE));
        make.height.equalTo(@(29 * IPHONE6_W_SCALE));
    }];
    [returnView addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
}


// 添加地址事件
- (void)addAddressAction{
    // 跳转到地址选择页面
    SelectAddressVC * selectAddressVC = [[SelectAddressVC alloc] init];
    [self.navigationController pushViewController:selectAddressVC animated:YES];
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
