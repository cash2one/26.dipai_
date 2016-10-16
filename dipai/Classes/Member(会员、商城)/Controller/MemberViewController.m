//
//  MemberViewController.m
//  dipai
//
//  Created by 梁森 on 16/10/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MemberViewController.h"
// 会员等级页面
#import "MemberLevelViewController.h"
#import "Masonry.h"

// 自定义navigationBar
#import "NavigationBarV.h"
// 商品详情页
#import "GoodsDetailVC.h"
// 活动控制器
#import "SVProgressHUD.h"

// 获取数据的工具类
#import "DataTool.h"

// 会员数据模型
#import "MemberDataModel.h"
// 会员信息模型
#import "MemberInfoModel.h"
// 平台模型
#import "PlatformModel.h"
@interface MemberViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UISegmentedControl *_segmented;
    // 滚动视图
    UIScrollView *_sc;
}
// 会员中心
@property (nonatomic, strong) UITableView * tableView1;
// 积分商城
@property (nonatomic, strong) UITableView * tableView2;

// 会员中心背景图
@property (nonatomic, strong) UIView * memberV;
// 头像背景图
@property (nonatomic, strong) UIImageView * backV;

@end

@implementation MemberViewController

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s", __func__);
    [super viewWillAppear:YES];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s", __func__);
    self.navigationController.navigationBarHidden = YES;
    
    [self  setUpNaviBar];
}

- (void)setUpNaviBar{
    
    [self addSegmentControl];
    
    // 添加滚动视图
    [self addScrollView];
}

- (void)addSegmentControl{
    
    // 分段控件
    _segmented = [[UISegmentedControl alloc]initWithItems:@[@"会员中心",@"积分商城"]];
    _segmented.selectedSegmentIndex = 0;
    // 被选中时的背景色
    _segmented.tintColor = [UIColor blackColor];
    // 未被选中的背景色
    _segmented.backgroundColor = [UIColor blackColor];
    
    // 被选中时的字体的颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:Font18} forState:UIControlStateSelected];
    // 正常情况下的字体颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:Font18} forState:UIControlStateNormal];
    
    [self.view addSubview:_segmented];
    [_segmented mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.width.equalTo(@(WIDTH - 120));
        make.height.equalTo(@(43));
    }];
    //    _segmented.backgroundColor = [UIColor yellowColor];
    // 为分段控件添加点事件
    [_segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)addScrollView {
    
    //    NSLog(@"%f", HEIGHT);
    
    _sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH , HEIGHT-64)];
    _sc.contentSize=CGSizeMake(WIDTH * 2 , HEIGHT-64);
    _sc.scrollEnabled = NO; // 禁止活动
    _sc.scrollsToTop = NO;
    _sc.delegate=self;
    _sc.bounces=NO;
    _sc.pagingEnabled=YES;
    _sc.backgroundColor = [UIColor redColor];
    [self.view addSubview:_sc];
    
    // 在滚动视图上添加tableView
    [self addTableView];
}

- (void)addTableView{
    
    // 会员中心页面
    UIView * memberV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    memberV.backgroundColor = [UIColor greenColor];
    [_sc addSubview:memberV];
    
    // 背景图
    UIImageView * backV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    [memberV addSubview:backV];
    backV.backgroundColor = [UIColor blueColor];
    _backV = backV;
    
    // 跳到会员等级的按钮
    UIButton * memberBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [memberV addSubview:memberBtn];
    memberBtn.frame = CGRectMake(WIDTH-100, 0, 100, 200);
    memberBtn.backgroundColor = [UIColor redColor];
    [memberBtn addTarget:self action:@selector(seeMemberlevel) forControlEvents:UIControlEventTouchUpInside];
    
    // 没有加载到数据的时候隐藏
    memberV.hidden = YES;
    _memberV = memberV;
    // 获取网络数据
//    [self getData];
    
    
    self.tableView2=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH , HEIGHT -64) style:UITableViewStylePlain];
    self.tableView2.delegate=self;
    self.tableView2.dataSource=self;
    //    _tableView2.showsVerticalScrollIndicator=NO;
    self.tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView2.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49 * IPHONE6_H_SCALE)];
//    self.tableView2.backgroundColor = [UIColor yellowColor];
    [_sc addSubview:self.tableView2];
}
#pragma mark --- 分段控件的点击事件
-(void)segmentedClick:(UISegmentedControl*)seg{
    
    // 根据情况改变滚动视图的偏移
    if (seg.selectedSegmentIndex == 0) {
        _sc.contentOffset=CGPointMake(0, 0);
    }else{
        _sc.contentOffset=CGPointMake( WIDTH , 0);
        [SVProgressHUD dismiss];
    }
}

// 跳转到会员等级页面
- (void)seeMemberlevel{
    
    MemberLevelViewController * memberLevelVC = [[MemberLevelViewController alloc] init];
    memberLevelVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:memberLevelVC animated:YES];
}

- (void)getData{
    
    [SVProgressHUD show];
    [DataTool getMemberCenterDataWithStr:MemberCenter parameters:nil success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSString class]]) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"未登录"];
            _memberV.hidden = YES;
        }else{
            [SVProgressHUD dismiss];
            // 显示会员中心页面
            _memberV.hidden = NO;
        }
        
    } failure:^(NSError * error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}


#pragma mark --- UITableViewDelegate


#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView1) {
        return 20;
    }else{
        
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (tableView == self.tableView1) {
        cell.backgroundColor = [UIColor greenColor];
    }else{
        cell.backgroundColor = [UIColor orangeColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 跳转到商品详情页
    GoodsDetailVC * goodsDetailVC = [[GoodsDetailVC alloc] init];
    goodsDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
