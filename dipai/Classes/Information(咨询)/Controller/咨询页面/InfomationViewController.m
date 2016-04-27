//
//  InfomationViewController.m
//  dipai
//
//  Created by 梁森 on 16/4/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "InfomationViewController.h"
// 导航栏上左右侧按钮的分类
#import "UIBarButtonItem+Item.h"
// 测试的控制器
#import "TestViewController.h"
@interface InfomationViewController ()<UITableViewDataSource, UITableViewDelegate>
/**
 *  表格
 */
@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation InfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"大家来开发";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳转" style:UIBarButtonItemStylePlain target:self action:@selector(Click)];
    
    [self createUI];
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 49 - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSLog(@"%f", self.tableView.frame.size.height);
    [self.view addSubview:self.tableView];
}

- (void)Click
{
    NSLog(@"跳转。。。");
    TestViewController * testVC = [[TestViewController alloc] init];
    testVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:testVC animated:YES];
}

#pragma mark ------------  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"111";
    return cell;
}

@end


