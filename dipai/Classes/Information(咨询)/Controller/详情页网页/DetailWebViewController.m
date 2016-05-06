//
//  DetailWebViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/3.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "DetailWebViewController.h"

#import "UIImageView+WebCache.h"

// 数据层，获取网络上的数据
#import "DataTool.h"
// 模型
#import "WebDetailModel.h"
// 活动指示器
#import "SVProgressHUD.h"
@interface DetailWebViewController ()
/**
 *  网页链接
 */
@property (nonatomic, copy) NSString * wapurl;

@end

@implementation DetailWebViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.url);
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 请求数据
    [self getData];
    
}

- (void)getData
{
    [SVProgressHUD show];
    [DataTool getDataInWebViewWithStr:self.url parameters:nil success:^(WebDetailModel * model) {
        _wapurl = model.wapurl;
        
        [SVProgressHUD dismiss];
        // 设置网页内容
        [self setUpView:_wapurl];
    } failure:^(NSError * error) {
        
        NSLog(@"错误信息：%@", error);
    }];
}

- (void)setUpView:(NSString *)url
{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    NSURL * URL = [NSURL URLWithString:url];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
