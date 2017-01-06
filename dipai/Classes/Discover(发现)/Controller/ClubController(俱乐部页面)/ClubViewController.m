//
//  ClubViewController.m
//  dipai
//
//  Created by 梁森 on 16/6/11.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ClubViewController.h"
// 城市选择视图
#import "CityView.h"
// 头视图
#import "ViewForHeader.h"
// 表格的内容视图
#import "BackViewOfTable.h"
// 俱乐部页面的自定义单元格
#import "CellInClubView.h"

#import "DataTool.h"
// 城市模型
#import "CityModel.h"

// 城市中俱乐部的模型
#import "ClubsInCityModel.h"

// 俱乐部详情页
#import "ClubDetailViewController.h"

#import "SVProgressHUD.h"
#import "Masonry.h"
@interface ClubViewController ()<UITableViewDataSource, UITableViewDelegate>
/**
 *  城市模型数组
 */
@property (nonatomic, strong) NSArray * cityModelArr;
/**
 *  所有的数据
 */
@property (nonatomic, strong) NSArray * allCityModels;
/**
 *  用来装所有城市的所有俱乐部
 */
@property (nonatomic, strong) NSArray * clubsModelArr;

/**
 *  城市按钮
 */
@property (nonatomic, strong) UIButton * cityBtn;
/**
 *  城市标签
 */
@property (nonatomic, strong) UILabel * cityLb;

/**
 *  展开、收起图片
 */
@property (nonatomic, strong) UIImageView * arrowImg;
/**
 *  城市选择视图
 */
@property (nonatomic, strong) CityView * cityView;

/**
 *  背景图
 */
@property (nonatomic, strong) UIView * backView;
/**
 *  城市选择视图的高度
 */
@property (nonatomic, assign) CGFloat cityViewH;
/**
 *  城市选择按钮数组
 */
@property (nonatomic, strong) NSMutableArray * btnArr;

/**
 *  表格
 */
@property (nonatomic, strong) UITableView * tableView;



@end

@implementation ClubViewController

- (NSArray *)clubsModelArr{
    if (_clubsModelArr == nil) {
        _clubsModelArr = [NSMutableArray array];
    }
    return _clubsModelArr;
}

- (NSArray *)cityModelArr{
    if (_cityModelArr == nil) {
        _cityModelArr = [NSArray array];
    }
    return _cityModelArr;
}

- (NSMutableArray *)btnArr{
    if (_btnArr == nil) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (NSArray *)allCityModels{
    if (_allCityModels == nil) {
        _allCityModels = [NSArray array];
    }
    return _allCityModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"---clubURL---%@", self.clubURL);
    // 设置导航栏
    [self setUpNavigationBar];
    // 获取数据
    [self getData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1]];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_beijingditu"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

#pragma mark --- 设置导航栏内容
- (void)setUpNavigationBar
{
    self.naviBar.titleStr = @"俱乐部";
    self.naviBar.popV.hidden = NO;
    self.naviBar.popImage = [UIImage imageNamed:@"houtui_baise"];
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    // 创建城市按钮
    [self createCityBtn];
}
- (void)createCityBtn{
    // 创建城市按钮
    // 左上角选择城市的按钮
    _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 这个按钮有点大，便于放label和imageView
//    _cityBtn.backgroundColor = [UIColor redColor];
    [_cityBtn addTarget:self action:@selector(buttonClickSelect:) forControlEvents:UIControlEventTouchUpInside];
     [self.naviBar addSubview:_cityBtn];
    [_cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.naviBar.mas_right).offset(-20);
        make.top.equalTo(self.naviBar.mas_top).offset(20);
        make.width.equalTo(@(60 * IPHONE6_W_SCALE));
        make.height.equalTo(@(50 * IPHONE6_W_SCALE));
    }];
//    _cityBtn.frame = CGRectMake(0, 0, 60, 50);
    _cityLb = [[UILabel alloc] initWithFrame:CGRectMake( 3 , 15 , 10, 20)];
    _cityLb.textAlignment = NSTextAlignmentRight;
    // 默认显示全部
    _cityLb.text = @"全部";
//    _cityLb.textColor = [UIColor colorWithRed:180/255.f green:243/255.f blue:217/255.f alpha:1];
    _cityLb.textColor = [UIColor whiteColor];
    _cityLb.font = Font15;
    [_cityLb sizeToFit];
    [_cityBtn addSubview:_cityLb];
    // 显示图标：^
    _arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(_cityLb.frame.size.width + 8 , _cityLb.center.y/2 + 8.5, 12 , 7)];
    _arrowImg.image = [UIImage imageNamed:@"xiala2"];
    _arrowImg.userInteractionEnabled = YES;
    [_cityBtn addSubview:_arrowImg];
   
}

#pragma mark --- 添加城市选择视图
- (void)addCityView{
    
    // 添加背景图，但不显示
    UIView * backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
    [self.view addSubview:backView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBackView:)];
    [backView addGestureRecognizer:tap];
    _backView = backView;
    
    // 添加城市选择视图，但并不显示出来
    CityView * cityView = [[CityView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 0)];
    cityView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cityView];
    _cityView = cityView;
}

#pragma mark --- 
- (void)removeBackView:(UITapGestureRecognizer *)tap{
    
    [self removeBackViewFromView];
}
#pragma mark --- 移除背景图
- (void)removeBackViewFromView{
    _cityBtn.selected = !_cityBtn.selected;
    
    _arrowImg.image = [UIImage imageNamed:@"xiala2"];
    
    // 隐藏背景图
    _backView.frame = CGRectMake(0, 64, WIDTH, 0);
    
    // 隐藏城市选择视图
    [UIView animateWithDuration:0.5 animations:^{
        _cityView.frame = CGRectMake(0, -_cityViewH, WIDTH, 0);
    } completion:nil];
}

#pragma mark ---- 城市按钮的点击事件
- (void)buttonClickSelect:(UIButton *)cityBtn{
    NSLog(@"点击城市按钮...");
    _cityBtn.selected = !_cityBtn.selected;
    if (_cityBtn.selected) {
        _arrowImg.image = [UIImage imageNamed:@"shouqi2"];
        
        // 显示背景图
        _backView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);

        CGFloat cityX = 0;
        CGFloat cityY = 64;
        CGFloat cityW = WIDTH;
        // 这个高度是会变的
        CGFloat cityH = _cityViewH;
        // 显示城市选择图
        [UIView animateWithDuration:0.2 animations:^{
            _cityView.frame = CGRectMake(cityX, cityY, cityW, cityH);
        } completion:nil];
        
    } else{
        _arrowImg.image = [UIImage imageNamed:@"xiala2"];
        
        // 隐藏背景图
        _backView.frame = CGRectMake(0, 0, WIDTH, 0);
        
        CGFloat cityX = 0;
        CGFloat cityY = -_cityViewH;
        CGFloat cityW = WIDTH;
        // 这个高度是会变的
        CGFloat cityH = 0;
        // 显示城市选择图
        [UIView animateWithDuration:0.2 animations:^{
            _cityView.frame = CGRectMake(cityX, cityY, cityW, cityH);
        } completion:nil];
    }
}

#pragma mark --- 返回上一个视图控制器
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 获取数据
- (void)getData{
    // CityURL  http://10.0.0.14:8080/app/club/list/7
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    // 获取所有的城市
    [DataTool  getCitysDataWithStr:CityURL parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        // 创建俱乐部的tableView
        [self createTableView];
        // 添加城市选择视图
        [self addCityView];
//        NSLog(@"获取城市数据:%@", responseObject);
        self.cityModelArr = responseObject;
        // 设置数据
        [self setData];
        
    } failure:^(NSError * error) {
        
        NSLog(@"获取城市数据出错：%@", error);
        [self setData];
    }];
    
    // 获取所有城市的俱乐部
    [DataTool getClubsInCityWithStr:ClubsInCity parameters:nil success:^(id responseObject) {
        //        NSLog(@"所有城市的所有俱乐部:%@", responseObject);
        self.clubsModelArr = responseObject;
        self.allCityModels = responseObject;
        
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取城市中的俱乐部出错%@", error);
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    
    
}

#pragma mark --- 设置数据
- (void)setData{
    // self.cityModelArr.count:16
    
    NSMutableArray * cityNameArr = [NSMutableArray array];
    [cityNameArr addObject:@"全部"];
    for (CityModel * model in self.cityModelArr) {
        [cityNameArr addObject:model.title];
    }
    
    // cityNameArr.count:16
    for (int i = 0; i < cityNameArr.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX = Margin30 * IPHONE6_W_SCALE;
        CGFloat btnY = 42 * 0.5 * IPHONE6_H_SCALE;
        CGFloat btnW = 156 * 0.5 * IPHONE6_W_SCALE;
        CGFloat btnH = 54 * 0.5 * IPHONE6_H_SCALE;
        
        int j = i / 4;
        int k = i % 4;
        
        btn.frame = CGRectMake(btnX + k * (btnW + Margin22 * IPHONE6_W_SCALE), btnY + j*(34*0.5*IPHONE6_H_SCALE + btnH), btnW, btnH);
        btn.backgroundColor = [UIColor redColor];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置文字颜色
        // 被选中时文字是白色
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        // 未被选中时文字是102
        [btn setTitleColor:[UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1] forState:UIControlStateNormal];
        // 设置按钮颜色
        [btn setBackgroundColor:[UIColor whiteColor]];
        // 圆角
        btn.layer.cornerRadius = 2;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [[UIColor colorWithRed:201 / 255.0 green:201 / 255.0 blue:201 / 255.0 alpha:1] CGColor];
        // 设置按钮上的文字
        [btn setTitle:cityNameArr[i] forState:UIControlStateNormal];
//        [btn setTitle:@"12" forState:UIControlStateNormal];
        btn.titleLabel.font = Font12;
        
        btn.tag = 100 + i;
        
        // 为按钮添加点击事件
        [btn addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor redColor];
        }
        
        [self.btnArr addObject:btn];
        
        // cityNameArr.count - 1
        if (i == cityNameArr.count - 1) {
            CGFloat cityViewH = CGRectGetMaxY(btn.frame) + 52*0.5*IPHONE6_H_SCALE;
            _cityViewH = cityViewH;
        }
        [_cityView addSubview:btn];
    }
    _cityView.frame = CGRectMake(0, -_cityViewH, WIDTH, _cityViewH);
    _cityView.cityModelArr = self.cityModelArr;
}


#pragma mark --- 城市选择视图上按钮的点击事件
- (void)selectCity:(UIButton *)btn{
    
    NSInteger btnIndex = btn.tag;
    // 为按钮添加点击事件，显示某个城市的所有俱乐部
    
    /***********显示某个城市的所有俱乐部**********/
    if (btn.tag == 100) {
        self.clubsModelArr = self.allCityModels;
        [self.tableView reloadData];
    }else{
            
        NSInteger index = btn.tag - 101;
        ClubsInCityModel * model = [self.allCityModels objectAtIndex:index];
            NSMutableArray * arr = [NSMutableArray array];
            [arr addObject:model];
            self.clubsModelArr = (NSArray *)arr;
        
        [self.tableView reloadData];
    }
    
    
    for (int i = 0; i < self.btnArr.count; i ++) {
        UIButton * btn = self.btnArr[i];
        if (btn.tag == btnIndex) {
            [btn setBackgroundColor:[UIColor redColor]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else
        {
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:[UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
    [self removeBackViewFromView];
    
    // 设置城市按钮的文字
    _cityLb.text = btn.titleLabel.text;
       // 要传来按钮的一个ID
}
#pragma mark --- 为按钮添加点击事件，显示某个城市的所有俱乐部
- (void)showClubsInCity:(UIButton *)btn{
   
    
}

#pragma mark - 创建俱乐部的tableView
- (void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 64 , WIDTH , HEIGHT - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark ---UITableViewDataSource
// 分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.clubsModelArr.count;
}
// 每个分区中单元格的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ClubsInCityModel * clubsInCityModel = [self.clubsModelArr objectAtIndex:section];
    return  clubsInCityModel.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellInClubView * cell = [CellInClubView cellWithTableView:tableView];
    ClubsInCityModel * clubsModel = [self.clubsModelArr objectAtIndex:indexPath.section];
    cell.clubModel = [clubsModel.rows objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark --- 头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    ViewForHeader * headerView = [[ViewForHeader alloc] init];
    ClubsInCityModel * model = self.clubsModelArr[section];
    headerView.name = model.name;
    headerView.num = [NSString stringWithFormat:@"%lu", model.rows.count];
    return headerView;
}
#pragma mark --- 脚视图

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, Margin14 * IPHONE6_H_SCALE)];
    footerView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    return footerView;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//   
//}
#pragma mark --- 头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 33 * IPHONE6_H_SCALE;
}
#pragma mark --- 脚视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Margin14 * IPHONE6_H_SCALE;
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 454 * 0.5 * IPHONE6_H_SCALE;
}
#pragma mark --- 单击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClubDetailViewController * clubDetaiVC = [[ClubDetailViewController alloc] init];
    ClubsInCityModel * clubsModel = self.clubsModelArr[indexPath.section];
    ClubModel * clubModel = [clubsModel.rows objectAtIndex:indexPath.row];
    clubDetaiVC.wapurl = clubModel.wapurl;
    clubDetaiVC.title = clubModel.title;
    [self.navigationController pushViewController:clubDetaiVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
