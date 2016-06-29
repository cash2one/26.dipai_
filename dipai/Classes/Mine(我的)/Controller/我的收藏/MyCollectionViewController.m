//
//  MyCollectionViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/23.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyCollectionViewController.h"

#import "DataBase.h"
#import "NewsListModel.h"
#import "DataTool.h"

// 自定义单元格
#import "InformationCell.h"
#import "PicturesCell.h"

// 网页详情页
#import "DetailWebViewController.h"
@interface MyCollectionViewController ()
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * newslistArr;

@end

@implementation MyCollectionViewController

- (NSMutableArray *)dataSource
{
    if (_newslistArr == nil) {
        _newslistArr = [NSMutableArray array];
    }
    
    return _newslistArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏
    [self setNavigationBar];
    
    // 获取数据
    [self getData];
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
    titleLabel.text = @"我的收藏";
    self.navigationItem.titleView = titleLabel;
    
    UIButton * editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 50, 50);
//    editBtn.backgroundColor = [UIColor redColor];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    UILabel * editLbl = [[UILabel alloc] initWithFrame:editBtn.bounds];
    editLbl.text = @"编辑";
    editLbl.textAlignment = NSTextAlignmentRight;
    editLbl.textColor = [UIColor blackColor];
    [editBtn addSubview:editLbl];
    
    [editBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}
#pragma mark --- 返回
- (void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 获取数据
- (void)getData{
    
    [DataTool getCollectionDataWithStr:MyCollectionURL parameters:nil success:^(id responseObject) {
        
        
        
    } failure:^(NSError * error) {
        
    }];
}

#pragma mark --- 编辑按钮的点击事件
- (void)editAction{
    NSLog(@"进行编辑...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.newslistArr.count;
}


#pragma mark --- 单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        NewsListModel * newslistModel = self.newslistArr[indexPath.row];
        // 需要判断是什么类型的单元格
        /*
         2.资讯
         4.图集
         11.视频
         */
        if ([newslistModel.type isEqualToString:@"2"]) {
            InformationCell * cell = [InformationCell cellWithTableView:tableView];
            cell.newslistModel = newslistModel;
            return cell;
        } else if ([newslistModel.type isEqualToString:@"4"])
        {
            PicturesCell * cell = [PicturesCell cellWithTableView:tableView];
            cell.newslistModel = newslistModel;
            return cell;
        } else
        {
            InformationCell * cell = [InformationCell cellWithTableView:tableView];
            cell.newslistModel = newslistModel;
            return cell;
        }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsListModel * model = self.newslistArr[indexPath.row];
    [self turnPageToDetailView:model.url withNewsListModel:model];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NewsListModel * newslistModel = self.newslistArr[indexPath.row];
        CGFloat cellHeight;
        if ([newslistModel.type isEqualToString:@"4"]) {
            cellHeight = Margin321 * IPHONE6_H_SCALE;
        } else
        {
            cellHeight = Margin196 * IPHONE6_H_SCALE;
        }
        return cellHeight;
    
}

#pragma mark --- 跳转到网页详情页
- (void)turnPageToDetailView:(NSString *)url withNewsListModel:(NewsListModel *)newsListModel
{
    DetailWebViewController * detaiVC = [[DetailWebViewController alloc] init];
    detaiVC.url = url;
    detaiVC.newsModel = newsListModel;
    detaiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detaiVC animated:YES];
}

@end
