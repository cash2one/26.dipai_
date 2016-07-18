//
//  ResetPasswordViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/27.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ResetPasswordViewController.h"


#import "LSTextField.h"
#import "SVProgressHUD.h"

#import "DataTool.h"
@interface ResetPasswordViewController ()
/**
 *  手机号
 */
@property (nonatomic, strong) LSTextField * phoneNum;
/**
 *  验证码
 */
@property (nonatomic, strong) LSTextField * code;

/**
 *  确认按钮
 */
@property (nonatomic, strong) UIButton * sureBtn;
/**
 *  密码长度
 */
@property (nonatomic, strong) UILabel * sureLength;
/**
 *  密码长度
 */
@property (nonatomic, strong) UILabel * length1;

@end

@implementation ResetPasswordViewController

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
    titleLabel.text = @"修改密码";
    self.navigationItem.titleView = titleLabel;
}

#pragma mark --- 设置UI
- (void)setUpUI{
    
    // 新密码
    CGFloat numX = Margin40 * IPHONE6_W_SCALE;
    CGFloat numY = Margin60 * IPHONE6_H_SCALE;
    CGFloat numW = WIDTH - 2 * numX;
    CGFloat numH = Margin100 * IPHONE6_H_SCALE;
    LSTextField * phoneNum = [[LSTextField alloc] initWithFrame:CGRectMake(numX, numY, numW, numH)];
    //    phoneNum.backgroundColor = [UIColor whiteColor];
    phoneNum.myPlaceholder = @"新密码";
    phoneNum.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:phoneNum];
    _phoneNum = phoneNum;
    
    UILabel * newLength = [[UILabel alloc] init];
    newLength.text = @"密码长度为6-15位";
    newLength.font = Font16;
    newLength.textColor = Color183;
    CGFloat newX = 100 * IPHONE6_W_SCALE;
    CGFloat newY = 0;
    CGFloat newW = 200;
    CGFloat newH = numH;
    newLength.frame = CGRectMake(newX, newY, newW, newH);
    [_phoneNum addSubview:newLength];
    _length1 = newLength;
    
    // 横线
    CGFloat line1X = numX;
    CGFloat line1Y = CGRectGetMaxY(phoneNum.frame);
    CGFloat line1W = numW;
    CGFloat line1H = 0;
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(line1X, line1Y, line1W, line1H)];
    line1.backgroundColor = [UIColor colorWithRed:227 / 255.0 green:227 / 255.0 blue:227 / 255.0 alpha:1];
    [self.view addSubview:line1];
    
    // 确认密码
    CGFloat codeX = numX;
    CGFloat codeY = CGRectGetMaxY(line1.frame);
    CGFloat codeW = line1W;
    CGFloat codeH = numH;
    LSTextField * code = [[LSTextField alloc] initWithFrame:CGRectMake(codeX, codeY, codeW, codeH)];
    code.font = [UIFont systemFontOfSize:17];
    code.myPlaceholder = @"确认密码";
    [self.view addSubview:code];
    _code = code;
    
    UILabel * sureLength = [[UILabel alloc] init];
    sureLength.text = @"密码长度为6-15位";
    sureLength.font = Font16;
    sureLength.textColor = Color183;
    CGFloat sureLX = 100 * IPHONE6_W_SCALE;
    CGFloat sureLY = 0;
    CGFloat sureLW = 200;
    CGFloat sureLH = numH;
    sureLength.frame = CGRectMake(sureLX, sureLY, sureLW, sureLH);
    [_code addSubview:sureLength];
    _sureLength = sureLength;
    
    // 确认按钮
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat sureX = codeX;
    CGFloat sureY = CGRectGetMaxY(code.frame) + Margin42 * IPHONE6_H_SCALE;
    CGFloat sureW = codeW;
    CGFloat sureH = codeH;
    sureBtn.frame = CGRectMake(sureX, sureY, sureW, sureH);
//    [sureBtn setImage:[UIImage imageNamed:@"queren_moren"] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"queren_moren"] forState:UIControlStateNormal];
    sureBtn.userInteractionEnabled = NO;
    [self.view addSubview:sureBtn];
    _sureBtn = sureBtn;
}

#pragma mark --- 取消注册事件
- (void)cancelRegister{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 获取验证码的事件
- (void)getCodeAction{
    
    
}


#pragma mark --- 对TextField进行监听
- (void)textFieldChanged{
    NSLog(@"%@", _phoneNum.text);
    // 新密码
    if (_phoneNum.text.length) {
        _phoneNum.hidePlaceHolder = YES;
        _length1.hidden = YES;
    }else
    {
        _phoneNum.hidePlaceHolder = NO;
        _length1.hidden = NO;
    }
    // 确认密码
    if (_code.text.length) {
        _code.hidePlaceHolder = YES;
        _sureLength.hidden = YES;
    } else
    {
        _code.hidePlaceHolder = NO;
        _sureLength.hidden = NO;
    }
    
    if (_phoneNum.text.length && _code.text.length) {
//        [_sureBtn setImage:[UIImage imageNamed:@"queren_xuanzhong"] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"queren_xuanzhong"] forState:UIControlStateNormal];
        _sureBtn.userInteractionEnabled = YES;
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    } else
    {
//        [_sureBtn setImage:[UIImage imageNamed:@"queren_moren"] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"queren_moren"] forState:UIControlStateNormal];
        _sureBtn.userInteractionEnabled = NO;
    }
}

#pragma mark --- 下一步事件
- (void)sureAction{
    
    NSLog(@"%@====%@", _code.text, _phoneNum.text);
    NSString * newPassword = _phoneNum.text;
    NSString * surePassword = _code.text;
    if (newPassword == surePassword) {
        // 进行修改密码的网络操作
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"password"] = _code.text;
        [DataTool postWithStr:ChangeAccountURL parameters:dic success:^(id responseObject) {
            
            NSLog(@"修改密码成功:%@", responseObject);
            NSLog(@"msg:%@", responseObject[@"msg"]);
            [SVProgressHUD show];
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError * error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
            NSLog(@"修改密码出错：%@", error);
        }];
    } else{
        NSLog(@"两次输入密码不一致，请重试");
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
    }
    
}

#pragma mark --- 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNum resignFirstResponder];
    [_code resignFirstResponder];
    
}

@end
