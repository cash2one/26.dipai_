//
//  NavigationHiddenVC.m
//  dipai
//
//  Created by 梁森 on 16/10/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NavigationHiddenVC.h"
@interface NavigationHiddenVC ()

@end

@implementation NavigationHiddenVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
     self.navigationController.navigationBarHidden = YES;
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
            // 每次进入此页面都要进行数据的刷新，因为当前用户积分随时可能发生变化
            [self noLoginInOtherPhone];
        }
    } failure:^(NSError *error) {
        
    }];
}
// 没有被异地登录的处理
- (void)noLoginInOtherPhone{
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    NavigationBarV * naviBar = [[NavigationBarV alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:naviBar];
    naviBar.backgroundColor = [UIColor blackColor];
    self.naviBar = naviBar;
}
- (void)popAction{
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
           
              [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
