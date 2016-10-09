//
//  MyPokersVC.m
//  dipai
//
//  Created by 梁森 on 16/9/6.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MyPokersVC.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"

#import "UIImageView+getSize.h"

// 自定义的navigationBar
#import "NavigationBarV.h"

// 白色背景图
#import "WhiteBackV.h"

#import "CreatePokerV.h"

#import "SVProgressHUD.h"
// 自定义编写视图
#import "WriteViewController.h"
#import "DataTool.h"

// 自定义的UIScrollView
#import "SMScrollView.h"

#import "CellInMyPokers.h"

#import "ModelOfPoker.h"
#import "ModelInPoker.h"

#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"
#import "SVProgressHUD.h"
#import "UMSocial.h"
@interface MyPokersVC ()<UITableViewDataSource, UITableViewDelegate, CellInMyPokersDelegate, UIScrollViewDelegate, UMSocialUIDelegate>{

    NSInteger _offsetX; // 滚动视图的偏移量
    NSInteger _didRow;  // 被点击的下标
    NSInteger _indexOfPics; // 点击图片的下标
    NSString * _imageSeleted;
    
}

@property (nonatomic, strong) WhiteBackV   * backV;

@property (nonatomic, strong) CreatePokerV * createV;

@property (nonatomic, strong) UITableView * tableV;

@property (nonatomic, strong) NSMutableArray * dataSource;

// 用来存储所有的图片
@property (nonatomic, strong) NSMutableArray * allPics;
// 点击图片之前的所有图片
@property (nonatomic, strong) NSMutableArray * previousPics;
// 大图的白色背景
@property (nonatomic, strong) UIView * scBack;

// 装所有图片的滚动视图
@property (nonatomic, strong) UIScrollView * scrollView;
// 上部视图
@property (nonatomic, strong) NavigationBarV * detailTopV;
// 底部视图
@property (nonatomic, strong) UIView * bottomV;

@property (nonatomic, strong) NSMutableArray * imgArr;

// 选中图片的数组
@property (nonatomic, strong) NSMutableArray * selectedImageArr;

/**
 *  选中的牌谱
 */
@property (nonatomic, strong) NSMutableArray * selectedPokerArr;
/**
 *  图片ID数组
 */
@property (nonatomic, strong) NSMutableArray * idArr;
@end

@implementation MyPokersVC

- (NSMutableArray *)idArr{
    
    if (_idArr == nil) {
        _idArr = [NSMutableArray array];
    }
    return _idArr;
}

- (NSMutableArray *)selectedImageArr{
    
    if (_selectedImageArr == nil) {
        _selectedImageArr = [NSMutableArray array];
    }
    return _selectedImageArr;
}

- (NSMutableArray *)imgArr{
    
    if (_imgArr == nil) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

- (NSMutableArray *)allPics{
    
    if (_allPics == nil) {
        _allPics = [NSMutableArray array];
    }
    return _allPics;
}

- (NSMutableArray *)previousPics{
    
    if (_previousPics == nil) {
        _previousPics = [NSMutableArray array];
    }
    return _previousPics;
}

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadNewData]; // 新建后及时显示出来
        
//        [self getData];
    });
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

// 此页面是一个UITableView，每一个自定义单元格中主要是图片按钮
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _offsetX = -1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.push isEqualToString:@"yes"]) {   // 如果是push过来的
        [self setPushUI];
    }else{
        // 如果是present过来的
        self.present = @"yes";
        [self setPresentUI];
        
        self.selectedPokerArr = [NSMutableArray array];
    }
    
    // 添加牌谱表格
    [self addTableView];
    
    // 新建牌谱的按钮
    UIButton * addPokerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:addPokerBtn];
    [addPokerBtn setBackgroundImage:[UIImage imageNamed:@"addPoker"] forState:UIControlStateNormal];
    [addPokerBtn addTarget:self action:@selector(createPokers) forControlEvents:UIControlEventTouchUpInside];
    [addPokerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-17 * IPHONE6_W_SCALE);
        make.bottom.equalTo(self.view.mas_bottom).offset(-16 * IPHONE6_H_SCALE);
        make.width.equalTo(@(42 * IPHONE6_W_SCALE));
        make.height.equalTo(@(42 * IPHONE6_W_SCALE));
    }];
    if ([self.push isEqualToString:@"yes"]) {
        addPokerBtn.hidden = YES;
    }else{
        addPokerBtn.hidden = NO;
    }
}

- (void)getData{
    
    [DataTool getMyPokersWithStr:MyPokers parameters:nil success:^(id responseObject) {
//        NSLog(@"获取我的牌谱:%@",responseObject);
        if ([responseObject isKindOfClass:[NSString class]]) {  // 为空
            
        }else{
            
            self.dataSource = responseObject;
            [_tableV reloadData];   // 及时刷新表格
            [self.allPics removeAllObjects];
            for (ModelOfPoker * model in self.dataSource) {
                
                for (ModelInPoker * pModel in model.rows) {
                    
                    [self.allPics addObject:pModel];
                }
            }
        }
        [_tableV.footer endRefreshing];
        [_tableV.header endRefreshing ];
//        _tableV.header.state = MJRefreshStateNoMoreData;
    } failure:^(NSError * error) {
        NSLog(@"获取我的牌谱出错：%@", error);
    }];
    
}

- (void)setPushUI{
    
    NavigationBarV * topV = [[NavigationBarV alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64 )];
    [self.view addSubview:topV];
    topV.backgroundColor = [UIColor blackColor];
    
    [topV.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [topV.rightBtn addTarget:self action:@selector(createPokers) forControlEvents:UIControlEventTouchUpInside];
    
    topV.leftStr = @"";
    topV.rightStr = @"新建";
}

- (void)popAction{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Date];
    [self.navigationController popViewControllerAnimated:YES];
}

// 创建牌谱事件
- (void)createPokers{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    WhiteBackV * backV = [[WhiteBackV alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backV.backgroundColor = RGBA(255, 255, 255, 0.5);
    [window addSubview:backV];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSubviews:)];
    tap.numberOfTapsRequired = 1;
    [backV addGestureRecognizer:tap];
    _backV = backV;
    
    
    
    CreatePokerV * createV = [[CreatePokerV alloc] init];
    createV.backgroundColor = [UIColor blackColor];
    createV.alpha = 0.9;
    createV.layer.masksToBounds = YES;
    createV.layer.cornerRadius = 8 * IPHONE6_W_SCALE;
    [window addSubview:createV];
    [createV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(342 * 0.5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(526 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(650 * 0.5 * IPHONE6_H_SCALE));
    }];
    [createV.writeBtn addTarget:self action:@selector(writeAction) forControlEvents:UIControlEventTouchUpInside];
    [createV.importBtn addTarget:self action:@selector(importAction) forControlEvents:UIControlEventTouchUpInside];
    [createV.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    _createV = createV;
    
}
// 编写事件
- (void)writeAction{
    
    [_backV removeFromSuperview];
    [_createV removeFromSuperview];
    WriteViewController * writeVC = [[WriteViewController alloc] init];
    
//    NSLog(@"%@", self.userName);
    
    writeVC.userName = self.userName;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:writeVC];
    [self presentViewController:nav animated:YES completion:nil];
}
// 导入事件
- (void)importAction{
    
    [SVProgressHUD showErrorWithStatus:@"尚未开放"];
}
// 关闭事件
- (void)deleteAction{
    
    [_backV removeFromSuperview];
    [_createV removeFromSuperview];
}

- (void)removeSubviews:(UITapGestureRecognizer *)tap{
    
    [_backV removeFromSuperview];
    [_createV removeFromSuperview];
}

- (void)setPresentUI{
    
    NavigationBarV * topV = [[NavigationBarV alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:topV];
    topV.backgroundColor = [UIColor blackColor];
    
    [topV.popBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [topV.rightBtn addTarget:self action:@selector(didSelectPoker) forControlEvents:UIControlEventTouchUpInside];
    
    topV.leftStr = @"取消";
    topV.rightStr = @"完成";
    
}

// dismiss
- (void)dismissAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 选择牌谱完成
- (void)didSelectPoker{
    
    NSArray * arr = [NSMutableArray arrayWithArray:self.selectedPokerArr];
    
    NSInteger allPics = arr.count + self.selectedNumOfPic;
    if (allPics > 9) {
        [SVProgressHUD showErrorWithStatus:@"最多上传九张图片"];
    }else{
        
        if (self.returnTextBlock != nil) {
            self.returnTextBlock(arr);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

// 添加牌谱表格
- (void)addTableView{
    
    UITableView * tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:tableV];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableV = tableV;
    
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    _tableV.footer = footer;
    
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"无新内容" forState:MJRefreshStateNoMoreData];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableV.header = header;
    [header beginRefreshing];
}

- (void)loadNewData{
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Date];
    [self getData];
    
    // 刷新时选中的牌谱全无效
//    [self.selectedPokerArr removeAllObjects];
}

- (void)loadMoreData{
    
    // 加载时选中的牌谱全无效
//    [self.selectedPokerArr removeAllObjects];
    
    ModelOfPoker * pokerM = [self.dataSource lastObject];
    ModelInPoker * model = [pokerM.rows lastObject];
    NSString * url = [MyPokers stringByAppendingString:[NSString stringWithFormat:@"/%@", model.iD]];
//    NSLog(@"%@", url);   
    [DataTool getMyPokersWithStr:url parameters:nil success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSString class]]) {
            _tableV.footer.state = MJRefreshStateNoMoreData;
        }else{
            [self.dataSource addObjectsFromArray:responseObject];
            [_tableV reloadData];
            // 先移除掉所有的图片
            [self.allPics removeAllObjects];
            for (ModelOfPoker * model in self.dataSource) {
                for (ModelInPoker * pModel in model.rows) {
                    [self.allPics addObject:pModel];
                }
            }
        }
        
    } failure:^(NSError * error) {
        NSLog(@"获取更多数据出错%@", error);
    }];
    [_tableV.footer endRefreshing];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    NSLog(@"%lu", self.dataSource.count);
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    CellInMyPokers * cell = [CellInMyPokers cellWithTableView:tableView withIndexPath:indexPath];
    cell.delegate = self;
    
//    NSLog(@"%lu", indexPath.row);
    cell.model = self.dataSource[indexPath.row];
//    NSLog(@"---%lu", indexPath.row);
    if (self.present.length > 0) {
        cell.present = @"present";
        cell.tag = indexPath.row;
        cell.selectedPokerArr = self.selectedPokerArr;
        cell.selectedPokerId = self.idArr;
    }
    cell.didRow = indexPath.row;
    
    
    return cell;
}

// 执行代理方法
#pragma mark --- CellInMyPokers
- (void)tableViewCell:(CellInMyPokers *)cell withTag:(NSInteger)tag withDidRow:(NSInteger)didRow{
    
//    NSLog(@"%lu", tag);
//    NSLog(@"cell.tag:%lu", cell.tag);
//    NSLog(@"点击单元格行数:%lu", didRow);
    NSInteger index = tag;
    NSInteger row = didRow;
    if (row == 0) {
        
        _indexOfPics = index;
    }else{
        
        [self.previousPics removeAllObjects];
        for (int i = 0; i < row; i ++) {
            ModelOfPoker * model = [self.dataSource objectAtIndex:i];
            [self.previousPics addObjectsFromArray:model.rows];
        }
        
        _indexOfPics = index + self.previousPics.count;
    }
    
    _indexOfPics = _indexOfPics + 1;
//    NSLog(@"indexOfPics:%lu", _indexOfPics);
    
    // 展示图片
//    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    // 白色背景
    UIView * scBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    scBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scBack];
    _scBack = scBack;
    
    // 添加所有图片的底部视图
    [self addScrollV];
    
    // 添加所有的图片
    [self addAllPics];
}

// 进行牌谱的选择
- (void)tableViewCell:(CellInMyPokers *)cell withImage:(UIImage *)image withPicId:(NSInteger)iD withModel:(ModelInPoker *)model{
    
//    NSLog(@"选中的图片：%@", image);

//    NSLog(@"%lu", self.selectedPokerArr.count);
    
    if (self.selectedPokerArr.count == 0) {
        [self.selectedPokerArr addObject:image];
        [self.idArr addObject:model.iD];
    }else{
        
        [self.selectedPokerArr addObject:image];
        [self.idArr addObject:model.iD];
        for (int i = 0; i < self.selectedPokerArr.count-1; i ++) {
            
            NSString * id1 = self.idArr[i];
            if ([model.iD isEqualToString:id1]) {
                [self.selectedPokerArr removeObjectAtIndex:i];
                [self.selectedPokerArr removeLastObject];
                
                [self.idArr removeObjectAtIndex:i];
                [self.idArr removeLastObject];
                break;
            }
            
        }
    }
//    NSLog(@"%lu", self.selectedPokerArr.count);
    
    
//     NSLog(@"删除前的数组个数%lu", self.selectedPokerArr.count);
    
//    for (int i = 0; i < self.selectedPokerArr.count ; i ++) {
//        UIImage * image1 = [self.selectedPokerArr objectAtIndex:i];
//        NSData * data1 = UIImagePNGRepresentation(image1);
//        
//        for (int j = i+1; j < self.selectedPokerArr.count; j ++) {
//            
//            UIImage * image = [self.selectedPokerArr objectAtIndex:j];
//            NSData * data2 = UIImagePNGRepresentation(image);
//            if ([data1 isEqualToData:data2]) {
//                [self.selectedPokerArr removeObjectAtIndex:i];
//            }
//        }
//    }
    
//    NSLog(@"删除后的数组个数%lu", self.selectedPokerArr.count);
    
}

// 添加滚动视图
- (void)addScrollV{
    
    // 装滚动视图的滚动视图
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    scrollView.delegate = self;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [_scBack addSubview:scrollView];
    _scrollView = scrollView;
    
    // 添加底部视图
    
    if (self.present.length > 0) {
        
    }else{
        [self addBottomV];
    }
    
    // 添加顶部视图
    [self addTopV];
}

- (void)addTopV{
    
    // 上方视图
    NavigationBarV * topV = [[NavigationBarV alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [_scBack addSubview:topV];
    _detailTopV = topV;
    topV.backgroundColor = [UIColor blackColor];
    
    [topV.popBtn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    
    topV.leftStr = @"";
    topV.titleStr = @"牌谱详情";
    topV.color = [UIColor whiteColor];
}

- (void)addBottomV{

    UIView * bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 46 * IPHONE6_H_SCALE, WIDTH, 46 * IPHONE6_H_SCALE)];
    [_scBack addSubview:bottomV];
    _bottomV = bottomV;
    bottomV.backgroundColor = [UIColor whiteColor];
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    [bottomV addSubview:lineV];
    lineV.backgroundColor = Color216;
    
    // 删除按钮
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomV addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomV.mas_left).offset(20 * IPHONE6_W_SCALE);
        make.top.equalTo(bottomV.mas_top).offset(14 * IPHONE6_H_SCALE);
        make.width.equalTo(@(18 * IPHONE6_W_SCALE));
        make.height.equalTo(@(21 * IPHONE6_W_SCALE));
    }];
    [deleteBtn setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deletePic) forControlEvents:UIControlEventTouchUpInside];
    
    // 分享按钮
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomV addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomV.mas_top).offset(14 * IPHONE6_H_SCALE);
        make.right.equalTo(bottomV.mas_right).offset(-20 * IPHONE6_W_SCALE);
        make.width.equalTo(@(20 * IPHONE6_W_SCALE));
        make.height.equalTo(@(21 * IPHONE6_W_SCALE));
    }];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang1"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addAllPics{
    
    for ( int i = 0 ; i < self.allPics.count ; i++ ) {
        
        SMScrollView *sc = [[SMScrollView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH , HEIGHT)];
        sc.backgroundColor = [UIColor whiteColor];
        sc.maximumZoomScale = 2.0;
        sc.minimumZoomScale = 1.0;
        sc.decelerationRate = 0.2;
        sc.delegate = self;
        sc.showsHorizontalScrollIndicator = NO;
        sc.showsVerticalScrollIndicator = NO;
//        sc.tag = 1 + i;
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//        UIImageView * img = [[UIImageView alloc] init];
        ModelInPoker * model = [self.allPics objectAtIndex:i];
        NSString * picname = model.picname;
        [img sd_setImageWithURL:[NSURL URLWithString:picname]];
        
//        [img sizeToFit];
        [self.imgArr addObject:img];
//        img.backgroundColor = [UIColor redColor];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenViews:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [sc addGestureRecognizer:tap];
        
        UITapGestureRecognizer * twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makePicBigger:)];
        twoTap.numberOfTapsRequired = 2;
        img.userInteractionEnabled = YES;
        [sc  addGestureRecognizer:twoTap];
        
        //   双击没有识别到的时候识别单击手势
        [tap requireGestureRecognizerToFail:twoTap];
        
        img.contentMode = UIViewContentModeScaleAspectFit;  // 图片比例不变，全部显示在
//        img.contentMode = UIViewContentModeCenter;
//        img.contentMode = UIViewContentModeScaleToFill;
//        img.contentMode = UIViewContentModeScaleAspectFill;
        img.tag = 1000 + i;
        img.userInteractionEnabled = YES;
//        [sc addSubview:img];
//        sc.contentSize = CGSizeMake( WIDTH , 0);
        
        sc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        sc.contentSize = img.frame.size;
        sc.alwaysBounceVertical = YES;
        sc.alwaysBounceHorizontal = YES;
        sc.stickToBounds = YES;
        [sc addViewForZooming:img];
        [sc scaleToFit];
//        sc.backgroundColor = [UIColor yellowColor];
        
        [_scrollView addSubview:sc];
    }
    
     _scrollView.contentSize = CGSizeMake( WIDTH * self.allPics.count , 0);
    _scrollView.contentOffset = CGPointMake(WIDTH * (_indexOfPics-1), 0);
}

// 双击放大
- (void)makePicBigger:(UIGestureRecognizer *)gesture{
    
    NSLog(@"双击放大。。");
    
//    UIScrollView * sc = (UIScrollView *)[gesture.view superview];
    UIScrollView * sc = (UIScrollView *)gesture.view;
//    CGFloat zoomScale = sc.zoomScale;
//    zoomScale = (zoomScale == 1.0) ? 2.0 : 1.0;
//    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[gesture locationInView:gesture.view]];
//    [sc zoomToRect:zoomRect animated:YES];
    
    /***************************/
    CGFloat zs = sc.zoomScale;
    zs = (zs == 1.0) ? 2.0 : 1.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    sc.zoomScale = zs;
    [UIView commitAnimations];
    
    /***************************/
//    CGPoint touchPoint = [gesture locationInView:gesture.view];
//    if (sc.zoomScale == sc.maximumZoomScale) {
//        [sc setZoomScale:sc.minimumZoomScale animated:YES];
//    } else {
//        [sc zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
//    }
    
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.view.frame.size.height / scale;
    zoomRect.size.width  =self.view.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

// 隐藏上下视图
- (void)hiddenViews:(UITapGestureRecognizer *)tap{
    
    if ([_imageSeleted isEqualToString:@"yes"]) {
        
        _detailTopV.hidden = NO;
        _bottomV.hidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        for (UIScrollView * scrollV in _scrollView.subviews) {
            scrollV.backgroundColor = [UIColor whiteColor];
        }
        _imageSeleted = @"no";
    }else{
        
        _detailTopV.hidden = YES;
        _bottomV.hidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        for (UIScrollView * scrollV in _scrollView.subviews) {
            scrollV.backgroundColor = [UIColor blackColor];
            
        }
        _imageSeleted = @"yes";
    }
    
}

//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imgView;
    
    
    SMScrollView * scrollV = (SMScrollView *)scrollView;
//    NSLog(@"tag:%lu",scrollView.tag);
//    
//    NSLog(@"_offsetX：%lu", _offsetX);
    if (_offsetX == -1) { // 第一次点击图片进入详情，没有偏移量
        
//        NSLog(@"%lu", _indexOfPics-1);
//        imgView = [self.imgArr objectAtIndex:_indexOfPics-1];
//        return imgView;
        
        return scrollV.viewForZooming;
    }else{
        
//        NSLog(@"。。。。");
//        imgView = [self.imgArr objectAtIndex:_offsetX];
//        return  imgView;
        
        return scrollV.viewForZooming;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    NSLog(@"offset.x:%f", scrollView.contentOffset.x);
    NSInteger offsetX = _scrollView.contentOffset.x / WIDTH;
    NSLog(@"X:%lu", offsetX);
    _offsetX = offsetX;
}

// 删除图片
- (void)deletePic{
    
    NSLog(@"删除");
    NSInteger index;
    if (_offsetX >= 0) {
        index = _offsetX;
    }else{
        index = _indexOfPics -1;
    }
    
    int iIndex = 0;
    int jIndex = 0;
    
    // 现在能获取图片的下标
    ModelInPoker * model = [self.allPics objectAtIndex:index];
//    NSLog(@"%@", model.picname);
    
    for (int i = 0; i < self.dataSource.count; i ++) {
        ModelOfPoker * modelOP = [self.dataSource objectAtIndex:i];
        for (ModelInPoker * modelIP in modelOP.rows) {
            if ([model.picname isEqualToString:modelIP.picname]) {
//                NSLog(@"单元格:%d", i);  // 获取图片所在单元格
                iIndex = i;
                
            }
            
            for (int j = 0; j < modelOP.rows.count; j ++) {
                ModelInPoker * modelInPoker = [modelOP.rows objectAtIndex:j];
                if ([modelInPoker.picname isEqualToString:model.picname]) {
//                    NSLog(@"在单元格中的下标：:%d", j);  // 获取图片所在单元格
                    jIndex = j;
                }
            }
        }
        
    }
    
    ModelOfPoker * modelOP = [self.dataSource objectAtIndex:iIndex];
    ModelInPoker * modelIP = [modelOP.rows objectAtIndex:jIndex];
//    NSLog(@"%@--ID:%@", modelIP.picname, modelIP.iD);
    NSString * url = [DeletePoker stringByAppendingString:[NSString stringWithFormat:@"/%@", modelIP.iD]];
    
    [DataTool deletePokerWithStr:url parameters:nil success:^(id responseObject) {
        
//        NSLog(@"%@", responseObject);
        if ([responseObject[@"state"] isEqualToString:@"1"]) {
            
            [SVProgressHUD showSuccessWithStatus:@"已删除"];   // 删除后刷新也不能及时显示，必须重新进入
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self loadNewData];
            });
        }
    } failure:^(NSError * error) {
        
        NSLog(@"删除图片出错%@", error);
    }];
//    NSLog(@"%lu", index);
    
}
// 分享图片
- (void)shareAction{

    NSLog(@"分享");
    NSInteger index;
    if (_offsetX >= 0) {
        index = _offsetX;
    }else{
        index = _indexOfPics -1;
    }
    ModelInPoker * model = [_allPics objectAtIndex:index];
    NSURL * url = [NSURL URLWithString:model.picname];
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage * image = [UIImage imageWithData:data];
    // 友盟分享代码，复制、粘贴
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55556bc8e0f55a56230001d8"
                                      shareText:@" "
                                     shareImage:image
                                shareToSnsNames:@[UMShareToSina ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                       delegate:self]; // 分享到朋友圈、微信好友、QQ空间、QQ好友
    
    // 分享纯图片
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    [UMSocialData defaultData].extConfig.qzoneData.title = @" ";
    [UMSocialData defaultData].extConfig.qzoneData.shareImage = image;
    [UMSocialData defaultData].extConfig.qzoneData.url = model.picname;
    [UMSocialData defaultData].extConfig.sinaData.shareText = @"";
}

// 移除大图事件
- (void)returnAction{
    
    [_scBack removeFromSuperview];
    _offsetX = -1; // 没有了偏移量
    [self.imgArr removeAllObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ModelOfPoker * model = self.dataSource[indexPath.row];
//    NSLog(@"%lu", _didRow);
    NSUInteger pics = model.rows.count;
    float height = 85 * IPHONE6_W_SCALE + 85 * IPHONE6_W_SCALE * ((pics-1) / 4);
    return 58 * IPHONE6_H_SCALE + height;
}


- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
