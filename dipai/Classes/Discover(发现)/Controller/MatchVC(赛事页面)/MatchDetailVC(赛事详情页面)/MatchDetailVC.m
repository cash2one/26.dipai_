//
//  MatchDetailVC.m
//  dipai
//
//  Created by 梁森 on 16/6/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MatchDetailVC.h"

@interface MatchDetailVC ()
{
    UISegmentedControl *_segmented;
}
@end

@implementation MatchDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setUpNavigationBar];
    
    // 添加头视图
    [self addHeaderView];
    // 添加分段控件
    [self addSegment];
    
    NSLog(@"赛事详情：%@", self.wapurl);
}
#pragma mark --- 设置导航栏
- (void)setUpNavigationBar{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui_baise"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 添加头视图
- (void)addHeaderView{
    // 头视图
    UIImageView * headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 326 * 0.5 * IPHONE6_H_SCALE)];
    headerView.image = [UIImage imageNamed:@"saishi_beijingditu"];
    [self.view addSubview:headerView];

}
#pragma mark --- 添加分段控件 
- (void)addSegment{
    // 分段控件
    _segmented = [[UISegmentedControl alloc]initWithItems:@[@"赛事直播",@"大家在说",@"赛事资讯"]];
    _segmented.selectedSegmentIndex = 0;
    // 被选中时的背景色
    _segmented.tintColor = [UIColor colorWithRed:51 / 255.f green:51 / 255.f blue:51 / 255.f alpha:1];
    _segmented.backgroundColor = [UIColor blackColor];
    
    // 被选中时的字体的颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:Font13} forState:UIControlStateSelected];
    // 正常情况下的字体颜色
    [_segmented setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:Font13} forState:UIControlStateNormal];
    
    // 设置分段控件的样
    _segmented.frame=CGRectMake(0, 326 * 0.5 * IPHONE6_H_SCALE , WIDTH, 40 * IPHONE6_H_SCALE);
    // 为分段控件添加点事件
    [_segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmented];
}
#pragma mark - 分段控件的点击事件
-(void)segmentedClick:(UISegmentedControl*)seg{
    
    // 根据情况改变滚动视图的偏移
//    if (seg.selectedSegmentIndex == 0) {
//        _sc.contentOffset=CGPointMake(0, 0);
//    }else if (seg.selectedSegmentIndex == 1){
//        _sc.contentOffset=CGPointMake( WIDTH , 0);
//    }else{
//        _sc.contentOffset=CGPointMake( WIDTH * 2, 0);
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
