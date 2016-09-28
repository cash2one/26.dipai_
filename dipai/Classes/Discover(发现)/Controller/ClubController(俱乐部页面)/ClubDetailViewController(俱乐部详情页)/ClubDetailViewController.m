//
//  ClubDetailViewController.m
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ClubDetailViewController.h"

#import "CAPSPageMenu.h"
// 四个视图控制器
#import "ClubInformationVC.h"
#import "ClubRecommendVC.h"
#import "ClubNewsVC.h"
#import "ClubCommentsVC.h"

// 登录界面
#import "LoginViewController.h"
// 网页详情页
#import "DetailWebViewController.h"

// 图集页面
#import "MorePicsVC.h"
// 信息页模型
#import "InfoModel.h"

#import "SBModel.h"
#import "AnyBodyVC.h"
#import "StarVC.h"

#import "DataTool.h"
@interface ClubDetailViewController ()<CAPSPageMenuDelegate, ClubInformationVCDelegate, ClubCommentsVCDelegate, ClubNewsVCDelegate>


@property (nonatomic, strong) CAPSPageMenu * pageMenu;
/**
 *  推荐页面
 */
@property (nonatomic, strong) ClubRecommendVC * clubRecommendVC;
/**
 *  新闻页面
 */
@property (nonatomic, strong) ClubNewsVC * clubNewsVC;
/**
 *  评论页面
 */
@property (nonatomic, strong) ClubCommentsVC * clubCommentsVC;

@end

@implementation ClubDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_beijingditu"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [DataTool getClubInfoWithStr:self.wapurl parameters:nil success:^(id responseObject) {
        
        InfoModel * infoModel = [[InfoModel alloc] init];
        infoModel = responseObject;
        [self addCAPSPageMenu];
        _clubRecommendVC.wapurl = infoModel.rcd;
        _clubNewsVC.wapurl = infoModel.relation;
        _clubCommentsVC.wapurl = infoModel.comment;
        _clubCommentsVC.iD = infoModel.iD;
        
    } failure:^(NSError * error) {
        
        NSLog(@"获取俱乐部出错%@", error);
    }];
    
    // 设置导航栏
    [self setUpNavigationBar];
    
    // 添加一个第三方控件
//    [self addCAPSPageMenu];
}

- (void)addCAPSPageMenu{
    
    ClubInformationVC * clubInfoVC = [[ClubInformationVC alloc] init];
    clubInfoVC.title = @"信息";
    clubInfoVC.delegate = self;
    clubInfoVC.wapurl = self.wapurl;
    
    ClubRecommendVC * clubRecommendVC = [[ClubRecommendVC alloc] init];
    clubRecommendVC.title = @"推荐";
    _clubRecommendVC = clubRecommendVC;
    
    ClubNewsVC * clubNewsVC = [[ClubNewsVC alloc] init];
    clubNewsVC.title = @"新闻";
    clubNewsVC.delegate = self;
    _clubNewsVC = clubNewsVC;
    
    ClubCommentsVC * clubCommentsVC = [[ClubCommentsVC alloc] init];
    clubCommentsVC.title = @"评论";
    clubCommentsVC.delegate = self;
    _clubCommentsVC = clubCommentsVC;
    
    
    NSArray * array = @[clubInfoVC, clubRecommendVC, clubNewsVC, clubCommentsVC];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor whiteColor],// 背景色
                                 
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor clearColor],// 下面视图控制器的颜色
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor redColor],// 被选中的下方红线的颜色
                                 CAPSPageMenuOptionBottomMenuHairlineColor:[UIColor colorWithRed:246/255.f green:246/255.f blue:246/255.f alpha:1],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor:[UIColor redColor],  // 被选中文字的颜色
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor:[UIColor blackColor],   // 未被选中文字的颜色
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:17.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(SPWidth * 7.5),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:array frame:CGRectMake( 0.0 , 0.0, self.view.frame.size.width, self.view.frame.size.height ) options:parameters];
    [self.view addSubview:_pageMenu.view];
}

- (void)setUpNavigationBar{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui_baise"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.title;
    self.navigationItem.titleView = titleLabel;
}
#pragma mark --- 返回上一个视图控制器
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 响应代理的事件
// 信息页显示图集
- (void)showMorePicsWithImages:(NSArray *)images{
    MorePicsVC * morePicsVC = [[MorePicsVC alloc] init];
    morePicsVC.images = images;
    [self.navigationController pushViewController:morePicsVC animated:YES];
}
// 信息页消失
- (void)sendURLWhenDisappearWithArr:(NSArray *)URLArr andID:(NSString *)iD{
    NSString * recommendURL = URLArr[0];
    NSString * newsURL = URLArr[1];
    NSString * commentsURL = URLArr[2];
    
    NSLog(@"recommendURL:%@---recommendURL:%@---recommendURL%@", recommendURL, newsURL, commentsURL);
    
    _clubRecommendVC.wapurl = recommendURL;
    _clubNewsVC.wapurl = newsURL;
    _clubCommentsVC.wapurl = commentsURL;
    
    _clubCommentsVC.iD = iD;
}
#pragma mark --- ClubCommentsVCDelegate
- (void)presentLoginVC{
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNav animated:YES completion:nil];
}

- (void)turnPageToSBPageWithURL:(NSString *)url withFlag:(NSString *)flag{
    
    AnyBodyVC * anyBodyVC = [[AnyBodyVC alloc] init];
    StarVC * starVC = [[StarVC alloc] init];
    if ([flag isEqualToString:@"0"]) {  // 普通用户
        anyBodyVC.userURL = url;
        [self.navigationController pushViewController:anyBodyVC animated:YES];
    }else{  // 名人
        
        starVC.userURL = url;
        [self.navigationController pushViewController:starVC animated:YES];
    }
}


#pragma mark --- ClubNewsVCDelegate
- (void)turnPageToDetailVCWithURL:(NSString *)wapurl{
    DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
    detailVC.url = wapurl;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
