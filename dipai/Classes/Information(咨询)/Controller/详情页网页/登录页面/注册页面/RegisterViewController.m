//
//  RegisterViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "RegisterViewController.h"
// 自定义textField
#import "LSTextField.h"

#import "DataTool.h"
// 获取验证码的按钮
#import "UIButton+CountDown.h"

#import "SVProgressHUD.h"
#import "Masonry.h"
@interface RegisterViewController ()<UITextFieldDelegate>
{
     NSTimer * _timer;
    int allTime;
    NSString * _previousTextFieldContent;
    UITextRange * _previousSelection;
    
    // 验证码
    
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
@property (nonatomic, strong) LSTextField * password;
/**
 *  密码长度
 */
@property (nonatomic, strong) UILabel * lengthLbl;
// 如无邀请码可不填提示
@property (nonatomic, strong) UILabel * noInvitedLbl;
/**
 *  昵称
 */
@property (nonatomic, strong) LSTextField * name;
// 邀请码
@property (nonatomic, strong) LSTextField * inviteCode;
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

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

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
    titleLabel.text = @"注册";
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
    
    UIView * btnView = [[UIView alloc] init];
//        btnView.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(code.mas_bottom);
    }];
    
    // 获取验证码按钮
    UIButton * getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getCodeBtn.titleLabel.font = Font15;
    getCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    getCodeBtn.backgroundColor = [UIColor blackColor];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor colorWithRed:228 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1] forState:UIControlStateNormal];
//    CGFloat getCodeX = CGRectGetMaxX(line.frame);
//    CGFloat getCodeY = 0;
//    CGFloat getCodeW = codeW - CGRectGetMaxX(line.frame);
//    CGFloat getCodeH = codeH;
//    getCodeBtn.frame = CGRectMake(getCodeX, getCodeY, getCodeW, getCodeH);
//    getCodeBtn.backgroundColor = [UIColor blackColor];
    [getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:getCodeBtn];
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnView.mas_left);
        make.top.equalTo(code.mas_top);
        make.bottom.equalTo(code.mas_bottom);
        make.right.equalTo(code.mas_right);
    }];
    _getCodeBtn = getCodeBtn;
    
    // 密码
    LSTextField * password = [[LSTextField alloc] init];
    password.delegate = self;
    password.secureTextEntry = YES;
    CGFloat passwordX = codeX;
    CGFloat passwordY = CGRectGetMaxY(code.frame) + Margin30 * IPHONE6_H_SCALE;
    CGFloat passwordW = codeW;
    CGFloat passwordH = codeH;
    password.frame = CGRectMake(passwordX, passwordY, passwordW, passwordH);
    password.font = Font17;
    password.myPlaceholder = @"密码";
    [self.view addSubview:password];
    _password = password;
    // 密码长度
    UILabel * lengthLbl = [[UILabel alloc] init];
    lengthLbl.font = Font16;
    lengthLbl.text = @"(密码长度为6-15位)";
    lengthLbl.textColor = Color183;
    CGFloat lengthX = 60*IPHONE6_W_SCALE;
    CGFloat lengthY = 0;
    CGFloat lengthW = WIDTH-lengthX;
    CGFloat lengthH = passwordH;
    lengthLbl.frame = CGRectMake(lengthX, lengthY, lengthW, lengthH);
//    lengthLbl.backgroundColor = [UIColor redColor];
    [password addSubview:lengthLbl];
    _lengthLbl = lengthLbl;
    
    // 昵称
    LSTextField * name = [[LSTextField alloc] init];
    name.delegate = self;
    CGFloat nameX = passwordX;
    CGFloat nameY = CGRectGetMaxY(password.frame);
    CGFloat nameW = passwordW;
    CGFloat nameH = passwordH;
    name.frame = CGRectMake(nameX, nameY, nameW, nameH);
    name.font = Font17;
    name.myPlaceholder = @"昵称";
    [self.view addSubview:name];
    _name = name;
    
    // 邀请码
    LSTextField * inviteCode = [[LSTextField alloc] init];
    inviteCode.delegate = self;
    CGFloat inviteX = nameX;
    CGFloat inviteY = CGRectGetMaxY(name.frame);
    CGFloat inviteW = nameW;
    CGFloat inviteH = nameH;
    inviteCode.frame = CGRectMake(inviteX, inviteY, inviteW, inviteH);
    inviteCode.font = Font17;
    inviteCode.myPlaceholder = @"邀请码 ";
    [self.view addSubview:inviteCode];
    _inviteCode = inviteCode;
    // 如无可不填
    UILabel * noInvitedLbl = [[UILabel alloc] init];
    noInvitedLbl.font = Font16;
    noInvitedLbl.text = @"(如无可不填)";
    noInvitedLbl.textColor = Color183;
    CGFloat noInvitedX = 75*IPHONE6_W_SCALE;
    CGFloat noInvitedY = 0;
    CGFloat noInvitedW = WIDTH-lengthX;
    CGFloat noInvitedH = passwordH;
    noInvitedLbl.frame = CGRectMake(noInvitedX, noInvitedY, noInvitedW, noInvitedH);
    [inviteCode addSubview:noInvitedLbl];
    _noInvitedLbl = noInvitedLbl;
    
    // 注册按钮
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat registerX = nameX;
    CGFloat registerY = CGRectGetMaxY(inviteCode.frame) + Margin42 * IPHONE6_H_SCALE;
    CGFloat registerW = nameW;
    CGFloat registerH = nameH;
    registerBtn.frame = CGRectMake(registerX, registerY, registerW, registerH);
    [registerBtn setImage:[UIImage imageNamed:@"wanchengzhuce_xuanzhong"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
//    registerBtn.userInteractionEnabled = NO;
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
    
    
    NSString * phoneNum = _phoneNum.text;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = phoneNum;
    [DataTool postWithStr:SecurityCodeURL parameters:dic success:^(id responseObject) {
        
        if ([responseObject[@"content"] isEqualToString:@"success"]) {
            NSLog(@"获取验证码成功");
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            [_getCodeBtn setTitleColor:Color153 forState:UIControlStateNormal];
            [_getCodeBtn startWithTime:59 title:@"重新发送" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"content"]];
        }
    } failure:^(NSError * error) {
        NSLog(@"获取验证码出错：%@", error);
    }];

}


#pragma mark --- 对TextField进行监听
- (void)textFieldChanged{
//    NSLog(@"%@", _phoneNum.text);
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
    if (_password.text.length) {
        _password.hidePlaceHolder = YES;
        _lengthLbl.hidden = YES;
        if (_password.text.length > 15) {
            [_password setText:_previousTextFieldContent];
            _password.selectedTextRange = _previousSelection;
        }
    } else
    {
        _password.hidePlaceHolder = NO;
        _lengthLbl.hidden = NO;
    }
    // 昵称
    if (_name.text.length) {
        _name.hidePlaceHolder = YES;
        if (_name.text.length >= 14) {
            [_name setText:_previousTextFieldContent];
            _name.selectedTextRange = _previousSelection;
        }
    } else
    {
        _name.hidePlaceHolder = NO;
    }
    // 邀请码
    if (_inviteCode.text.length) {
        _inviteCode.hidePlaceHolder = YES;
        _noInvitedLbl.hidden = YES;
    } else
    {
        _inviteCode.hidePlaceHolder = NO;
        _noInvitedLbl.hidden = NO;
    }
    
    // 即使没有邀请码也能点击注册  因为如果没有邀请码可不填
//    if (_phoneNum.text.length == 11 && _code.text.length && _password.text.length >= 6 && _name.text.length>2) {
//        [_registerBtn setImage:[UIImage imageNamed:@"wanchengzhuce_xuanzhong"] forState:UIControlStateNormal];
//        _registerBtn.userInteractionEnabled = YES;
//        [_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
//    } else
//    {
//        [_registerBtn setImage:[UIImage imageNamed:@"wanchengzhuce_moren"] forState:UIControlStateNormal];
//        _registerBtn.userInteractionEnabled = NO;
//    }
}

#pragma mark --- 注册事件
- (void)registerAction{
    
    // 验证手机号是否合法
    BOOL boo = [self verifyMobile:_phoneNum.text];
    
    if (boo) {  // 手机号合法
        // 判断昵称是否包含空格
        NSRange _range = [_name.text rangeOfString:@" "];
        if (_range.location != NSNotFound) {
            //有空格
            [SVProgressHUD showErrorWithStatus:@"昵称不能包含空格"];
        }else {
            

            if (_code.text.length >0) { // 验证码不为空
                if (_password.text.length >=6 && _password.text.length <= 15) { // 密码长度合法
                    if (_name.text.length <3) {
                        [SVProgressHUD showErrorWithStatus:@"昵称最少3个字符"];
                    }else{  // 昵称长度合法
                        
                        // 完全合法之后发送数据请求
                        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                        NSString * deviceToken = [defaults objectForKey:DipaiDevice];
                        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                        dic[@"phone"] = _phoneNum.text;
                        dic[@"username"] = _name.text;
                        dic[@"password"] = _password.text;
                        dic[@"verify"] = _code.text;
                        dic[@"system"] = @"1";  // 代表iPhone手机
                        dic[@"device"] = deviceToken;
                        if (_inviteCode.text.length > 0) {
                            dic[@"istration_id"] = _inviteCode.text;
                        }
                        //    http://10.0.0.14:8080/app/register?&phone=18730602439&username=liangsen&password=hahh
                        [DataTool postWithStr:RegisterURL parameters:dic success:^(id responsObject) {
                            
                            NSLog(@"注册成功返回的数据%@", responsObject);
                            NSString * content = [responsObject objectForKey:@"content"];
                            NSString * state = [responsObject objectForKey:@"state"];
                            if ([state isEqualToString:@"1"]) {
                                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                                NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                                for (NSHTTPCookie * cookie in cookies) {
                                    NSString * name = [cookie name];
                                    NSLog(@"---name---%@", name);
                                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                                    [defaults setObject:name forKey:Cookie];
                                    [defaults synchronize];
                                    NSString * phone = @"phone";
                                    [defaults setObject:phone forKey:Phone];
                                    
                                    NSDictionary * dataDic = [responsObject objectForKey:@"data"];
                                    NSString * userid = dataDic[@"userid"];
//                                    [UMessage addAlias:userid type:@"ALIAS_TYPE.DIPAI" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//                                        NSLog(@"添加别名...");
//                                        NSLog(@"---responseObject---%@", responseObject);
//                                        NSLog(@"---error----%@", error);
//                                    }];
                                }
                                
                                if ([self.delegate respondsToSelector:@selector(dismissAfterRegister)]) {
                                    [self.delegate dismissAfterRegister];
                                } else{
                                    NSLog(@"RegisterViewController的代理没有响应...");
                                }
                                
                                [NSThread sleepForTimeInterval:1.3];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            }else{
                                
                                [SVProgressHUD showErrorWithStatus:content];
                            }
                            
                            
                        } failure:^(NSError * error) {
                            
                            NSLog(@"注册的错误信息%@", error);
                        }];

                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:@"密码无效"];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"验证码无效"];
            }
 
        }
        
    } else{
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

#pragma mark --- 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNum resignFirstResponder];
    [_code resignFirstResponder];
    [_password resignFirstResponder];
    [_name resignFirstResponder];
    [_inviteCode resignFirstResponder];
}

#pragma mark --- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    _previousSelection = textField.selectedTextRange;
    _previousTextFieldContent = textField.text;
    
    // 第一个数字不能输入大于1的数字
//    if (range.location == 0) {
//        if (string.integerValue > 1) {
//            return NO;
//        }
//    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
