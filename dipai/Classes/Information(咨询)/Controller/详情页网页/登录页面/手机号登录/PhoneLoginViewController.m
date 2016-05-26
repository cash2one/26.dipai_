//
//  PhoneLoginViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "PhoneLoginViewController.h"

#import "LSTextField.h"
@interface PhoneLoginViewController ()
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
 *  登录按钮
 */
@property (nonatomic, strong) UIButton * loginBtn;
@end

@implementation PhoneLoginViewController

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
    titleLabel.text = @"手机号登录";
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
    code.myPlaceholder = @"密码";
    [self.view addSubview:code];
    _code = code;
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat loginX = codeX;
    CGFloat loginY = CGRectGetMaxY(code.frame) + Margin42 * IPHONE6_H_SCALE;
    CGFloat loginW = codeW;
    CGFloat loginH = codeH;
    loginBtn.frame = CGRectMake(loginX, loginY, loginW, loginH);
    [loginBtn setImage:[UIImage imageNamed:@"denglu_moren"] forState:UIControlStateNormal];
    loginBtn.userInteractionEnabled = NO;
    [self.view addSubview:loginBtn];
    _loginBtn = loginBtn;
    
    // 问号图标
    UIImageView * pic = [[UIImageView alloc] init];
//    pic.backgroundColor = [UIColor redColor];
    CGFloat picX = (291 / 2) * IPHONE6_W_SCALE;
    CGFloat picY = CGRectGetMaxY(loginBtn.frame) + (586 / 2) * IPHONE6_H_SCALE;
    CGFloat picW = 28 / 2 * IPHONE6_W_SCALE;
    CGFloat picH = picW;
    pic.frame = CGRectMake(picX, picY, picW, picH);
    pic.image = [UIImage imageNamed:@"icon_zhaohuimima"];
    [self.view addSubview:pic];
    
    // 找回密码按钮
    UIButton * getPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [getPassword setTitle:@"找回密码" forState:UIControlStateNormal];
    getPassword.titleLabel.font = Font16;
    [getPassword setTitleColor:[UIColor colorWithRed:42 / 255.0 green:144 / 255.0 blue:216 / 255.0 alpha:1] forState:UIControlStateNormal];
    CGFloat getX = CGRectGetMaxX(pic.frame) + 12 / 2 * IPHONE6_W_SCALE;
    CGFloat getY = CGRectGetMaxY(loginBtn.frame) + (583 / 2) * IPHONE6_H_SCALE;
    NSMutableDictionary * getDic = [NSMutableDictionary dictionary];
    getDic[NSFontAttributeName] = Font16;
    CGSize getSize = [getPassword.titleLabel.text sizeWithAttributes:getDic];
    getPassword.frame = (CGRect){{getX, getY}, getSize};
//    getPassword.backgroundColor = [UIColor redColor];
    [self.view addSubview:getPassword];
    
}
#pragma mark --- 取消注册事件
- (void)cancelRegister{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    if (_phoneNum.text.length && _code.text.length) {
        [_loginBtn setImage:[UIImage imageNamed:@"denglu_xuanzhong"] forState:UIControlStateNormal];
        _loginBtn.userInteractionEnabled = YES;
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    } else
    {
        [_loginBtn setImage:[UIImage imageNamed:@"denglu_moren"] forState:UIControlStateNormal];
        _loginBtn.userInteractionEnabled = NO;
    }

}

#pragma mark --- 登录事件
- (void)loginAction{
    NSLog(@"登录....");
}

#pragma mark --- 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNum resignFirstResponder];
    [_code resignFirstResponder];

    
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
