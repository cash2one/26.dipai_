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

#import "AFNetworking.h"
@interface RegisterViewController ()
{
     NSTimer * _timer;
    int allTime;
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

@implementation RegisterViewController

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
//    phoneNum.backgroundColor = [UIColor whiteColor];
    phoneNum.myPlaceholder = @"手机号";
    phoneNum.font = [UIFont systemFontOfSize:17];
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
    code.font = [UIFont systemFontOfSize:17];
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
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    getCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    getCodeBtn.backgroundColor = [UIColor blackColor];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor colorWithRed:228 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1] forState:UIControlStateNormal];
    CGFloat getCodeX = CGRectGetMaxX(line.frame) + Margin20 * IPHONE6_W_SCALE;
    CGFloat getCodeY = 35 / 2 * IPHONE6_H_SCALE;
    NSMutableDictionary * getDic = [NSMutableDictionary dictionary];
    getDic[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    CGSize getCodeSize = [getCodeBtn.titleLabel.text sizeWithAttributes:getDic];
    getCodeBtn.frame = (CGRect){{getCodeX, getCodeY}, getCodeSize};
//    getCodeBtn.backgroundColor = [UIColor blackColor];
    [getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [code addSubview:getCodeBtn];
    _getCodeBtn = getCodeBtn;
    
    UIButton * secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondBtn setTitle:@"60s" forState:UIControlStateNormal];
    secondBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [secondBtn setTitleColor:Color153 forState:UIControlStateNormal];
    CGFloat secondX = CGRectGetMaxX(line.frame) + 68/2*IPHONE6_W_SCALE;
    CGFloat secondY = 36 / 2 * IPHONE6_H_SCALE;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    CGSize secondSize = [secondBtn.titleLabel.text sizeWithAttributes:dic];
//    secondBtn.backgroundColor = [UIColor redColor];
    secondBtn.frame = (CGRect){{secondX, secondY}, secondSize};
    [_code addSubview:secondBtn];
    _secondBtn = secondBtn;
    _secondBtn.hidden = YES;
    
    // 密码
    LSTextField * password = [[LSTextField alloc] init];
    CGFloat passwordX = codeX;
    CGFloat passwordY = CGRectGetMaxY(code.frame) + Margin30 * IPHONE6_H_SCALE;
    CGFloat passwordW = codeW;
    CGFloat passwordH = codeH;
    password.frame = CGRectMake(passwordX, passwordY, passwordW, passwordH);
    password.font = [UIFont systemFontOfSize:17];
    password.myPlaceholder = @"密码";
    [self.view addSubview:password];
    _password = password;
    // 密码长度
    UILabel * lengthLbl = [[UILabel alloc] init];
    lengthLbl.font = Font11;
    lengthLbl.text = @"密码长度为6-15位";
    lengthLbl.textColor = Color183;
    CGFloat lengthX = Margin169 * IPHONE6_W_SCALE;
    CGFloat lengthY = Margin39 * IPHONE6_H_SCALE;
    CGFloat lengthW = 150;
    CGFloat lengthH = 11;
    lengthLbl.frame = CGRectMake(lengthX, lengthY, lengthW, lengthH);
    [password addSubview:lengthLbl];
    _lengthLbl = lengthLbl;
    
    // 昵称
    LSTextField * name = [[LSTextField alloc] init];
    CGFloat nameX = passwordX;
    CGFloat nameY = CGRectGetMaxY(password.frame);
    CGFloat nameW = passwordW;
    CGFloat nameH = passwordH;
    name.frame = CGRectMake(nameX, nameY, nameW, nameH);
    name.font = [UIFont systemFontOfSize:17];
    name.myPlaceholder = @"昵称";
    [self.view addSubview:name];
    _name = name;
    
    // 注册按钮
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat registerX = nameX;
    CGFloat registerY = CGRectGetMaxY(name.frame) + Margin42 * IPHONE6_H_SCALE;
    CGFloat registerW = nameW;
    CGFloat registerH = nameH;
    registerBtn.frame = CGRectMake(registerX, registerY, registerW, registerH);
    [registerBtn setImage:[UIImage imageNamed:@"wanchengzhuce_moren"] forState:UIControlStateNormal];
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
    NSLog(@"获取验证码");
    _getCodeBtn.hidden = YES;
    _secondBtn.hidden = NO;
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wait) userInfo:nil repeats:YES];
    // 立即启动
    [timer fire];
    _timer = timer;
//    [NSTimer scheduledTimerWithTimeInterval:61 target:self selector:@selector(changeColor) userInfo:nil repeats:nil];
}

- (void)wait
{
    [_secondBtn setTitle:[NSString stringWithFormat:@"%ds", allTime --] forState:0];
    CGFloat secondX = CGRectGetMaxX(_line.frame) + 68/2*IPHONE6_W_SCALE;
    CGFloat secondY = 36 / 2 * IPHONE6_H_SCALE;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    CGSize secondSize = [_secondBtn.titleLabel.text sizeWithAttributes:dic];
    _secondBtn.frame = (CGRect){{secondX, secondY}, secondSize};
    if (allTime < 0) {
        [_timer invalidate];
        _getCodeBtn.hidden = NO;
        _secondBtn.hidden = YES;
        [_secondBtn setTitle:@"60s" forState:UIControlStateNormal];
    }
}


#pragma mark --- 对TextField进行监听
- (void)textFieldChanged{
    NSLog(@"%@", _phoneNum.text);
    // 手机号
    if (_phoneNum.text.length) {
        _phoneNum.hidePlaceHolder = YES;
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
    } else
    {
        _password.hidePlaceHolder = NO;
        _lengthLbl.hidden = NO;
    }
    // 昵称
    if (_name.text.length) {
        _name.hidePlaceHolder = YES;
    } else
    {
        _name.hidePlaceHolder = NO;
    }
    
    if (_phoneNum.text.length && _code.text.length && _password.text.length && _name.text.length) {
        [_registerBtn setImage:[UIImage imageNamed:@"wanchengzhuce_xuanzhong"] forState:UIControlStateNormal];
        _registerBtn.userInteractionEnabled = YES;
        [_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    } else
    {
        [_registerBtn setImage:[UIImage imageNamed:@"wanchengzhuce_moren"] forState:UIControlStateNormal];
        _registerBtn.userInteractionEnabled = NO;
    }
}

#pragma mark --- 注册事件
- (void)registerAction{
    NSLog(@"进行注册");
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = @"18730602439";
    dic[@"username"] = @"liangsen";
    dic[@"password"] = @"hahh";
//    http://192.168.1.102:8080/app/register?&phone=18730602439&username=liangsen&password=hahh
    [DataTool postWithStr:RegisterURL parameters:dic success:^(id responsObject) {
        
        NSLog(@"注册成功返回的数据%@", responsObject);
        
    } failure:^(NSError * error) {
        
        NSLog(@"注册的错误信息%@", error);
    }];
}

#pragma mark --- 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNum resignFirstResponder];
    [_code resignFirstResponder];
    [_password resignFirstResponder];
    [_name resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
