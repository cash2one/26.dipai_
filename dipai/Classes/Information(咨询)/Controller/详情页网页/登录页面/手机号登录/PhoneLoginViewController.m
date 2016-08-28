//
//  PhoneLoginViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "PhoneLoginViewController.h"

#import "LSTextField.h"
// 找回密码页面
#import "GetPasswordViewController.h"

#import "RootNavigationController.h"

#import "DataTool.h"
#import "SVProgressHUD.h"
@interface PhoneLoginViewController ()<UITextFieldDelegate>
{
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
    phoneNum.delegate = self;
    //    phoneNum.backgroundColor = [UIColor whiteColor];
    phoneNum.myPlaceholder = @"手机号";
    phoneNum.font = Font17;
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
    code.secureTextEntry = YES;
    code.font = Font17;
    code.myPlaceholder = @"密码";
    [self.view addSubview:code];
    _code = code;
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat loginX = codeX;
    CGFloat loginY = CGRectGetMaxY(code.frame) + Margin42 * IPHONE6_H_SCALE;
    CGFloat loginW = codeW;
    CGFloat loginH = codeH;
    loginBtn.frame = CGRectMake(loginX, loginY, loginW, loginH);
//    [loginBtn setImage:[UIImage imageNamed:@"denglu_moren"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"denglu_moren"] forState:UIControlStateNormal];
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
    [getPassword addTarget:self action:@selector(getPasswordAction) forControlEvents:UIControlEventTouchUpInside];
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
    
    if (_phoneNum.text.length && _code.text.length) {
//        [_loginBtn setImage:[UIImage imageNamed:@"denglu_xuanzhong"] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"denglu_xuanzhong"] forState:UIControlStateNormal];
        _loginBtn.userInteractionEnabled = YES;
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    } else
    {
//        [_loginBtn setImage:[UIImage imageNamed:@"denglu_moren"] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"denglu_moren"] forState:UIControlStateNormal];
        _loginBtn.userInteractionEnabled = NO;
    }

}

#pragma mark --- 登录事件
- (void)loginAction{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    /*
     phone，password
     */
    dic[@"phone"] = _phoneNum.text;
    dic[@"password"] = _code.text;
    [DataTool postWithStr:LoginURL parameters:dic success:^(id responseObject) {
        NSString * content = [responseObject objectForKey:@"content"];
        
        NSLog(@"登录获取的数据%@", responseObject);
        
        NSLog(@"－－－%@", content);
        
        if ([content isEqualToString:@"密码错误"]) {
            [SVProgressHUD showErrorWithStatus:@"密码错误"];
        }
        if ([content isEqualToString:@"没有此用户"]) {
            [SVProgressHUD showErrorWithStatus:@"没有此用户"];
        }
        if ([content isEqualToString:@"登录成功"]) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            
            NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (NSHTTPCookie * cookie in cookies) {
                NSString * name = [cookie name];
                NSLog(@"---name---%@", name);
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:name forKey:Cookie];
                [defaults synchronize];
                                
                NSDictionary * dataDic = [responseObject objectForKey:@"data"];
                
                NSLog(@"登录成功后获取的数据:%@", dataDic);
                
                [defaults setObject:dataDic forKey:User];
                [defaults setObject:@"phone" forKey:Phone];
                [defaults synchronize];
            }
            //存储归档后的cookie
            
            if ([self.delegate respondsToSelector:@selector(dismiss)]) {
                [self.delegate dismiss];
            } else{
                NSLog(@"PhoneLoginViewController的代理没有响应");
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError * error) {
        
        NSLog(@"登录错误信息：%@", error);
    }];
}

#pragma mark --- 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNum resignFirstResponder];
    [_code resignFirstResponder];

}

#pragma mark --- 找回密码
- (void)getPasswordAction{
    GetPasswordViewController * getPasswordVC = [[GetPasswordViewController alloc] init];
    
    [self.navigationController pushViewController:getPasswordVC animated:YES];
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
