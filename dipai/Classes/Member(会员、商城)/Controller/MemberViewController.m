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
// 登录页面
#import "LoginViewController.h"
// 更多商品页面
#import "MoreGoodsVC.h"
// 客服中心页面
#import "ServerVC.h"
// 更多信息页面
#import "MoreInfoOfPlatformVC.h"
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
// 商城首页模型
#import "ShopMallModel.h"
// 商城商品模型
#import "ShopGoodsModel.h"
// 商城列表模型
#import "ShopListModel.h"
// 商城banner模型
#import "ShopBannerModel.h"

#import "LineLayout.h"
// 平台自定义单元格
#import "CustomCollectionCell.h"
// 商城单元格
#import "ShopCell.h"
// 刷新控件
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 网络请求第三方
#import "AFNetworking.h"
// 加载图片第三方
#import "UIImageView+WebCache.h"
@interface MemberViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, ShopCellDelegate, CustomCollectionCellDelegate>
{
    UISegmentedControl *_segmented;
    // 滚动视图
    UIScrollView *_sc;
    
    // 头像
    NSString * _face;
    // 积分
    NSString * _num;
}
// 会员中心
@property (nonatomic, strong) UITableView * tableView1;
// 积分商城
@property (nonatomic, strong) UITableView * tableView2;

// 会员中心背景图
@property (nonatomic, strong) UIView * memberV;
// 头像背景图
@property (nonatomic, strong) UIImageView * backV;
// 登录头像按钮
@property (nonatomic, strong) UIButton * loginBtn;
// 点击登录标签
@property (nonatomic, strong) UILabel * loginLbl;
// 登录后的头像
@property (nonatomic, strong) UIImageView * faceV ;
// 积分标签
@property (nonatomic, strong) UILabel * numLbl;
// 积分总额标识标签
@property (nonatomic, strong) UILabel * allNumLbl;
// 跳到会员明细的按钮
@property (nonatomic, strong) UIButton * memberBtn;
//
@property (nonatomic, strong) UIImageView * accessV;
// banner图
@property (nonatomic, strong) UIScrollView * headerV;

// 平台数据源
@property (nonatomic,strong)NSMutableArray *dataArray;
//
@property (nonatomic,weak)UICollectionView *collectionView;
// 商城数据源
@property (nonatomic, strong) NSMutableArray * goodsArray;
// banner数组
@property (nonatomic, strong) NSMutableArray * bannerArr;
@end

@implementation MemberViewController

- (NSMutableArray *)goodsArray{
    
    if (_goodsArray == nil) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}
- (NSMutableArray *)bannerArr{
    
    if (_bannerArr == nil) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s", __func__);
    [super viewWillAppear:YES];
    
    // 为何此页面每次出现的时候都要获取数据？ 因为头像和积分可能发生变化
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s", __func__);
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self  setUpNaviBar];
}

- (void)setUpNaviBar{
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.backgroundColor = [UIColor redColor];
    [rightBtn setImage:[UIImage imageNamed:@"wenti"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(problemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_top).offset(64);
        make.width.equalTo(@(44 * IPHONE6_W_SCALE + 10));
        make.height.equalTo(@(44 * IPHONE6_W_SCALE));
    }];
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
    _sc.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sc];
    
    // 在滚动视图上添加tableView
    [self addTableView];
}

- (void)addTableView{
    
    // 会员中心页面
    UIView * memberV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    memberV.backgroundColor = [UIColor whiteColor];
    [_sc addSubview:memberV];
    
    // 背景图
    UIImageView * backV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 130 * IPHONE6_H_SCALE)];
    backV.image = [UIImage imageNamed:@"touxiangbeijing"];
    [memberV addSubview:backV];
    backV.backgroundColor = [UIColor blueColor];
    backV.userInteractionEnabled = YES;
    _backV = backV;
    // 未登录头像
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backV addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backV.mas_centerX);
        make.top.equalTo(backV.mas_top).offset(48 * 0.5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(56 * IPHONE6_W_SCALE));
        make.height.equalTo(@(56 * IPHONE6_W_SCALE));
    }];
    loginBtn.layer.cornerRadius = 28 * IPHONE6_W_SCALE;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.borderColor = RGBA(118, 118, 118, 1).CGColor;
    loginBtn.layer.borderWidth = 1.5 * IPHONE6_W_SCALE;
    loginBtn.imageView.image = [UIImage imageNamed:@"touxiang_moren"];
    [loginBtn setImage:[UIImage imageNamed:@"touxiang_moren"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn = loginBtn;
    // 点击登录标签
    UILabel * loginLbl = [[UILabel alloc] init];
    [backV addSubview:loginLbl];
    [loginLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backV.mas_centerX);
        make.top.equalTo(loginBtn.mas_bottom).offset(10 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(17 * IPHONE6_H_SCALE));
    }];
    loginLbl.text = @"点击登录";
    loginLbl.textColor = RGBA(178, 178, 178, 1);
    loginLbl.textAlignment = NSTextAlignmentCenter;
    _loginLbl = loginLbl;
    
    
    // 登录后的头像
    UIImageView * faceV = [[UIImageView alloc] init];
    [backV addSubview:faceV];
    [faceV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backV.mas_centerX);
        make.top.equalTo(backV.mas_top).offset(13* IPHONE6_H_SCALE);
        make.width.equalTo(@(56 * IPHONE6_W_SCALE));
        make.height.equalTo(@(56 * IPHONE6_W_SCALE));
    }];
    faceV.layer.cornerRadius = 28 * IPHONE6_W_SCALE;
    faceV.layer.masksToBounds = YES;
    faceV.layer.borderColor = RGBA(118, 118, 118, 1).CGColor;
    faceV.layer.borderWidth = 1.5 * IPHONE6_W_SCALE;
    _faceV = faceV;
    // 积分标签
    UILabel * numLbl = [[UILabel alloc] init];
    [backV addSubview:numLbl];
    [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backV.mas_centerX);
        make.top.equalTo(faceV.mas_bottom).offset(11 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(25 * IPHONE6_W_SCALE));
    }];
    numLbl.textColor = RGBA(242, 205, 0, 1);
    numLbl.textAlignment = NSTextAlignmentCenter;
    numLbl.font = [UIFont systemFontOfSize:28 * IPHONE6_W_SCALE];
    [numLbl sizeToFit];
//    numLbl.text = @"88888";
    _numLbl = numLbl;
    // 积分总额标签
    UILabel * allNumLbl = [[UILabel alloc] init];
    [backV addSubview:allNumLbl];
    [allNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backV.mas_centerX);
        make.top.equalTo(numLbl.mas_bottom).offset(6 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(11 * IPHONE6_H_SCALE));
    }];
    allNumLbl.textAlignment = NSTextAlignmentCenter;
    allNumLbl.text = @"积分总额";
    allNumLbl.font = Font11;
    allNumLbl.textColor = [UIColor whiteColor];
    _allNumLbl = allNumLbl;
    
//    numLbl.backgroundColor = [UIColor redColor];
//    _allNumLbl.backgroundColor = [UIColor greenColor];
    // 登录后右侧的登录按钮
    
    // 跳到会员等级的按钮
    UIButton * memberBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [memberV addSubview:memberBtn];
    memberBtn.frame = CGRectMake(0, 0, WIDTH, 130 * IPHONE6_H_SCALE);
    memberBtn.backgroundColor = [UIColor clearColor];
    [memberBtn addTarget:self action:@selector(seeMemberlevel) forControlEvents:UIControlEventTouchUpInside];
    _memberBtn = memberBtn;
    UIImageView * accessV = [[UIImageView alloc] init];
    [backV addSubview:accessV];
    [accessV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backV.mas_top).offset(53 * IPHONE6_H_SCALE);
        make.right.equalTo(backV.mas_right).offset(-15 * IPHONE6_W_SCALE);
        make.width.equalTo(@(12 * IPHONE6_W_SCALE));
        make.height.equalTo(@(24 * IPHONE6_W_SCALE));
    }];
//    accessV.backgroundColor = [UIColor redColor];
    accessV.image = [UIImage imageNamed:@"icon_qianwang"];
    [accessV sizeToFit];
    _accessV = accessV;
    
    // 分割线
    UIView * seperateV = [[UIView alloc] initWithFrame:CGRectMake(0, 130 * IPHONE6_H_SCALE, WIDTH, 10 * IPHONE6_H_SCALE)];
    [memberV addSubview:seperateV];
    seperateV.backgroundColor = RGBA(240, 239, 245, 1);
    
    // 平台推荐文字
    UIView * redV = [[UIView alloc] init];
    redV.backgroundColor = [UIColor redColor];
    [memberV addSubview:redV];
    [redV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.top.equalTo(seperateV.mas_bottom).offset(14 * IPHONE6_H_SCALE);
        make.width.equalTo(@(4 * IPHONE6_W_SCALE));
        make.height.equalTo(@(16 * IPHONE6_H_SCALE));
    }];
    UILabel * titleLbl = [[UILabel alloc] init];
    [memberV addSubview:titleLbl];
    titleLbl.text = @"平台推荐";
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = Font16;
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redV.mas_right).offset(9 * IPHONE6_W_SCALE);
        make.top.equalTo(seperateV.mas_bottom).offset(14 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 200));
        make.height.equalTo(@(16 * IPHONE6_H_SCALE));
    }];
    
    // 各个平台视图
    CGRect rect = CGRectMake(0, 364 * 0.5 * IPHONE6_H_SCALE, self.view.frame.size.width, 718 * 0.5 * IPHONE6_H_SCALE);
    LineLayout *flowLayout = [[LineLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
    [_sc addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"cellId"];
    self.collectionView = collectionView;
    
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
    
    UIView * tableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 110* IPHONE6_H_SCALE)];
    UIScrollView * headerV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100 * IPHONE6_H_SCALE)];
    UIView * bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 100 * IPHONE6_H_SCALE, WIDTH, 10 *IPHONE6_H_SCALE)];
    bottomV.tag = 100;
    [tableHeaderV addSubview:headerV];
    [tableHeaderV addSubview:bottomV];
    bottomV.backgroundColor = SeparateColor;
    tableHeaderV.backgroundColor = [UIColor whiteColor];
    self.tableView2.tableHeaderView = tableHeaderV;
    _headerV = headerV;
    
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView2.header = header;
    [header beginRefreshing];
    
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
    
    // 检测是否联网
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"没有网络");
            
            [SVProgressHUD showErrorWithStatus:@"无网络连接"];
            _memberV.hidden = YES;
        }else{  // 有网络的情况
            
            [DataTool getMemberCenterDataWithStr:MemberCenter parameters:nil success:^(id responseObject) {
                
                MemberDataModel * dataModel = responseObject;
                //            NSLog(@"会员数据模型：%@", dataModel);
                // 字典转模型
                MemberInfoModel * memberInfoModel = [MemberInfoModel objectWithKeyValues:dataModel.user_info];
                // 字典数组转模型
                NSArray * platmodelArr = [PlatformModel objectArrayWithKeyValuesArray:dataModel.list];
                [self.collectionView reloadData];
                
                self.dataArray  = (NSMutableArray *)platmodelArr;
                if ([dataModel.user_info isKindOfClass:[NSNull class]]) {
//                    [SVProgressHUD showErrorWithStatus:@"未登录"];
                    
                    [self showNoLoginMessage];
                    
                }else{
                    
                    [self showLoginMessage];
                    [SVProgressHUD dismiss];
                    
                    // 头像
                    if (_face == [NSNull class] || _face == nil || ![_face isEqualToString:memberInfoModel.face]) { // 如果首次进入此页面需要设置头像，如果头像发生变化需要重新设置头像
                        _face = memberInfoModel.face;
                    }
                    // 积分
                    if (_num == [NSNull class] || _num == nil || ![_num isEqualToString:memberInfoModel.count_integral]) {
                        _num = memberInfoModel.count_integral;
                    }
                    // 设置头视图
                    [self setUpTopView];
                    
                }
                // 显示
                _memberV.hidden = NO;
            } failure:^(NSError * error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"加载失败"];
            }];

        }
    }];
    [manager startMonitoring];
    
  }


#pragma mark --- UITableViewDelegate


#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView1) {
        return 20;
    }else{
        
        return self.goodsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopCell * cell = [ShopCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.listModel = [self.goodsArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopListModel * listModel = [self.goodsArray objectAtIndex:indexPath.row];
    NSInteger count = listModel.data.count;
    NSInteger hNum;   // 纵向个数
    if (count % 2 == 0) {
        hNum = count / 2;
    }else{
        
        hNum = (count / 2) + 1;
    }
    return (189 * IPHONE6_H_SCALE)* hNum + 55 * IPHONE6_H_SCALE;
//     return (189 * IPHONE6_H_SCALE  + 63 * IPHONE6_W_SCALE)* hNum + 55 * IPHONE6_H_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%lu", self.dataArray.count);
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellId = @"cellId";
    CustomCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.delegate = self;
    PlatformModel * platModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = platModel;
    [cell.picV sd_setImageWithURL:[NSURL URLWithString:platModel.picname]];
    return cell;
}

#pragma mark --- CustomCollectionCellDelegate
- (void)tableViewCell:(CustomCollectionCell *)cell didClickWithURL:(NSString *)url{
    
    NSLog(@"查看更多信息：");
    MoreInfoOfPlatformVC * moreVC = [[MoreInfoOfPlatformVC alloc] init];
    moreVC.url = url;
    moreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreVC animated:YES];
}

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark --- 显示未登录的信息
- (void)showNoLoginMessage{
    
    _loginBtn.hidden = NO;
    _loginLbl.hidden = NO;
    
    _faceV.hidden = YES;
    _numLbl.hidden = YES;
    _allNumLbl.hidden = YES;
    
    _memberBtn.hidden = YES;
}
#pragma mark --- 显示登录后的信息
- (void)showLoginMessage{
    
    _loginBtn.hidden = YES;
    _loginLbl.hidden = YES;
    
    _faceV.hidden = NO;
    _numLbl.hidden = NO;
    _allNumLbl.hidden = NO;
    
    _memberBtn.hidden = NO;
}
#pragma mark --- 点击登录事件
- (void)loginAction{
    NSLog(@"登录...");
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark --- 设置登录后的头部视图
- (void)setUpTopView{
    
    [_faceV sd_setImageWithURL:[NSURL URLWithString:_face] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
    _numLbl.text = _num;
}

#pragma mark --- 跳转到更多信息页面
- (void)seeMoreInfo{
    
    NSLog(@"查看更多信息：");
    MoreInfoOfPlatformVC * moreVC = [[MoreInfoOfPlatformVC alloc] init];
    moreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreVC animated:YES];
}

// 问题按钮点击事件
- (void)problemAction{
    
//    NSLog(@"问题...");
    ServerVC * serverVC = [[ServerVC alloc] init];
    serverVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:serverVC animated:YES];
}
#pragma mark --- ShopCellDelegate
// 跳转到更多商品页面
- (void)tableviewCell:(ShopCell *)cell didClickWithURL:(NSString *)url withName:(NSString *)name{
    
    MoreGoodsVC * moreVC = [[MoreGoodsVC alloc] init];
    moreVC.hidesBottomBarWhenPushed = YES;
    moreVC.titleName = name;
    moreVC.url = url;
    [self.navigationController pushViewController:moreVC animated:YES];
}
// 跳转到商品页面
- (void)tableviewCell:(ShopCell *)cell didClickWithURL:(NSString *)url withTitle:(NSString *)title{
    
    // 跳转到商品详情页
    [self seeGoodsDetailWithURL:url withTitle:title];
}

- (void)seeGoodsDetailWithURL:(NSString *)url withTitle:(NSString * )title{
    
    GoodsDetailVC * goodsDetailVC = [[GoodsDetailVC alloc] init];
    goodsDetailVC.url = url;
    goodsDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

#pragma mark ---- 刷新控件的刷新和加载 
- (void)loadNewData{
    
    [DataTool getShoppingMallDataWithStr:ShoppingMallURL parameters:nil success:^(id responseObject) {
        
        [self.tableView2.header endRefreshing];
        [self.tableView2.footer endRefreshing];
        ShopMallModel * mallModel = responseObject;
        self.bannerArr = (NSMutableArray *)mallModel.banner;
        self.goodsArray = (NSMutableArray *)mallModel.list;
        
        NSInteger num = self.bannerArr.count;
        _headerV.contentSize = CGSizeMake(526 * 0.5 * IPHONE6_W_SCALE*num - 13 *IPHONE6_W_SCALE, 0);
        if (_headerV.subviews.count > 0) {
            for (UIView * view in _headerV.subviews) {
                if (view.tag == 100) {
                }else{
                     [view removeFromSuperview];
                }
            }
        }
        for (int i = 0; i < self.bannerArr.count; i ++) {
            ShopBannerModel * model = [self.bannerArr objectAtIndex:i];
            UIImageView * imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0 + 263 *IPHONE6_W_SCALE * i, 0, 250 * IPHONE6_W_SCALE, 100 * IPHONE6_H_SCALE)];
            [imagV sd_setImageWithURL:[NSURL URLWithString:model.picname] placeholderImage:[UIImage imageNamed:@"123"]];
            imagV.tag = i;
            imagV.userInteractionEnabled = YES;
            [_headerV addSubview:imagV];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeGoodsDetail:)];
            tap.numberOfTouchesRequired = 1;
            [imagV addGestureRecognizer:tap];
        }
        
        [self.tableView2 reloadData];
    } failure:^(NSError * error) {
       
        NSLog(@"错误信息：%@", error);
    }];
}

// banner图上图片的点击事件
- (void)seeGoodsDetail:(UITapGestureRecognizer *)tap{
    
    NSLog(@"banner...");
    
    UIImageView * imgV = (UIImageView *) tap.view;
    ShopBannerModel * model = [self.bannerArr objectAtIndex:imgV.tag];
    [self seeGoodsDetailWithURL:model.wapurl withTitle:model.name];
}

- (void)loadMoreData{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
