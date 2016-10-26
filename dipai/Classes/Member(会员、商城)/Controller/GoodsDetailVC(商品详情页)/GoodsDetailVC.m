//
//  GoodsDetailVC.m
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "GoodsDetailVC.h"

// 订单详情页
#import "OrderDetailVC.h"

// 商品详情模型
#import "GoodsDetailModel.h"
// 商品详情页单元格
#import "GoodsDetailCell.h"

#import "Masonry.h"
#import "DataTool.h"
#import "UIImageView+WebCache.h"
@interface GoodsDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) GoodsDetailModel * goodsModel ;

@end

@implementation GoodsDetailVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
     [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"url:---%@", self.url);
    
    [self setNavigationBar];
    
    [self setUpUI];
    
   
}
// 获取数据
- (void)getData{
    
    [DataTool getGoodsDetailMessageWIthStr:self.url parameters:nil success:^(id responseObject) {
        
        GoodsDetailModel * goodsModel  = [[GoodsDetailModel alloc] init];
        goodsModel = responseObject;
        _goodsModel = goodsModel;
        
        [self.tableView reloadData];
        [self setData];
    } failure:^(NSError * error) {
        NSLog(@"获取数据错误信息：%@", error);
    }];
}

- (void)setData{
 
   
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"商品购买";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setUpUI{
    
    [self addTableView];
    
    // 立即兑换的按钮
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor = [UIColor redColor];
    [buyBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [self.view addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(49 * IPHONE6_H_SCALE));
    }];
    [buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 49 *IPHONE6_H_SCALE) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsDetailCell * cell = [GoodsDetailCell cellWithTableView:tableView];
    
    NSLog(@"%@", _goodsModel);
    cell.detailModel = _goodsModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary * attentionDic = [NSMutableDictionary dictionary];
    attentionDic[NSFontAttributeName] = [UIFont systemFontOfSize:13*IPHONE6_W_SCALE];
    CGSize attentionSize = [_goodsModel.goods_name sizeWithAttributes:attentionDic];
    CGFloat h = attentionSize.height;
    return 528.5 * IPHONE6_H_SCALE + h + 13 * IPHONE6_H_SCALE;
}

// 跳转到购买页面
- (void)buyAction{
    
    OrderDetailVC * orderDetailVC = [[OrderDetailVC alloc] init];
    orderDetailVC.goodID =  _goodsModel.goods_id;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
