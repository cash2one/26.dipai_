//
//  AccountViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/31.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AccountViewController.h"
// 自定义单元格
#import "CustomTableViewCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "DataTool.h"
// 账户模型
#import "AccountModel.h"

// 修改密码页面
#import "ResetPasswordViewController.h"
// 修改昵称页面
#import "ResetNameVC.h"
// 绑定手机页面
#import "AndPhoneVC.h"

#import "WXApi.h"
#import "AppDelegate.h"

#import "UIImage+extend.h"
@interface AccountViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, AppDelegate, WXApiDelegate>
{
    NSString * _name;   // 用户名
    UIImage * _image;
    
    // 验证原密码
    NSString * _passWord;
}

@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIImagePickerController * imagePicker;
/**
 *  账户
 */
@property (nonatomic, strong) AccountModel * account;

@end

@implementation AccountViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // 每次进入页面都要进行刷新，昵称、头像、密码随时可能被修改
    
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];
    [self getData];
}

- (void)getData{
    [SVProgressHUD show];
    [DataTool getAccountDataWithStr:AccountURL parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        _account = [[AccountModel alloc] init];
        _account = responseObject;
        NSLog(@"%@", _account);
        NSLog(@"%@", _account.username);
        NSLog(@"face:%@", _account.face);
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取个人账户出错：%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    
    [self setNavigationBar];
    
    [self createUI];
    
    AppDelegate * delegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.delegate = self;

}

#pragma mark --- 设置导航条
- (void)setNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
    
    // 左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui"] target:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:38/2];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"帐号管理";
    self.navigationItem.titleView = titleLabel;
}
#pragma mark --- 返回
- (void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 搭建UI
- (void)createUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 110*4/2*IPHONE6_H_SCALE) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.tableView];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 28 / 2 * IPHONE6_H_SCALE)];
    headerView.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    
    self.tableView.tableHeaderView = headerView;
    
    NSArray * array = @[@"头像", @"昵称", @"绑定微信", @"绑定手机"];
    self.dataSource = [NSMutableArray arrayWithArray:array];
    
    
    // 登录按钮被移动到了设置界面
//    UIButton * outBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    CGFloat btnX = Margin40 * IPHONE6_W_SCALE;
//    CGFloat btnY = CGRectGetMaxY(self.tableView.frame) + Margin70 * IPHONE6_H_SCALE;
//    CGFloat btnW = WIDTH - 2 * btnX;
//    CGFloat btnH = Margin100 * IPHONE6_H_SCALE;
//    outBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
//    [outBtn setImage:[UIImage imageNamed:@"tuichudenglu"] forState:UIControlStateNormal];
//    [outBtn setBackgroundImage:[UIImage imageNamed:@"tuichudenglu"] forState:UIControlStateNormal];
//    [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//    outBtn.layer.masksToBounds = YES;
//    outBtn.layer.cornerRadius = 4;
//    outBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    outBtn.backgroundColor = RGBA(225, 10, 24, 1);
//    [outBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    outBtn.titleLabel.font = Font17;
//    [outBtn addTarget:self action:@selector(outLogin) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:outBtn];
}

#pragma mark --- 退出的点击事件
- (void)outLogin{

//    [self deleteCookie];
//    
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 删除cookie
- (void)deleteCookie
{
//    NSLog(@"============删除cookie===============");
//    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    
//    //删除cookie
//    for (NSHTTPCookie *tempCookie in cookies) {
//        [cookieStorage deleteCookie:tempCookie];
//    }
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:Cookie];
//    [defaults removeObjectForKey:Phone];
//    [defaults removeObjectForKey:User];
//    [defaults removeObjectForKey:WXUser];
//    [SVProgressHUD showSuccessWithStatus:@"退出成功"];
}

#pragma mark --- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellID";
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
#warning 不能用持久化存储的数据，每次进行这个页面都要进行以下刷新
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * arr1 = @[@"头像", @"昵称", @"绑定微信"];
    NSArray * arr2 = @[@"头像", @"昵称", @"绑定手机"];
    if ([defaults objectForKey:Phone]) {    // 如果是手机号登录
        cell.titleLbl.text = arr1[indexPath.row];
        if (indexPath.row != 1) {
            cell.nameLbl.hidden = YES;
        } else{
            // 有问题不能用一个固定的值，昵称会被修改
            NSLog(@"%@", _account.username);
            cell.nameLbl.text = _account.username;
        }
        
        if (indexPath.row != 0) {
            cell.picView.hidden = YES;
        } else{
            // 网络头像
            [cell.picView sd_setImageWithURL:[NSURL URLWithString:_account.face] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
        }
    }else{  // 如果是微信登录
        cell.titleLbl.text = arr2[indexPath.row];
        if (indexPath.row != 1) {
            cell.nameLbl.hidden = YES;
        } else{
            // 有问题不能用一个固定的值，昵称会被修改
            NSLog(@"%@", _account.username);
            cell.nameLbl.text = _account.username;
        }
        
        if (indexPath.row != 0) {
            cell.picView.hidden = YES;
        } else{
            // 网络头像
            [cell.picView sd_setImageWithURL:[NSURL URLWithString:_account.face] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
        }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 111 / 2 * IPHONE6_H_SCALE;
}

#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:Phone]) {    // 如果是手机登录
        
        if (indexPath.row == 2) {   // 绑定微信
            NSLog(@"绑定微信...");
            if ([self.bindign isEqualToString:@"0"]) {  // 都绑定了
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"您已进行过绑定" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                //构造SendAuthReq结构体
                SendAuthReq* req =[[SendAuthReq alloc ] init ];
                req.scope = @"snsapi_userinfo" ;
                req.state = @"123" ;
                //第三方向微信终端发送一个SendAuthReq消息结构
                [WXApi sendReq:req];
                
                [WXApi sendAuthReq:req viewController:self delegate:self];
                // 成功利用了AppDelegate
            }
            
            
        }else if (indexPath.row == 1){  // 修改昵称
            NSLog(@"up_state%@", _account.up_state);
            // 先判断是否能进行修改
            if ([_account.up_state isEqualToString:@"1"]) {
                ResetNameVC * resetNameVC = [[ResetNameVC alloc] init];
                resetNameVC.name = _account.username;
                [self.navigationController pushViewController:resetNameVC animated:YES];
            }else{
            
                [SVProgressHUD showErrorWithStatus:@"昵称不可再修改"];
            }
           
        }else if (indexPath.row == 0){  // 修改头像
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate = self;
            _imagePicker.allowsEditing = YES;
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }
        else{   // 绑定手机号
            AndPhoneVC * addPhoneVC = [[AndPhoneVC alloc] init];
            if (_account.phone) {
                [SVProgressHUD showSuccessWithStatus:@"已绑定手机"];
            }else{
                [self.navigationController pushViewController:addPhoneVC animated:YES];
            }
            
        }
    }else{  // 如果是微信登录
        
        if (indexPath.row == 2) {   // 绑定手机
            AndPhoneVC * addPhoneVC = [[AndPhoneVC alloc] init];
            if ([self.bindign isEqualToString:@"0"]) {  // 都绑定了
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"您已进行过绑定" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self.navigationController pushViewController:addPhoneVC animated:YES];
            }
            
        }else if (indexPath.row == 1){  // 修改昵称
            if ([_account.up_state isEqualToString:@"1"]) {
                ResetNameVC * resetNameVC = [[ResetNameVC alloc] init];
                resetNameVC.name = _account.username;
                [self.navigationController pushViewController:resetNameVC animated:YES];
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"昵称不可再修改"];
            }
        }else if (indexPath.row == 0){  // 修改头像
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate = self;
            _imagePicker.allowsEditing = YES;
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }
        else{   // 绑定手机号
            AndPhoneVC * addPhoneVC = [[AndPhoneVC alloc] init];
            if (_account.phone) {
                [SVProgressHUD showSuccessWithStatus:@"已绑定手机"];
            }else{
                [self.navigationController pushViewController:addPhoneVC animated:YES];
            }
            
        }
    }
    
    
}

- (void)dismissWithStr:(NSString *)str{
    // 给服务器发送code
    NSString * url = AddWeixin;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"code"] = str;
//    NSLog(@"code-----%@", str);
    [DataTool sendCodeWithStr:url parameters:dic success:^(id responseObject) {
        
//        NSLog(@"绑定微信发送code成功%@,", responseObject);
//        NSLog(@"%@", responseObject[@"content"]);
//        
        if ([responseObject[@"state"] isEqualToString:@"1"]) {
            NSLog(@"绑定成功...");
        }else{
            NSLog(@"绑定失败...");
            // 绑定失败的原因
            [SVProgressHUD showErrorWithStatus:responseObject[@"content"]];
        }
    } failure:^(NSError * error) {
        
        NSLog(@"发送code出错：%@", error);
    }];
}

- (void)alertTextFieldDidChange:(NSNotification *)obj
{
    UITextField * text = [obj object];
    _passWord = text.text;
    
}

#pragma mark --------  UIImagePickerControllerDelegate
// 实现协议中的方法
// 对相册中的图片进行选择时调用该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //    NSLog(@"%s", __func__);
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        // 返回
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
//        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 进行头像的上传
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [SVProgressHUD show];
        NSString * url = nil;
        if (![ChangeAccountURL hasPrefix:@"http"]) {
           url = [NSString stringWithFormat:@"%@%@", DipaiBaseURL, ChangeAccountURL];
        }else{
            url = ChangeAccountURL;
        }
        
        [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            /**
             *  FileData:要上传文件的二进制数据
             name:上传参数名称
             fileName:上传到服务器的文件名称
             mimeType:文件类型
             */
            
//                NSData * data = UIImagePNGRepresentation(image);
//            NSData * data = UIImageJPEGRepresentation(image, 0.5);
            UIImage * image1 = [image rotateImage];
            NSData * data = UIImagePNGRepresentation(image1);
            NSString * name = [NSString stringWithFormat:@"face"];
            NSString * fileName = [NSString stringWithFormat:@"image.jpeg"];
            NSString * mimeType = [NSString stringWithFormat:@"image/png"];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
            [SVProgressHUD showWithStatus:@"上传中"];
            
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSLog(@"上传图片成功---:%@", responseObject);
            [self getData];
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"上传失败"];
            
            NSLog(@"上传图片失败：%@", error);
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }];
        
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // 返回
        [self dismissViewControllerAnimated:YES completion:nil];
        // 保存编辑后的照片
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
