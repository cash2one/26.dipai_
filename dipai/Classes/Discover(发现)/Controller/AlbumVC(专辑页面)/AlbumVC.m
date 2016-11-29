//
//  AlbumVC.m
//  dipai
//
//  Created by 梁森 on 16/6/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AlbumVC.h"
// 刷新效果
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

#import "DataTool.h"

#import "AlbumVideoModel.h"
// 热门视频专辑视频模型
#import "HotVideoModel.h"

#import "UIImageView+WebCache.h"
// 更多内容页面的单元格
#import "MoreVideosCell.h"
// 视频详情页
#import "VideoViewController.h"
#import "SVProgressHUD.h"
@interface AlbumVC ()<UICollectionViewDelegateFlowLayout , UICollectionViewDataSource , UICollectionViewDelegate>
/**
 *  头部的图片
 */
@property (nonatomic, strong) UIImageView * picView;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel * titleLbl;
/**
 *  副标题
 */
@property (nonatomic, strong) UILabel * subTitle;
/**
 *  分割线
 */
@property (nonatomic, strong) UIView * separateView;

/**
 *  视频专辑页面的模型
 */
@property (nonatomic, strong) AlbumVideoModel * albumModel;

@property (nonatomic, strong) UICollectionView *collection;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AlbumVC
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
    
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 获取网络数据
    [self getData];
    
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --- 设置UI
- (void)setUpUI{
    // 头部图片
    UIImageView * picView = [[UIImageView alloc] init];
    CGFloat picX = Margin30 * IPHONE6_W_SCALE;
    CGFloat picY = 28 / 2 * IPHONE6_H_SCALE;
    CGFloat picW = 222 / 2 * IPHONE6_W_SCALE;
    CGFloat picH = 252 / 2 * IPHONE6_W_SCALE;
    picView.frame = CGRectMake(picX, picY, picW, picH);
    [self.view addSubview:picView];
    _picView = picView;
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    CGFloat titleX = CGRectGetMaxX(picView.frame) + 28 / 2 * IPHONE6_W_SCALE;
    [self.view addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    // 副标题
    UILabel * subTitle = [[UILabel alloc] init];
    subTitle.numberOfLines = 0;
    [self.view addSubview:subTitle];
    _subTitle = subTitle;
    
    // 播放按钮
    UIButton * playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat playBtnX = titleX;
    CGFloat playBtnY = 230 / 2 * IPHONE6_H_SCALE;
    CGFloat playBtnW = 154 / 2 * IPHONE6_W_SCALE;
    CGFloat playBtnH = 50 / 2 * IPHONE6_H_SCALE;
    playBtn.backgroundColor = [UIColor redColor];
    playBtn.frame = CGRectMake(playBtnX, playBtnY, playBtnW, playBtnH);
    [playBtn setTitle:@"立即播放" forState:UIControlStateNormal];
    playBtn.titleLabel.font = Font12;
    playBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    playBtn.userInteractionEnabled = YES;
    [playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    // 分割线
    UIView * separateView = [[UIView alloc] init];
    separateView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue:245 / 255.0 alpha:1];
    separateView.frame = CGRectMake(0, 308 / 2 * IPHONE6_H_SCALE, WIDTH, Margin20 * IPHONE6_H_SCALE);
    [self.view addSubview:separateView];
    _separateView = separateView;
    
    
}
#pragma mark --- 播放按钮的点击事件
- (void)playAction{
    NSLog(@"点击播放按钮...");
    // 跳转到视频详情页，播放的视频是第一个视频
    VideoViewController * videoVC = [[VideoViewController alloc] init];
    HotVideoModel * videoModel = [self.dataArray objectAtIndex:0];
    videoVC.url = videoModel.wapurl;
    [self.navigationController pushViewController:videoVC animated:YES];
}

#pragma mark --- 添加collectionView
- (void)addCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.minimumInteritemSpacing = 0;
    // 间距
    layout.minimumLineSpacing = 28 * 0.5 * IPHONE6_H_SCALE;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat collectionY = CGRectGetMaxY(_separateView.frame);
    self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, collectionY, WIDTH , HEIGHT - collectionY - 64) collectionViewLayout:layout];
    self.collection.backgroundColor = [UIColor whiteColor];
    [self.collection registerClass:[MoreVideosCell class] forCellWithReuseIdentifier:@"MoreCollection"];
    
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.view addSubview:self.collection];
}
#pragma mark --- 添加刷新和加载的效果
- (void)addRefreshing{
    
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
#pragma mark --- 加载更多数据
- (void)loadMoreData{
   self.collection.footer.state = MJRefreshStateNoMoreData;
//    [self.collection.footer endRefreshing];
    
}

// 单元格的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"单元格个数----%lu", self.dataArray.count);
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
//    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}
// 单元格的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%lu", indexPath.row);
    // 跳转到视频详情页，播放的视频是第一个视频
    VideoViewController * videoVC = [[VideoViewController alloc] init];
    HotVideoModel * videoModel = [self.dataArray objectAtIndex:indexPath.row];
    videoVC.url = videoModel.wapurl;
    [self.navigationController pushViewController:videoVC animated:YES];
   
}

#pragma mark --- 获取网络数据
- (void)getData{
    
    NSLog(@"%@", self.wapurl);
    [SVProgressHUD showWithStatus:@"加载中..."];
    [DataTool getAlbumDataWithStr:self.wapurl parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"视频专辑页面的数据:%@", responseObject);
        // 传过来的是一个模型
        self.albumModel = [[AlbumVideoModel alloc] init];
        self.albumModel = responseObject;
        
        // 设置UI
        [self setUpUI];
        
        // 添加collectionView
        [self addCollectionView];
        // 添加刷新和记载的效果
        [self addRefreshing];
        
        // 设置数据
        [self setData];
        
        NSLog(@"%lu", self.albumModel.videoArr.count);
        self.dataArray = (NSMutableArray *)self.albumModel.videoArr;
        [self.collection reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取视频专辑页面时的错误信息%@", error);
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    
}
#pragma mark --- 设置数据
- (void)setData{
    
    NSDictionary * albumDic = self.albumModel.albumDic;
    // 设置图片
    NSString * picname = albumDic[@"picname"];
    [_picView sd_setImageWithURL:[NSURL URLWithString:picname] placeholderImage:[UIImage imageNamed:@"123"]];
    
    // 设置标题
    NSString * titleStr = albumDic[@"title"];
    CGFloat titleX = CGRectGetMaxX(_picView.frame) + 28 / 2 * IPHONE6_W_SCALE;
    CGFloat titleY = 28 / 2 * IPHONE6_H_SCALE;
    CGFloat titleW = WIDTH - titleX -46 / 2 * IPHONE6_W_SCALE;
    CGFloat titleH = 15;
    _titleLbl.font = Font15;
    _titleLbl.numberOfLines = 0;
    _titleLbl.frame = CGRectMake(titleX, titleY, titleW, titleH);
    _titleLbl.text = titleStr;
//    _titleLbl.text = @"这是测试嘻嘻,这是测试嘻嘻这是测试嘻嘻这是测试嘻嘻这是测试嘻嘻";
    [_titleLbl sizeToFit];
    
    // 设置副标题
    NSString * subTitleStr = albumDic[@"description"];
    CGFloat subX = titleX;
    CGFloat subY = CGRectGetMaxY(_titleLbl.frame) + Margin24 * IPHONE6_H_SCALE;
    CGFloat subW = WIDTH - subX - 46 / 2 * IPHONE6_W_SCALE;
    CGFloat subH = 40;
    _subTitle.font = Font12;
    _subTitle.textColor = Color123;
    _subTitle.frame = CGRectMake(subX, subY, subW, subH);
    _subTitle.text = subTitleStr;
//    _subTitle.text = @"这只是测试信息，这只是测试信息，这只是测试信息，这只是测试信息，这只是测试信息，";
    [_subTitle sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
