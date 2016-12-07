//
//  MoreInfoOfPlatformVC.m
//  dipai
//
//  Created by 梁森 on 16/11/8.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MoreInfoOfPlatformVC.h"
#import "Masonry.h"

#import <WebKit/WebKit.h>
@interface MoreInfoOfPlatformVC ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) UIProgressView * progressV;

@end

@implementation MoreInfoOfPlatformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"平台详情";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
     [self showView];
    UIProgressView * progressV = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 8)];
    progressV.backgroundColor = [UIColor blueColor];
    progressV.tintColor = [UIColor redColor];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    progressV.transform = transform;//设定宽高
    [self.view addSubview:progressV];
    self.progressV = progressV;
   
}

- (void)showView{
    
        WKWebView * webView = [[WKWebView alloc]init];
        [self.view addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.naviBar.mas_bottom);
            make.bottom.equalTo(self.view);
        }];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
    NSString * url = @"";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * xcDic = [defaults objectForKey:WXUser];
    NSDictionary * phoneDic = [defaults objectForKey:User];
//    if (xcDic == nil) {
//        NSLog(@"xcnil");
//    }
//    if (phoneDic == nil) {
//        NSLog(@"phonenil");
//    }
    if (xcDic != nil) {
        url = xcDic[@"userid"];
        self.url =  [self.url stringByAppendingString:[NSString stringWithFormat:@"?userid=%@", url]];
    }else if(phoneDic != nil){
        url = phoneDic[@"userid"];
         self.url = [self.url stringByAppendingString:[NSString stringWithFormat:@"?userid=%@", url]];
    }else{
        self.url = [self.url stringByAppendingString:url];
    }
    NSLog(@"%@", self.url);
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView = webView;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    self.progressV.progress = self.webView.estimatedProgress;
    self.progressV.hidden = self.webView.estimatedProgress >= 1;
}

- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
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
