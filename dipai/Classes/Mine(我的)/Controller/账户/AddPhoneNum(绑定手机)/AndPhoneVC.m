//
//  AndPhoneVC.m
//  dipai
//
//  Created by 梁森 on 16/7/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AndPhoneVC.h"
// 自定义textField
#import "LSTextField.h"

#import "DataTool.h"
// 获取验证码的按钮
#import "UIButton+CountDown.h"

#import "SVProgressHUD.h"
@interface AndPhoneVC ()<UITextFieldDelegate>
{
    NSTimer * _timer;
    int allTime;
    NSString * _previousTextFieldContent;
    UITextRange * _previousSelection;
}
/**
 *  手机号
 */
@property (nonatomic, strong) LSTextField * phoneNum;
/**
 *  验证码
 */
@property (nonatomic, strong) LSTextField * code;
/**
 *  密码
 */
//@property (nonatomic, strong) LSTextField * password;
/**
 *  密码长度
 */
@property (nonatomic, strong) UILabel * lengthLbl;
/**
 *  昵称
 */
@property (nonatomic, strong) LSTextField * name;
/**
 *  注册按钮
 */
@property (nonatomic, strong) UIButton * registerBtn;
/**
 *  计时
 */
@property (nonatomic, strong) UIButton * secondBtn;
/**
 *  获取验证码按钮
 */
@property (nonatomic, strong) UIButton * getCodeBtn;
/**
 *  竖线
 */
@property (nonatomic, strong) UIView * line;

@end

@implementation AndPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    
    // 设置导航栏内容
    [self setUpNavigationBar];
    
    // 设置UI
    [self setUpUI];
    
    // 对UITextField添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:nil];
    allTime = 60;
}
#pragma mark --- 设置导航栏内容
- (void)setUpNavigationBar{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
    
    // 左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui"] target:self action:@selector(cancelRegister) forControlEvents:UIControlEventTouchUpInside];
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:38/2];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"绑定手机";
    self.navigationItem.titleView = titleLabel;
}

#pragma mark --- 设置UI
- (void)setUpUI{
    // 手机号
    CGFloat numX = Margin40 * IPHONE6_W_SCALE;
    CGFloat numY = Margin60 * IPHONE6_H_SCALE;
    CGFloat numW = WIDTH - 2 * numX;
    CGFloat numH = Margin100 * IPHONE6_H_SCALE;
    LSTextField * phoneNum = [[LSTextField alloc] initWithFrame:CGRectMake(numX, numY, numW, numH)];
    phoneNum.delegate = self;
    //    phoneNum.backgroundColor = [UIColor whiteColor];
    phoneNum.myPlaceholder = @"手机号";
    phoneNum.font = Font17;
    phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneNum];
    _phoneNum = phoneNum;
    
    // 横线
    CGFloat line1X = numX;
    CGFloat line1Y = CGRectGetMaxY(phoneNum.frame);
    CGFloat line1W = numW;
    CGFloat line1H = 0;
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(line1X, line1Y, line1W, line1H)];
    line1.backgroundColor = [UIColor colorWithRed:227 / 255.0 green:227 / 255.0 blue:227 / 255.0 alpha:1];
    [self.view addSubview:line1];
    
    // 验证码
    CGFloat codeX = numX;
    CGFloat codeY = CGRectGetMaxY(line1.frame);
    CGFloat codeW = line1W;
    CGFloat codeH = numH;
    LSTextField * code = [[LSTextField alloc] initWithFrame:CGRectMake(codeX, codeY, codeW, codeH)];
    code.delegate = self;
    code.font = Font17;
    code.myPlaceholder = @"验证码";
    [self.view addSubview:code];
    _code = code;
    
    
    // 竖线
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color216;
    CGFloat lineX = 475 / 2 * IPHONE6_W_SCALE;
    CGFloat liney = Margin36 * IPHONE6_H_SCALE;
    CGFloat lineW = 0.5;
    CGFloat lineH = 15 * IPHONE6_H_SCALE;
    line.frame = CGRectMake(lineX, liney, lineW, lineH);
    [code addSubview:line];
    _line = line;
    // 获取验证码按钮
    UIButton * getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getCodeBtn.titleLabel.font = Font15;
    getCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    getCodeBtn.backgroundColor = [UIColor blackColor];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor colorWithRed:228 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1] forState:UIControlStateNormal];
    CGFloat getCodeX = CGRectGetMaxX(line.frame);
    CGFloat getCodeY = 0;
    CGFloat getCodeW = codeW - CGRectGetMaxX(line.frame);
    CGFloat getCodeH = codeH;
    getCodeBtn.frame = CGRectMake(getCodeX, getCodeY, getCodeW, getCodeH);
    //    getCodeBtn.backgroundColor = [UIColor blackColor];
    [getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [code addSubview:getCodeBtn];
    _getCodeBtn = getCodeBtn;

    
    // 注册按钮
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat registerX = codeX;
    CGFloat registerY = CGRectGetMaxY(code.frame) + Margin42 * IPHONE6_H_SCALE;
    CGFloat registerW = codeW;
    CGFloat registerH = codeH;
    registerBtn.frame = CGRectMake(registerX, registerY, registerW, registerH);
//    [registerBtn setImage:[UIImage imageNamed:@"wanchengzhuce_moren"] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"queren_moren"] forState:UIControlStateNormal];
    registerBtn.userInteractionEnabled = NO;
    [self.view addSubview:registerBtn];
    _registerBtn = registerBtn;
}

#pragma mark --- 取消注册事件
- (void)cancelRegister{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 获取验证码的事件
- (void)getCodeAction{
    /*
     *    倒计时按钮
     *    @param timeLine  倒计时总时间
     *    @param title     还没倒计时的title
     *    @param subTitle  倒计时的子名字 如：时、分
     *    @param mColor    还没倒计时的颜色
     *    @param color     倒计时的颜色
     */
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = _phoneNum.text;
    [DataTool postWithStr:SecurityCodeURL parameters:dic success:^(id responseObject) {
        
//        NSLog(@"获取验证码成功：%@", responseObject);
//        NSLog(@"content:%@", responseObject[@"content"]);
        NSString * content = responseObject[@"content"];
        if ([responseObject[@"state"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:content];
        }
        if ([responseObject[@"content"] isEqualToString:@"您请求次数过多，请稍后再发"]) {
            [SVProgressHUD showErrorWithStatus:@"请求过于频繁,请稍后再试"];
        }
    } failure:^(NSError * error) {
        NSLog(@"获取验证码出错%@", error);
    }];
    [_getCodeBtn setTitleColor:Color153 forState:UIControlStateNormal];
    [_getCodeBtn startWithTime:60 title:@"重新发送" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
    
}


#pragma mark --- 对TextField进行监听
- (void)textFieldChanged{
    NSLog(@"%@", _phoneNum.text);
    // 手机号
    if (_phoneNum.text.length) {
        _phoneNum.hidePlaceHolder = YES;
        if (_phoneNum.text.length > 11) {   // 手机号码最长为11位
            [_phoneNum setText:_previousTextFieldContent];
            _phoneNum.selectedTextRange = _previousSelection;
        }
    }else
    {
        _phoneNum.hidePlaceHolder = NO;
    }
    // 验证码
    if (_code.text.length) {
        _code.hidePlaceHolder = YES;
    } else
    {
        _code.hidePlaceHolder = NO;
    }
    // 密码
//    if (_password.text.length) {
//        _password.hidePlaceHolder = YES;
//        _lengthLbl.hidden = YES;
//        if (_password.text.length > 15) {
//            [_password setText:_previousTextFieldContent];
//            _password.selectedTextRange = _previousSelection;
//        }
//    } else
//    {
//        _password.hidePlaceHolder = NO;
//        _lengthLbl.hidden = NO;
//    }
    // 昵称
//    if (_name.text.length) {
//        _name.hidePlaceHolder = YES;
//        if (_name.text.length > 14) {
//            [_name setText:_previousTextFieldContent];
//            _name.selectedTextRange = _previousSelection;
//        }
//    } else
//    {
//        _name.hidePlaceHolder = NO;
//    }
    
    if (_phoneNum.text.length == 11 && _code.text.length) {
//        [_registerBtn setImage:[UIImage imageNamed:@"wanchengzhuce_xuanzhong"] forState:UIControlStateNormal];
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"queren_xuanzhong"] forState:UIControlStateNormal];
        _registerBtn.userInteractionEnabled = YES;
        [_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    } else
    {
//        [_registerBtn setImage:[UIImage imageNamed:@"wanchengzhuce_moren"] forState:UIControlStateNormal];
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"queren_moren"] forState:UIControlStateNormal];
        _registerBtn.userInteractionEnabled = NO;
    }
}

#pragma mark --- 绑定手机号事件
- (void)registerAction{
    
    BOOL boo = [self verifyMobile:_phoneNum.text];
    if (boo) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"verify"] = _code.text;
        dic[@"phone"] = _phoneNum.text;
//        dic[@"password"] = _password.text;
        NSLog(@"%@----%@", _code.text, _phoneNum.text);
        //    http://10.0.0.14:8080/app/register?&phone=18730602439&username=liangsen&password=hahh
        [DataTool postWithStr:AddPhoURL parameters:dic success:^(id responsObject) {
            
//            NSLog(@"绑定手机成功返回的数据%@", responsObject);
//            NSLog(@"content:%@", responsObject[@"content"]);
            if ([responsObject[@"state"] isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:responsObject[@"content"]];
            }
            
        } failure:^(NSError * error) {
            
            NSLog(@"绑定手机的错误信息%@", error);
        }];
    } else{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"手机号不合法" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:OK];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
#pragma mark --- 验证手机号是否合法
- (BOOL)verifyMobile:(NSString *)mobilePhone{
    NSString *express = @"^0{0,1}(13[0-9]|15[0-9]|18[0-9]|14[0-9])[0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF matches %@", express];
    BOOL boo = [pred evaluateWithObject:mobilePhone];
    return boo;
}

#pragma mark --- 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNum resignFirstResponder];
    [_code resignFirstResponder];

    
}

#pragma mark --- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    _previousSelection = textField.selectedTextRange;
    _previousTextFieldContent = textField.text;
    
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
