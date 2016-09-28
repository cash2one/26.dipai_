//
//  ResetNameVC.m
//  dipai
//
//  Created by 梁森 on 16/7/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ResetNameVC.h"

#import "LSTextField.h"
#import "UserModel.h"

#import "SVProgressHUD.h"
#import "DataTool.h"
@interface ResetNameVC ()
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

@implementation ResetNameVC



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
    titleLabel.text = @"修改昵称";
    self.navigationItem.titleView = titleLabel;
}

#pragma mark --- 设置UI
- (void)setUpUI{
    // 新昵称
    CGFloat numX = Margin40 * IPHONE6_W_SCALE;
    CGFloat numY = Margin60 * IPHONE6_H_SCALE;
    CGFloat numW = WIDTH - 2 * numX;
    CGFloat numH = Margin100 * IPHONE6_H_SCALE;
    LSTextField * phoneNum = [[LSTextField alloc] initWithFrame:CGRectMake(numX, numY, numW, numH)];
    //    phoneNum.backgroundColor = [UIColor whiteColor];
    phoneNum.text = self.name;
//    phoneNum.myPlaceholder = userModel.username;
    phoneNum.font = Font17;
    [self.view addSubview:phoneNum];
    _phoneNum = phoneNum;
    [phoneNum becomeFirstResponder];
    
    // 显示只能修改一次的提示信息
    UILabel * warLbl = [[UILabel alloc] init];
    warLbl.numberOfLines = 0;
    warLbl.font = Font11;
    warLbl.textColor = Color183;
    warLbl.text = @"昵称只能修改一次，提交后无法变更。该昵称仅用户展示，无法使用昵称登录帐号";
    CGFloat warX = 25 * IPHONE6_W_SCALE;
    CGFloat warY = CGRectGetMaxY(phoneNum.frame) + 9 * IPHONE6_H_SCALE;
    CGFloat warW = WIDTH - 2 * warX;
    
    NSMutableDictionary * warDic = [NSMutableDictionary dictionary];
    warDic[NSFontAttributeName] = Font11;
    CGRect warRect = [warLbl.text boundingRectWithSize:CGSizeMake(warW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:warDic context:nil];
    warLbl.frame = (CGRect){{warX, warY}, warRect.size};
    [self.view addSubview:warLbl];
    
    // 确认按钮
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sureBtn setImage:[UIImage imageNamed:@"queren_moren"] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"queren_moren"] forState:UIControlStateNormal];
    CGFloat sureX = numX;
    CGFloat sureY = CGRectGetMaxY(warLbl.frame) + 45 * IPHONE6_H_SCALE;
    CGFloat sureW = numW;
    CGFloat sureH = Margin100 * IPHONE6_W_SCALE;
    sureBtn.frame = CGRectMake(sureX, sureY, sureW, sureH);
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

    
    if (_phoneNum.text.length ) {
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
    // 确认按钮的点击事件  进行昵称的修改
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    NSString * str = _phoneNum.text;
//    NSLog(@"str--%@", str);
    
    dic[@"username"] = str;
    
    NSRange _range = [str rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        
        NSLog(@"有空格");
        [SVProgressHUD showErrorWithStatus:@"昵称不能包含空格"];
    }else {
        NSLog(@"没有空格");
        //没有空格
        [DataTool postWithStr:ChangeAccountURL parameters:dic success:^(id responseObject) {
            
            //        NSLog(@"修改昵称成功:%@", responseObject);
            NSString * state = responseObject[@"state"];
            //        NSLog(@"content---%@", responseObject[@"content"]);
            if ([state isEqualToString:@"97"]) {    // 说明昵称已存在
                [SVProgressHUD showSuccessWithStatus:@"昵称已存在"];
            }else{
                [SVProgressHUD show];
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError * error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
            NSLog(@"修改昵称出错：%@", error);
        }];
    }
   
}

#pragma mark --- 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNum resignFirstResponder];
    [_code resignFirstResponder];
}


@end
