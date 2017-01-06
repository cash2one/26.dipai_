//
//  MoreVideosVC.m
//  dipai
//
//  Created by 梁森 on 16/6/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MoreVideosVC.h"

#import "MoreVideosCell.h"

#import "DataTool.h"
// 刷新
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

// 热门专辑视频模型
#import "HotVideoModel.h"

// 视频专辑页面
#import "AlbumVC.h"

#import "SVProgressHUD.h"
@interface MoreVideosVC ()<UICollectionViewDelegateFlowLayout , UICollectionViewDataSource , UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MoreVideosVC

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavigationBar];
    [self createCollectionView];
    // 添加刷新和记载的效果
    [self addRefreshing];
}
- (void)setUpNavigationBar
{
    self.naviBar.titleStr = @"";
    self.naviBar.backgroundColor = [UIColor whiteColor];
    self.naviBar.bottomLine.hidden = NO;
    self.naviBar.popV.hidden = NO;
    self.naviBar.popImage = [UIImage imageNamed:@"houtui"];
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --- 创建collectionView
- (void)createCollectionView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    // 间距
    layout.minimumLineSpacing = 28/2 * IPHONE6_H_SCALE;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WIDTH , HEIGHT - 64) collectionViewLayout:layout];
    self.collection.backgroundColor = [UIColor whiteColor];
    [self.collection registerClass:[MoreVideosCell class] forCellWithReuseIdentifier:@"MoreCollection"];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.view addSubview:self.collection];
    
    [self.collection reloadData];
}
#pragma mark --- 添加刷新和加载的效果
- (void)addRefreshing{
    // 添加下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏状态
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 设置header
    self.collection.header = header;
    // 马上进入刷新状态
    [header beginRefreshing];
    
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置文字
    //加载更多
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    //没有更多数据
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    // 设置footer
    self.collection.footer = footer;
}

#pragma mark --- 刷新获取数据
- (void)loadNewData{
    if (self.moreURL != nil) {
        NSLog(@"接口不为空...");
        NSLog(@"%@", self.moreURL);
        [DataTool getMoreVideosWithStr:self.moreURL parameters:nil success:^(id responseObject) {
            // 结束刷新
            [self.collection.header endRefreshing];
            [self.collection.footer endRefreshing];
            //            NSLog(@"更多页面返回的数据%@", responseObject);
            NSArray * arr = responseObject;
            // 传过来的是模型数组
            self.dataArray = (NSMutableArray *)arr;
            [self.collection reloadData];
        } failure:^(NSError * error) {
            
            NSLog(@"更多页面返回的数据有错%@", error);
        }];
    } else{
        NSLog(@"接口为空,");
        [self.collection.header endRefreshing];
        [self.collection.footer endRefreshing];
    }
    
}
#pragma mark --- 加载获取数据
- (void)loadMoreData{
    
    HotVideoModel * hotVideoModel = [self.dataArray lastObject];
    
    NSString * url = [MoreVideosURL stringByAppendingString:[NSString stringWithFormat:@"/%@", hotVideoModel.iD]];
    NSLog(@"%@", url);
    [DataTool getMoreVideosWithStr:url parameters:nil success:^(id responseObject) {
        // 传过来的是一个数组
        //        NSLog(@"获取更多专辑返回数据:%@", responseObject);
        [self.collection.footer endRefreshing];
        [self.collection.header endRefreshing];
        if ([responseObject isKindOfClass:[NSString class]]) {
            NSLog(@"没有数据了");
            self.collection.footer.state = MJRefreshStateNoMoreData;
        }else{
            [self.dataArray addObjectsFromArray:responseObject];
        }
        
        [self.collection reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取更多专辑出错；%@", error);
        [self.collection.footer endRefreshing];
    }];
    
}

// 单元格的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = 334 / 2 * IPHONE6_W_SCALE;
    CGFloat height = 267 / 2 * IPHONE6_H_SCALE;
    return CGSizeMake(width, height);
    //    return CGSizeMake(SPWidth * 11.3 , SPWidth * 19.8 );
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    //    return UIEdgeInsetsMake( SPWidth , SPWidth , 0 , SPWidth * 0.8 );
    // 上、左、下、右
    CGFloat top = 28 / 2 * IPHONE6_H_SCALE;
    CGFloat left = Margin30 * IPHONE6_W_SCALE;
    CGFloat bottom = 0;
    CGFloat right = left;
    return UIEdgeInsetsMake(top, left, bottom, right);
}

// 单元格的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreVideosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreCollection" forIndexPath:indexPath];
    HotVideoModel * model = self.dataArray[indexPath.row];
    cell.hotVideoModel = model;
    //    [cell cellForViedoInfoShowCollectionCell:model];
    return cell;
}
// 单元格的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HotVideoModel * model = self.dataArray[indexPath.row];
    AlbumVC * albumVC = [[AlbumVC alloc] init];
    // 跳转到视频专辑页面
    albumVC.wapurl = model.wapurl;
    [self.navigationController pushViewController:albumVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
