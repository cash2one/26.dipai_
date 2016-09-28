//
//  GetPasswordViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/27.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "GetPasswordViewController.h"

#import "LSTextField.h"
#import "DataTool.h"
// 获取验证码的按钮
#import "UIButton+CountDown.h"
// 修改密码页面
#import "ResetPasswordViewController.h"
#import "SVProgressHUD.h"
#import "Masonry.h"
@interface GetPasswordViewController ()
{
    NSTimer * _timer;
    int allTime;
    NSString * _phone;  // 手机号
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
 *  下一步按钮
 */
@property (nonatomic, strong) UIButton * nextBtn;
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

@implementation GetPasswordViewController

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
    titleLabel.text = @"找回密码";
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
//    btnView.backgroundColor = [UIColor redColor];
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
    
    // 下一步按钮
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat nextX = codeX;
    CGFloat nextY = CGRectGetMaxY(code.frame) + Margin42 * IPHONE6_H_SCALE;
    CGFloat nextW = codeW;
    CGFloat nextH = codeH;
    nextBtn.frame = CGRectMake(nextX, nextY, nextW, nextH);
//    [nextBtn setImage:[UIImage imageNamed:@"xiayibu_moren"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"xiayibu_moren"] forState:UIControlStateNormal];
    nextBtn.userInteractionEnabled = NO;
    [self.view addSubview:nextBtn];
    _nextBtn = nextBtn;
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
    _phone = _phoneNum.text;
    [DataTool postWithStr:SecurityCodeURL parameters:dic success:^(id responseObject) {
        
        if ([responseObject[@"content"] isEqualToString:@"success"]) {
            NSLog(@"获取验证码成功...");
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            [_getCodeBtn setTitleColor:Color153 forState:UIControlStateNormal];
            [_getCodeBtn startWithTime:10 title:@"重新发送" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"content"]];
        }
    } failure:^(NSError * error) {
        NSLog(@"获取验证码出错%@", error);
    }];

    
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
//        [_nextBtn setImage:[UIImage imageNamed:@"xiayibu_xuanzhong"] forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"xiayibu_xuanzhong"] forState:UIControlStateNormal];
        _nextBtn.userInteractionEnabled = YES;
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    } else
    {
//        [_nextBtn setImage:[UIImage imageNamed:@"xiayibu_moren"] forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"xiayibu_moren"] forState:UIControlStateNormal];
        _nextBtn.userInteractionEnabled = NO;
    }
}

#pragma mark --- 下一步事件
- (void)nextAction{
    NSString * url = verityURL;
//    NSString * url = @"http://dpapp.replays.net/sign/app_verify";
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"verify"] = _code.text;
    [DataTool postWithStr:url parameters:dic success:^(id responseObject) {
        
        NSLog(@"验证验证码成功:%@", responseObject);
        NSLog(@"content:%@", responseObject[@"content"]);
        NSString * content = responseObject[@"content"];
        if ([content isEqualToString:@"success"]) { // 验证码正确
            ResetPasswordViewController * resetPasswordVC = [[ResetPasswordViewController alloc] init];
            resetPasswordVC.phone = _phone;
            resetPasswordVC.codeStr = _code.text;
            [self.navigationController pushViewController:resetPasswordVC animated:YES];
        }else{
            NSLog(@"输入的验证码错误");
        }
    } failure:^(NSError * error) {
        
        NSLog(@"验证验证码出错：%@", error);
    }];
    

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


@end
