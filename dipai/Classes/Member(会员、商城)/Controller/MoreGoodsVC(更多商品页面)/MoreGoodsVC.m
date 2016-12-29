//
//  MoreGoodsVC.m
//  dipai
//
//  Created by 梁森 on 16/10/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MoreGoodsVC.h"

// 商品详情页
#import "GoodsDetailVC.h"

// 更多商品单元格
#import "MoreGoodsCell.h"
// 积分商城脚视图
#import "FooterViewInShop.h"

// 商品模型
#import "ShopGoodsModel.h"

#import "MJChiBaoZiFooter2.h"
#import "DataTool.h"
#import "SVProgressHUD.h"
#import "Masonry.h"
@interface MoreGoodsVC ()<UITableViewDelegate ,UITableViewDataSource>
// 表格
@property (nonatomic, strong) UITableView * tableView;
// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation MoreGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
     [self setNavigationBar];
    
    [self addTableView];
    
    [self getData];
}

- (void)getData{
    
    NSLog(@"self.url--->%@", self.url);
    [DataTool  getMoreGoodsDataWithStr:self.url parameters:nil success:^(id responseObject) {
        NSLog(@"---%@", responseObject);
        if ([responseObject isKindOfClass:[NSString class]]) {
            [SVProgressHUD showErrorWithStatus:@"没有数据"];
        }else{
            NSArray * modelArr = responseObject;
            self.dataSource = (NSMutableArray *) modelArr;
        }
        
        [self.tableView reloadData];
        FooterViewInShop * footerV = [[FooterViewInShop alloc] initWithFrame:CGRectMake(0, HEIGHT - 35 * IPHONE6_H_SCALE, WIDTH, 35 * IPHONE6_H_SCALE)];
        [self.view addSubview:footerV];
    } failure:^(NSError * error) {
        
        NSLog(@"获取数据错误：%@", error);
    }];
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = self.titleName;;
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64-35*IPHONE6_H_SCALE) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.tableView.footer = footer;
}
// 加载更多数据
- (void)loadMoreData{
    
    ShopGoodsModel * model = [self.dataSource lastObject];
    NSString * iD = model.goods_id;
    NSString * url = [self.url stringByAppendingString:[NSString stringWithFormat:@"/%@", iD]];
    NSLog(@"url--->%@", url);
     [self.tableView.footer endRefreshing];
    [DataTool getMoreGoodsDataWithStr:url parameters:nil success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject isKindOfClass:[NSString class]]) {  // 如果没有更多数据
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }else{
            
            [self.dataSource addObjectsFromArray:responseObject];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError * error) {
        NSLog(@"获取更多数据出错%@", error);
    }];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreGoodsCell * cell = [MoreGoodsCell cellWithTableView:tableView];
    
    ShopGoodsModel * goodsModel = [self.dataSource objectAtIndex:indexPath.row];
    cell.goodsModel = goodsModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 196 * 0.5 * IPHONE6_H_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsDetailVC * goodsDetail = [[GoodsDetailVC alloc] init];
    ShopGoodsModel * goodsModel = [self.dataSource objectAtIndex:indexPath.row];
    goodsDetail.url = goodsModel.wapurl;
    [self.navigationController pushViewController:goodsDetail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
