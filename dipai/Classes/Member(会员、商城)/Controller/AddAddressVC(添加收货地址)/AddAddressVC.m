//
//  AddAddressVC.m
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AddAddressVC.h"

#import "LSTextField.h"
#import "Masonry.h"
#import "DataTool.h"

#import "SVProgressHUD.h"
@interface AddAddressVC ()<UITextFieldDelegate>
{
    
    NSString * _manStr;  // 男性按钮被选中的标记
    NSString * _femanStr;    // 女性按钮被选中的标记
    
    NSString * _previousTextFieldContent;
    UITextRange * _previousSelection;
}
// 确定按钮
@property (nonatomic, strong) UIButton * sureBtn;
// 姓名
@property (nonatomic, strong)  LSTextField * nameLbl ;
// 手机号
@property (nonatomic, strong) LSTextField * phoneLbl;
// 地址
@property (nonatomic, strong) LSTextField * addressLbl ;
// 详细地址
@property (nonatomic, strong) LSTextField * detailAddLbl;
// 男性按钮
@property (nonatomic, strong) UIButton * manBtn;
// 女性按钮
@property (nonatomic, strong) UIButton * feManBtn;

@end

@implementation AddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBA(240, 238, 245, 1);
    
    [self setNavigationBar];
    
    [self setUpUI];
    
    // 对UITextField添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldChanged{
    
    if (_nameLbl.text.length > 0) {
        _nameLbl.placeHolderLabel.hidden = YES;
    }else{
        _nameLbl.placeHolderLabel.hidden = NO;
    }
    
    if (_phoneLbl.text.length > 0) {
        _phoneLbl.placeHolderLabel.hidden = YES;
    }else{
        _phoneLbl.placeHolderLabel.hidden = NO;
    }
    if (_phoneLbl.text.length > 11) {
        [_phoneLbl setText:_previousTextFieldContent];
        _phoneLbl.selectedTextRange = _previousSelection;
    }
    
    if (_addressLbl.text.length > 0) {
        _addressLbl.placeHolderLabel.hidden = YES;
    }else{
        _addressLbl.placeHolderLabel.hidden = NO;
    }
    
    if (_detailAddLbl.text.length > 0) {
        _detailAddLbl.placeHolderLabel.hidden = YES;
    }else{
        _detailAddLbl.placeHolderLabel.hidden = NO;
    }
    
    if (_nameLbl.text.length > 0 && _phoneLbl.text.length > 0   && _addressLbl.text.length > 0  && _detailAddLbl.text.length > 0  &&(_manBtn.selected == YES || _feManBtn.selected == YES) ) {   // 能按钮确定键
        _sureBtn.userInteractionEnabled = YES;
        [_sureBtn setBackgroundColor:RGBA(288, 0, 0, 1)];
    }else{
        
        _sureBtn.userInteractionEnabled = NO;
        [_sureBtn setBackgroundColor:Color153];
    }
}

- (void)setNavigationBar{
    
    self.naviBar.titleLbl.hidden = YES;
    self.naviBar.popV.hidden = NO;
    self.naviBar.leftStr = @"取消";
    [self.naviBar.popBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLbl = [[UILabel alloc] init];
    [self.view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@(44));
        make.width.equalTo(@(160 * IPHONE6_W_SCALE));
    }];
    titleLbl.text = @"新增收货地址";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment =  NSTextAlignmentCenter;
}

- (void)setUpUI{
    
    UIView * backV = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 30 *IPHONE6_H_SCALE, WIDTH, 456 * 0.5 * IPHONE6_H_SCALE)];
    backV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backV];
    
    
    NSMutableArray * lineArr = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(15 * IPHONE6_W_SCALE, 44 * IPHONE6_H_SCALE + i * 44 * IPHONE6_H_SCALE, WIDTH - 15 * IPHONE6_W_SCALE, 0.5 * IPHONE6_H_SCALE)];
        lineV.backgroundColor = RGBA(15, 15, 15, 1);
        lineV.backgroundColor = SeparateColor;
        lineV.tag = 0;
        [backV addSubview:lineV];
        [lineArr addObject:lineV];
    }
    // 联系人
    UILabel * nameForeLbl = [[UILabel alloc] init];
    nameForeLbl.text = @"联系人";
    nameForeLbl.font = Font15;
    [backV addSubview:nameForeLbl];
    [nameForeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backV.mas_top);
        make.height.equalTo(@(44 * IPHONE6_H_SCALE));
        make.left.equalTo(backV.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.width.equalTo(@(89 * IPHONE6_W_SCALE));
    }];
    
    LSTextField * nameLbl = [[LSTextField alloc] init];
//    nameLbl.backgroundColor = [UIColor redColor];
    nameLbl.font = Font15;
    nameLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    nameLbl.myPlaceholder = @"你的姓名";
    nameLbl.placeHolderX = 10 * IPHONE6_W_SCALE;
    nameLbl.placeHolderY = 0.01;
//    nameLbl.placeHolderLabel.backgroundColor = [UIColor blackColor];
    [backV addSubview:nameLbl];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backV.mas_left).offset(79 * IPHONE6_W_SCALE);
        make.centerY.equalTo(nameForeLbl.mas_centerY);
        make.width.equalTo(@(WIDTH - 89 * IPHONE6_W_SCALE));
        make.height.equalTo(@(20 * IPHONE6_H_SCALE));
    }];
    _nameLbl = nameLbl;
    
    // 选择性别
    UIButton * manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [manBtn addTarget:self action:@selector(selectManAction:) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:manBtn];
    UIView * line1 = [lineArr objectAtIndex:0];
    [manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backV.mas_left).offset(178 * 0.5* IPHONE6_W_SCALE);
        make.top.equalTo(line1.mas_bottom);
        make.width.equalTo(@(20 * IPHONE6_W_SCALE));
        make.height.equalTo(@(44 * IPHONE6_H_SCALE));
    }];
    _manBtn = manBtn;
    [manBtn setImage:[UIImage imageNamed:@"xuanze_moren"] forState:UIControlStateNormal];
    [manBtn setImage:[UIImage imageNamed:@"xuanze_xuanzhong"] forState:UIControlStateSelected];
    UILabel * manLbl = [[UILabel alloc] init];
    manLbl.text = @"先生";
    manLbl.font = Font15;
    [backV addSubview:manLbl];
    [manLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(manBtn.mas_right).offset(13 * IPHONE6_W_SCALE);
        make.width.equalTo(@(35 * IPHONE6_W_SCALE));
        make.height.equalTo(@(44 * IPHONE6_W_SCALE));
        make.top.equalTo(line1.mas_bottom);
    }];
    UIButton * feManBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [feManBtn addTarget:self action:@selector(selectFeManAction:) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:feManBtn];
    [feManBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(manBtn.mas_right).offset(75 * IPHONE6_W_SCALE);
        make.top.equalTo(line1.mas_bottom);
        make.width.equalTo(@(20 * IPHONE6_W_SCALE));
        make.height.equalTo(@(44 * IPHONE6_H_SCALE));
    }];
    _feManBtn = feManBtn;
    [feManBtn setImage:[UIImage imageNamed:@"xuanze_moren"] forState:UIControlStateNormal];
    [feManBtn setImage:[UIImage imageNamed:@"xuanze_xuanzhong"] forState:UIControlStateSelected];
    UILabel * feManLbl = [[UILabel alloc] init];
    feManLbl.text = @"女士";
    feManLbl.font = Font15;
    [backV addSubview:feManLbl];
    [feManLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(feManBtn.mas_right).offset(13 * IPHONE6_W_SCALE);
        make.width.equalTo(@(35 * IPHONE6_W_SCALE));
        make.height.equalTo(@(44 * IPHONE6_W_SCALE));
        make.top.equalTo(line1.mas_bottom);
    }];
    
    // 联系电话
    UIView * line2 = [lineArr objectAtIndex:1];
    UILabel * phoneForeLbl = [[UILabel alloc] init];
    phoneForeLbl.font = Font15;
    phoneForeLbl.text = @"联系电话";
    [backV addSubview:phoneForeLbl];
    [phoneForeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backV.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.width.equalTo(@(70 * IPHONE6_W_SCALE));
        make.height.equalTo(@(44 * IPHONE6_H_SCALE));
        make.top.equalTo(line2.mas_bottom);
    }];
    
    LSTextField * phoneLbl = [[LSTextField alloc] init];
    phoneLbl.font = Font15;
    [backV addSubview:phoneLbl];
    phoneLbl.delegate = self;
    phoneLbl.keyboardType = UIKeyboardTypeNumberPad;
    phoneLbl.myPlaceholder = @"你的手机号";
    phoneLbl.placeHolderX = 10 * IPHONE6_W_SCALE;
    phoneLbl.placeHolderY = 0.01;
    phoneLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    [phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backV.mas_left).offset(79 * IPHONE6_W_SCALE);
        make.centerY.equalTo(phoneForeLbl.mas_centerY);
        make.width.equalTo(@(WIDTH - 89 * IPHONE6_W_SCALE));
        make.height.equalTo(@(20 * IPHONE6_H_SCALE));
    }];
    _phoneLbl = phoneLbl;
    // 收货地址
    UIView * line3 = [lineArr objectAtIndex:2];
    UILabel * addressForeLbl = [[UILabel alloc] init];
    addressForeLbl.font = Font15;
    addressForeLbl.text = @"收货地址";
    [backV addSubview:addressForeLbl];
    [addressForeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backV.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.width.equalTo(@(70 * IPHONE6_W_SCALE));
        make.height.equalTo(@(44 * IPHONE6_H_SCALE));
        make.top.equalTo(line3.mas_bottom);
    }];
    
    LSTextField * addressLbl = [[LSTextField alloc] init];
    addressLbl.font = Font15;
    addressLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    addressLbl.myPlaceholder = @"小区／写字楼／学校等";
    addressLbl.placeHolderY = 0.01;
    addressLbl.placeHolderX = 10 * IPHONE6_W_SCALE;
    [backV addSubview:addressLbl];
    [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backV.mas_left).offset(79 * IPHONE6_W_SCALE);
        make.centerY.equalTo(addressForeLbl.mas_centerY);
        make.width.equalTo(@(WIDTH - 89 * IPHONE6_W_SCALE));
        make.height.equalTo(@(20 * IPHONE6_H_SCALE));
    }];
    _addressLbl = addressLbl;
    // 详细地址
    UIView * line4 = [lineArr objectAtIndex:3];
    LSTextField * detailAddLbl = [[LSTextField alloc] init];
    detailAddLbl.font = Font15;
    detailAddLbl.myPlaceholder = @"详细地址（如门牌号等）";
    detailAddLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    detailAddLbl.placeHolderX = 10 * IPHONE6_W_SCALE;
    detailAddLbl.placeHolderY = 0.01;
    [backV addSubview:detailAddLbl];
    [detailAddLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line4.mas_bottom).offset(15 * IPHONE6_H_SCALE);
        make.left.equalTo(backV.mas_left).offset(79 * IPHONE6_W_SCALE);
        make.width.equalTo(@(WIDTH - 79 * IPHONE6_W_SCALE));
        make.height.equalTo(@(20 * IPHONE6_H_SCALE));
    }];
    _detailAddLbl = detailAddLbl;
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.userInteractionEnabled = NO;
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(backV.mas_bottom).offset(30 * IPHONE6_H_SCALE);
        make.width.equalTo(@(345 * IPHONE6_W_SCALE));
        make.height.equalTo(@(48 * IPHONE6_W_SCALE));
    }];
    sureBtn.layer.cornerRadius = 4 * IPHONE6_W_SCALE;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:Color153];
    _sureBtn = sureBtn;
    
    
}
// 选择男性事件
- (void)selectManAction:(UIButton *)manBtn{
    manBtn.selected = !manBtn.selected;
    if (manBtn.selected == YES) {
        _feManBtn.selected = NO;
        _manStr = @"manStr";
    }else{
        _manStr = nil;
    }
    
    if (manBtn.selected == YES && _nameLbl.text.length > 0 && _phoneLbl.text.length > 0   && _addressLbl.text.length > 0  && _detailAddLbl.text.length > 0) {
        _sureBtn.userInteractionEnabled = YES;
        [_sureBtn setBackgroundColor:RGBA(288, 0, 0, 1)];
    }else{
        
        _sureBtn.userInteractionEnabled = NO;
        [_sureBtn setBackgroundColor:Color153];
    }
}
// 选择女性事件
- (void)selectFeManAction:(UIButton *)femanBtn{
    
    femanBtn.selected = !femanBtn.selected;
    if (femanBtn.selected == YES) {
        _manBtn.selected = NO;
        _femanStr = @"femanStr";
    }else{
        
        _femanStr = nil;
    }
    
    if (femanBtn.selected == YES && _nameLbl.text.length > 0 && _phoneLbl.text.length > 0   && _addressLbl.text.length > 0  && _detailAddLbl.text.length > 0) {
        _sureBtn.userInteractionEnabled = YES;
        [_sureBtn setBackgroundColor:RGBA(288, 0, 0, 1)];
    }else{
        
        _sureBtn.userInteractionEnabled = NO;
        [_sureBtn setBackgroundColor:Color153];
    }
}
// 确定按钮点击事件
- (void)sureAction{
    [HttpTool GET:MemberCenter parameters:nil success:^(id responseObject) {
        NSString * state = responseObject[@"state"];
        if ([state isEqualToString:@"99"]) {    // 异地登录
            UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您的帐号已经在其它设备登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 确定按钮做两个操作：1.退出登录  2.回到根视图
                [OutLoginTool outLoginAction];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alertC addAction:OK];
            [self presentViewController:alertC animated:YES completion:nil];
        }else{
            [self addAddressAction];
        }
    } failure:^(NSError *error) {
        
    }];
}
// 添加地址事件
- (void)addAddressAction{
    
    //  判断手机号是否合法
    BOOL yes = [self verifyMobile:_phoneLbl.text];
    if (yes) {
        NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
        parameters[@"address_name"] = _nameLbl.text;
        if (_manBtn.selected == YES) {
            parameters[@"gender"] = @"1";
        }else{
            parameters[@"gender"] = @"2";
        }
        parameters[@"district"] = _addressLbl.text;
        parameters[@"address"] = _detailAddLbl.text;
        parameters[@"mobile"] = _phoneLbl.text;
        [DataTool postAddressWithStr:AddAddressURL parameters:parameters success:^(id responseObject) {
            
            if ([responseObject[@"msg"] isEqualToString:@"success"]) {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                [self dismissAction];
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"添加失败"];
            }
        } failure:^(NSError * error) {
            NSLog(@"获取数据出错：%@", error);
        }];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号不合法"];
    }
}

#pragma mark --- 验证手机号是否合法
- (BOOL)verifyMobile:(NSString *)mobilePhone{
    NSString *express = @"^0{0,1}(13[0-9]|15[0-9]|18[0-9]|14[0-9])[0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF matches %@", express];
    BOOL boo = [pred evaluateWithObject:mobilePhone];
    return boo;
}

#pragma mark ---UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    _previousSelection = textField.selectedTextRange;
    _previousTextFieldContent = textField.text;
    return YES;
}
- (void)dismissAction{
    [HttpTool GET:MemberCenter parameters:nil success:^(id responseObject) {
        NSString * state = responseObject[@"state"];
        if ([state isEqualToString:@"99"]) {    // 异地登录
            UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您的帐号已经在其它设备登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 确定按钮做两个操作：1.退出登录  2.回到根视图
                [OutLoginTool outLoginAction];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alertC addAction:OK];
            [self presentViewController:alertC animated:YES completion:nil];
        }else{
           [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
