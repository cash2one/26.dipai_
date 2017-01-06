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
//#import "TestViewController.h"
// 轮播页（广告页）
#import "AdvertisementView.h"
// 详情页网页
#import "DetailWebViewController.h"
// 视频详情页
#import "VideoViewController.h"
//  赛事详情页
#import "MatchDetailVC.h"
//
#import "PostDetailVC.h"
// 扑克名人堂页面
#import "PokerVC.h"
// 名人堂列表
#import "MorePokersVC.h"
// 视频专辑页面
#import "AlbumVC.h"
// 俱乐部详情页
#import "ClubDetailViewController.h"
// 专题列表
#import "SpecialViewController.h"
// 专题详情页
#import "SpecialDetailVC.h"
// 全部视频专辑
#import "MoreVideosVC.h"
// 名人主页
#import "StarVC.h"
// 普通用户主页
#import "AnyBodyVC.h"
// H5页面
#import "H5ViewController.h"


// 单元格
#import "tournamentCell.h"
#import "InformationCell.h"
#import "PicturesCell.h"
#import "VideoCell.h"


// 刷新第三方
#import "MJRefresh.h"
// 数据层
#import "DataTool.h"
// 首页上传参数模型
#import "InfoPara.h"
// 转模型第三方
#import "MJExtension.h"
#import "AFNetworking.h"
// 列表模型
#import "NewsListModel.h"
// 刷新
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

// 发现页面
#import "DiscoverController.h"

// 活动控制器
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "HttpTool.h"
#import "SVProgressHUD.h"
@interface InfomationViewController ()<UIScrollViewDelegate ,UITableViewDataSource, UITableViewDelegate, AdvertisementViewDelegate, AppDelegate>
{
    NSString * _name;   // 跳转页面接口地址
    NSString * _downLoadURL;// AppStore链接
    NSString *_requestURL;  // 请求URL
}
typedef NS_ENUM(NSUInteger, LSType) {
    /** 资讯 */
    LSTypeInfo = 2,
    /** 图集 */
    LSTypePictures = 4,
    /** 赛事 */
    LSTypeMatch = 5,
    /** 赛事 详情页*/
    LSTypeMatchDetail = 51,
    /** 直播 */
    LSTypeLive = 6,
    /** 视频 */
    LSTypeVideo = 11,
    /** 帖子详情 */
    LSTypePostDetail = 172,
    
     /** 视频专辑 */
    LSTypeVideoList = 101,
    /** 全部视频专辑 */
    LSTypeAllVideo = 10,
    /** 帖子列表 */
    LSTypePostList = 171,
    /** 名人堂*/
    LSTypePokerStar = 151,
    /** 名人主页*/
    LSTypeStar = 153,
    /** 名人堂列表 */
    LSTypePokerStarList = 152,
    /** 俱乐部详细页面 */
    LSTypeClubDetail = 81,
    /** 专题 */
    LSTypeSpecial = 9,
    /** 专题列表 */
    LSTypeSpecialList = 18,
    
    // H5活动
    LSTypeH5 = 201
};


/**
 *  表格
 */
@property (nonatomic, strong) UITableView * tableView;
/**
 *  表格文章数据源
 */
@property (nonatomic, strong) NSMutableArray * newslistArr;
/**
 *  用来装轮播页模型
 */
@property (nonatomic, strong) NSMutableArray * bannerArr;
/**
 *  赛事数据源
 */
@property (nonatomic, strong) NSMutableArray * tournamentArr;
// 弹窗
@property (nonatomic, strong) UIView * popView;
// 弹窗的背景图
@property (nonatomic, strong)  UIView * backView;

@property (nonatomic, strong) UIView * versionBackView;
@end

@implementation InfomationViewController

- (void)dismissWithStr:(NSString *)str{
    NSLog(@"dismisswithstr...");
}

- (NSMutableArray *)newslistArr
{
    if (_newslistArr == nil) {
        _newslistArr = [NSMutableArray array];
    }
    return _newslistArr;
}

- (NSMutableArray *)bannerArr
{
    if (_bannerArr == nil) {
        _bannerArr = [NSMutableArray array];
    }
    
    return _bannerArr;
}

- (NSMutableArray *)tournamentArr
{
    if (_tournamentArr == nil) {
        _tournamentArr = [NSMutableArray array];
    }
    return _tournamentArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [HttpTool pauseWithURL:_requestURL];

}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self  setUpNaviBar];
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.delegate = self;
    // 搭建UI
    [self createUI];
    
//    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(errorWithRefresh) userInfo:nil repeats:NO];
    
}

- (void)setUpNaviBar{
    
    self.naviBar.titleStr = @"资讯";
}


#pragma mark --- 有通知的时候进行跳转
- (void)pushToViewControllerWithURL:(NSString *)url{
    
    NSLog(@"%@", url);
    [HttpTool GET:url parameters:nil success:^(id responseObject) {
        
        NSString * type = responseObject[@"type"];
        NSInteger num = [type integerValue];
        if (num == LSTypeInfo || num == LSTypePictures) {
            // 跳转到资讯页面或图集页面
            DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
            detailVC.url = url;
            detailVC.responseObject = responseObject;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        } else if (num == LSTypeVideo){ // 如果是视频
            // 跳转到视频专辑页
            VideoViewController * videoVC = [[VideoViewController alloc] init];
            videoVC.url = url;
            videoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:videoVC animated:YES];
        } else if (num == LSTypeMatchDetail){  // 如果是赛事详情页
            MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
            detailVC.wapurl = url;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (num == LSTypePostDetail){ // 如果是帖子详情页
            PostDetailVC * postDetail =[[PostDetailVC alloc] init];
            postDetail.wapurl = url;
            postDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:postDetail animated:YES];
        }else if (num == LSTypePokerStar){  // 扑克名人堂页面
            PokerVC * pokerVC = [[PokerVC alloc] init];
            pokerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pokerVC animated:YES];
        }else if (num == LSTypePokerStarList){  // 扑克名人堂列表
            MorePokersVC * morePokers = [[MorePokersVC alloc] init];
            morePokers.wapurl = MorePokersURL;
            morePokers.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:morePokers animated:YES];
        }else if (num == LSTypePostList){   // 帖子列表
            
        }else if (num == LSTypeVideoList){  // 视频专辑
            AlbumVC * albumVC = [[AlbumVC alloc] init];
            albumVC.hidesBottomBarWhenPushed = YES;
            albumVC.wapurl = url;
            [self.navigationController pushViewController:albumVC animated:YES];
        }else if (num == LSTypeClubDetail){ // 俱乐部详情页
            NSString * title = responseObject[@"data"][@"title"];
            ClubDetailViewController * clubDetaiVC = [[ClubDetailViewController alloc] init];
            clubDetaiVC.wapurl = url;
            clubDetaiVC.title = title;
            clubDetaiVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:clubDetaiVC animated:YES];
        }else if (num == LSTypeSpecial){    // 专题
            SpecialViewController * specialVC = [[SpecialViewController alloc] init];
            specialVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:specialVC animated:YES];
        }else if (num == LSTypeSpecialList){    // 专题列表
            SpecialDetailVC * specialVC = [[SpecialDetailVC alloc] init];
            specialVC.wapurl = url;
            specialVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:specialVC animated:YES];
        }else if (num == LSTypeAllVideo){   // 全部视频专辑
            MoreVideosVC * moreVideoVC = [[MoreVideosVC alloc] init];
            moreVideoVC.moreURL = url;
            moreVideoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreVideoVC animated:YES];
        }else if (num == LSTypeStar){   // 名人主页
            if ([responseObject[@"data"][@"certified"] isKindOfClass:[NSNull class]]) {
                AnyBodyVC * anyBodyVC = [[AnyBodyVC alloc] init];
                anyBodyVC.userURL = url;
                anyBodyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:anyBodyVC animated:YES];
            }else{
                StarVC * starVC = [[StarVC alloc] init];
                starVC.userURL = url;
                starVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:starVC animated:YES];
            }
            
        }else if(num == LSTypeH5){  // 如果是H5页面
#warning 未进行测试
            NSString * wapurl = responseObject[@"content"];
            H5ViewController * h5VC = [[H5ViewController alloc] init];
            h5VC.wapurl = wapurl;
            [self.navigationController pushViewController:h5VC animated:YES];
        }
        else{   // 未识别type
            
            NSLog(@"%@", url);
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
        NSLog(@"出错：%@",error);
    }];
    _requestURL = url;
}

#pragma mark ------ 下拉刷新，加载新的数据
- (void)loadNewData
{
    if (self.tableView.footer.state == MJRefreshStateRefreshing) return;    // 如果正在加载就不刷新
    // 如果网络有问题结束刷新状态
    [NSTimer scheduledTimerWithTimeInterval:6.5 target:self selector:@selector(errorWithRefresh) userInfo:nil repeats:NO];
    [DataTool getNewDataWithStr:InformationURL parameters:nil success:^(NSArray * arr) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSArray * bannerModelArr = [arr objectAtIndex:0];
        NSArray * tournamentModelArr = [arr objectAtIndex:1];
        NSArray * listModelArr = [arr objectAtIndex:2];
        // 轮播页的数组
        [self.bannerArr removeAllObjects];
        [self.bannerArr addObjectsFromArray:bannerModelArr];
        // 赛事页的数组
        if (tournamentModelArr.count > 1) {
            NSLog(@"没有赛事");
            [self.tournamentArr removeAllObjects];
//            [self.tournamentArr addObjectsFromArray:tournamentModelArr];
        }else{  // 有赛事
            NSLog(@"有赛事");
            [self.tournamentArr removeAllObjects];
            [self.tournamentArr addObjectsFromArray:tournamentModelArr];
        }
        // 表格的数组
        [self.newslistArr removeAllObjects];
        [self.newslistArr addObjectsFromArray:listModelArr];
        // 添加轮播页
        [self addBannerView];
        [self.tableView reloadData];
        // 添加提示弹窗
        [self addPopView];
       
    } failure:^(NSError * error) {
        
         NSLog(@"获取首页错误信息%@", error);
    }];

}

- (void)addVersionView{
    NSLog(@"查看是否需要更新..");
        // 访问接口，如果有更新提示就显示
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @"1";
    dic[@"ver"] = @"2.2.0";
    [HttpTool POST:DiPaiUpdateURL parameters:dic success:^(id responseObject) {
//        NSLog(@"%@", responseObject);
        NSString * versionFlag = responseObject[@"versionupdate"];
        NSString * content = responseObject[@"content"];
        if ([versionFlag isEqualToString:@"1"]) {
            NSString * url = responseObject[@"downloadurl"];
            NSLog(@"AppStoreURL:%@", url);
            [self showUpdateViewWithContent:content withDownLoadURL:url];
        }else{
        }
    } failure:^(NSError *error) {
        
    }];
}
// 显示更新视图
- (void)showUpdateViewWithContent:(NSString *)content withDownLoadURL:(NSString *)url{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIImageView * versionView = [[UIImageView alloc] init];
    versionView.image = [UIImage imageNamed:@"gengxinbeijing"];
    versionView.userInteractionEnabled = YES;
    UIView * versionBackView = [[UIView alloc] init];
    _versionBackView = versionBackView;
    versionBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [window addSubview:versionBackView];
    [versionBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(window.mas_top);
    }];
    [versionBackView addSubview:versionView];
    [versionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(versionBackView.mas_top).offset(143 * IPHONE6_H_SCALE);
        make.width.equalTo(@(546 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(760 * 0.5 * IPHONE6_W_SCALE));
    }];
    
    // 标题
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.text = @"V2.2版本更新提示";
    [versionView addSubview:titleLbl];
    titleLbl.font = Font15;
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(versionView.mas_centerX);
        make.top.equalTo(versionView.mas_top).offset(91 * IPHONE6_W_SCALE);
        make.width.equalTo(versionView.mas_width);
        make.height.equalTo(@(15 * IPHONE6_H_SCALE));
    }];
    // 更新内容
    UILabel * subTitleLbl = [[UILabel alloc] init];
    subTitleLbl.text = @"更新内容：";
    [versionView addSubview:subTitleLbl];
    subTitleLbl.font = Font13;
    subTitleLbl.textColor = RGBA(51, 51, 51, 1);
    [subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(versionView.mas_left).offset(24 * IPHONE6_W_SCALE);
        make.top.equalTo(versionView.mas_top).offset(153 * IPHONE6_W_SCALE);
        make.width.equalTo(versionView.mas_width);
        make.height.equalTo(@(13 * IPHONE6_H_SCALE));
    }];
    CGRect contentRect = CGRectMake(0, 0, 0, 0);
    CGFloat contentY = 352 * 0.5 * IPHONE6_W_SCALE;
    UILabel * lbl = [[UILabel alloc] init];
//    lbl.backgroundColor = [UIColor redColor];
    lbl.numberOfLines = 0;
    lbl.font = Font13;
    lbl.text = content;
    lbl.textColor = RGBA(112, 112, 112, 1);
    [versionView addSubview:lbl];
    CGFloat contentX = 24 * IPHONE6_W_SCALE;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = Font13;
    dic[NSForegroundColorAttributeName] = RGBA(112, 112, 112, 1);
     contentRect = [content boundingRectWithSize:CGSizeMake(546 * 0.5 * IPHONE6_W_SCALE - 48 * IPHONE6_W_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    lbl.frame = (CGRect){{contentX, contentY}, contentRect.size};
    
    // 取消按钮
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"以后再说" forState:UIControlStateNormal];
    cancleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancleBtn.titleLabel.font = Font15;
    [cancleBtn setTitleColor:RGBA(112, 112, 112, 1) forState:UIControlStateNormal];
    cancleBtn.layer.cornerRadius = 2;
    cancleBtn.layer.borderWidth = 0.5;
    cancleBtn.layer.borderColor = RGBA(112, 112, 112, 1).CGColor;
    [versionView addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(versionView.mas_left).offset(35 * 0.5 * IPHONE6_W_SCALE);
        make.width.equalTo(@(230 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(33 * IPHONE6_W_SCALE));
        make.bottom.equalTo(versionView.mas_bottom).offset(-18 * IPHONE6_W_SCALE);
    }];
    [cancleBtn addTarget:self action:@selector(removeVersionView) forControlEvents:UIControlEventTouchUpInside];
    
    // 更新按钮
    UIButton * updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [updateBtn setTitleColor:RGBA(180, 0, 0, 1) forState:UIControlStateNormal];
    updateBtn.titleLabel.font = Font15;
    updateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    updateBtn.backgroundColor = RGBA(255, 222, 2, 1);
    updateBtn.layer.cornerRadius = 2;
    [versionView addSubview:updateBtn];
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(versionView.mas_right).offset(-35 * 0.5 * IPHONE6_W_SCALE);
        make.width.equalTo(cancleBtn.mas_width);
        make.height.equalTo(cancleBtn.mas_height);
        make.bottom.equalTo(cancleBtn.mas_bottom);
    }];
    _downLoadURL = url;
    [updateBtn addTarget:self action:@selector(turnToAppStore) forControlEvents:UIControlEventTouchUpInside];
}

// 跳转到AppStore进行版本更新
- (void)turnToAppStore{
    if (_downLoadURL.length > 0) {
         [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_downLoadURL]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/di-pai/id1000553183?mt=8"]];
    }
   
    [self removeVersionView];
}
// 移除版本提示框
- (void)removeVersionView{
    [_versionBackView removeFromSuperview];
}
// 添加跳转弹框
- (void)addPopView{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * first = [defaults objectForKey:appStart];
    if (first.length > 0) {
        NSLog(@"App第一次启动");
        [HttpTool GET:PopViewURL parameters:nil success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            id dataDic = responseObject[@"data"];
            if (![dataDic isKindOfClass:[NSString class]]) {    // 如果有数据
                NSString * picName = dataDic[@"picname"];
                _name = dataDic[@"name"];
                // 如果App第一次启动，有弹窗
                UIWindow * window = [UIApplication sharedApplication].keyWindow;
                UIView * popView = [[UIView alloc] init];
                UIView * backView = [[UIView alloc] init];
                backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                backView.userInteractionEnabled = YES;
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAction)];
                tap.numberOfTapsRequired = 1;
                [backView addGestureRecognizer:tap];
                [window addSubview:backView];
                [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                    make.bottom.equalTo(self.view.mas_bottom);
                    make.top.equalTo(window.mas_top);
                }];
                [backView addSubview:popView];
//                popView.backgroundColor = [UIColor redColor];
                [popView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.top.equalTo(backView.mas_top).offset(131 * IPHONE6_H_SCALE);
                    make.width.equalTo(@(280 * IPHONE6_W_SCALE));
                    make.height.equalTo(@(778 * 0.5 * IPHONE6_W_SCALE));
                }];
                
                // 图片
                UIImageView * picV = [[UIImageView alloc] init];
                picV.userInteractionEnabled = YES;
                UITapGestureRecognizer * picTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnAction)];
                picTap.numberOfTapsRequired = 1;
                
                [picV addGestureRecognizer:picTap];
                [popView addSubview:picV];
                [picV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(popView.mas_left);
                    make.right.equalTo(popView.mas_right);
                    make.bottom.equalTo(popView.mas_bottom);
                    make.height.equalTo(@(748 * 0.5 * IPHONE6_W_SCALE));
                }];
                NSLog(@"%@", picName);
                [picV sd_setImageWithURL:[NSURL URLWithString:picName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    NSLog(@"%@",image);
                }];
                
                // 移除按钮
                UIButton * removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [removeBtn setImage:[UIImage imageNamed:@"guanbitanchuang"] forState:UIControlStateNormal];
                [removeBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
                [popView addSubview:removeBtn];
                [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(popView.mas_top);
                    make.right.equalTo(popView.mas_right).offset(29 * 0.5 * IPHONE6_W_SCALE);
                    make.width.equalTo(@(29 * IPHONE6_W_SCALE));
                    make.height.equalTo(@(29 * IPHONE6_W_SCALE));
                }];
                _popView = popView;
                _backView = backView;

            }
        } failure:^(NSError *error) {
            
            NSLog(@"获取数据出错：%@", error);
        }];
        
         [self addVersionView];
        }
    [defaults removeObjectForKey:appStart];
}
// 跳转事件
- (void)turnAction{
    NSLog(@"进行跳转....");
    [self turnPageToDetailView:_name];
}

// 移除背景图
- (void)removeAction{
    
    [_backView removeFromSuperview];
}
#pragma mark --- 添加轮播页
- (void)addBannerView
{
    // 添加轮播页
    AdvertisementView * advertiseView = [[AdvertisementView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HeaderViewHeight * IPHONE6_H_SCALE)];
    //    advertiseView.backgroundColor = [UIColor redColor];
    advertiseView.delegate = self;
    // 确定滚动视图的contentSize
    NSUInteger count = self.bannerArr.count;
    NSNumber * num = [NSNumber numberWithUnsignedInteger:count];
    int counts = [num intValue];
    [advertiseView setScrollWithCount:counts andArray:self.bannerArr];
    // 设置轮播页上的数据
    self.tableView.tableHeaderView = advertiseView;
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    // 添加一个表格的脚视图
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
}

#pragma mark --- 添加表格
- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT  - 64) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    // 添加下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏状态
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 设置header
    self.tableView.header = header;
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 添加上拉加载控件
    //往上拉加载数据.
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置文字
    //加载更多
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    //没有更多数据
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    // 设置footer
    self.tableView.footer = footer;
    
}
#pragma mark --- 跳转页面的点击事件
- (void)Click
{
//    NSLog(@"跳转。。。");
//    TestViewController * testVC = [[TestViewController alloc] init];
//    testVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:testVC animated:YES];
}

#pragma mark --------- 上拉加载数据
- (void)loadMoreData
{
    
    if (self.tableView.header.state == MJRefreshStateRefreshing){
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }   // 如果正在刷新就不加载
    if (self.tableView.header.state == MJRefreshStateRefreshing) return;
    NewsListModel * model = [self.newslistArr lastObject];
    NSString * replaceStr = [NSString stringWithFormat:@"index/%@", model.iD];
    // http://192.168.1.102:8080/app/index/0/0/0
    NSString * urlStr = [InformationURL stringByReplacingOccurrencesOfString:@"index/0" withString:replaceStr];
    [DataTool getMoreDataWithStr:urlStr parameters:nil success:^(NSArray * array) {
        
        [self.tableView.footer endRefreshing];
        id str = array[0];
        if ([str isEqualToString:@"0"]) {
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        } else
        {
            [self.newslistArr addObjectsFromArray:array[1]];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"加载时的错误数据%@", error);
    }];
    
}

#pragma mark --- 刷新失败
- (void)errorWithRefresh{
    if (!self.bannerArr.count) {
        // 结束刷新
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络不通畅"];
    }
}


#pragma mark ------------  UITableViewDataSource
#pragma mark --- 单元格的总行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"数据源中的个数%lu", self.newslistArr.count);
    return self.newslistArr.count + self.tournamentArr.count;
}
#pragma mark --- 单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger tournaments = self.tournamentArr.count;
    
    if (tournaments > 0) {  // 如果有赛事
        if (indexPath.row == 0) {   // 赛事单元格
            tournamentCell * cell = [tournamentCell cellWithTableView:tableView];
            cell.tournamentModel = [self.tournamentArr objectAtIndex:0];
            return cell;
        }
        
        NewsListModel * newslistModel = self.newslistArr[indexPath.row - 1];
        // 需要判断是什么类型的单元格
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

    } else  // 没有赛事
    {
        NewsListModel * newslistModel = self.newslistArr[indexPath.row];
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
    
}
#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击行数%lu", indexPath.row);
    if (self.tournamentArr.count > 0) { // 如果有推荐赛事
        if (indexPath.row == 0) {   // 如果点击的是推荐赛事
            TournamentModel * model = self.tournamentArr[0];
            // 赛事详情页分为两种情况：1.有直播  2.没有直播
            MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
            detailVC.wapurl = model.lurl;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        } else  // 如果点击的不是推荐赛事
        {
            NewsListModel * model = self.newslistArr[indexPath.row -1];
            if ([model.type isEqualToString:@"11"]) {
                // 跳转到视频详情页
                VideoViewController * videoVC = [[VideoViewController alloc] init];
                videoVC.url = model.url;
                videoVC.des = model.descriptioN;
                videoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:videoVC animated:YES];
            } else{
                [self turnPageToDetailView:model.url withNewsListModel:model];
            }
        }
    } else  // 如果没有推荐赛事
    {
        NSLog(@"没有推荐赛事..");
        NewsListModel * model = self.newslistArr[indexPath.row];
        if ([model.type isEqualToString:@"11"]) {
            // 跳转到视频详情页
            VideoViewController * videoVC = [[VideoViewController alloc] init];
            videoVC.url = model.url;
            videoVC.des = model.descriptioN;
            videoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:videoVC animated:YES];
        } else{
            [self turnPageToDetailView:model.url withNewsListModel:model];
        }
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tournamentArr.count > 0) {
        if (indexPath.row == 0) {
            return Margin188 * IPHONE6_H_SCALE;
        }
        NewsListModel * newslistModel = self.newslistArr[indexPath.row -self.tournamentArr.count];
        CGFloat cellHeight;
        if ([newslistModel.type isEqualToString:@"4"]) {
            cellHeight = Margin321 * IPHONE6_H_SCALE;
        } else
        {
            cellHeight = Margin196 * IPHONE6_H_SCALE;
        }
        return cellHeight;
    } else
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
    
}

// 实现代理中的方法
#pragma mark ------- 跳转到详情页网页(点击banner)
- (void)turnPageToDetailView:(NSString *)url
{
      AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"没有网络");
            [SVProgressHUD showErrorWithStatus:@"无网络连接"];
        }else{
        }
    }];
    [manager startMonitoring];

    _requestURL = url;
    [SVProgressHUD show];
    [HttpTool GET:url parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString * type = responseObject[@"type"];
        NSInteger num = [type integerValue];
        if (num == LSTypeInfo || num == LSTypePictures) {
            // 跳转到资讯页面或图集页面
            DetailWebViewController * detailVC = [[DetailWebViewController alloc] init];
            detailVC.url = url;
            detailVC.responseObject = responseObject;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        } else if (num == LSTypeVideo){ // 如果是视频
            // 跳转到视频专辑页
            VideoViewController * videoVC = [[VideoViewController alloc] init];
            videoVC.url = url;
            videoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:videoVC animated:YES];
        } else if (num == LSTypeMatchDetail){  // 如果是赛事详情页
            MatchDetailVC * detailVC = [[MatchDetailVC alloc] init];
            detailVC.wapurl = url;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (num == LSTypePostDetail){ // 如果是帖子详情页
            PostDetailVC * postDetail =[[PostDetailVC alloc] init];
            postDetail.wapurl = url;
            postDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:postDetail animated:YES];
        }else if (num == LSTypePokerStar){  // 扑克名人堂页面
            PokerVC * pokerVC = [[PokerVC alloc] init];
            pokerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pokerVC animated:YES];
        }else if (num == LSTypePokerStarList){  // 扑克名人堂列表
            MorePokersVC * morePokers = [[MorePokersVC alloc] init];
            morePokers.wapurl = MorePokersURL;
            morePokers.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:morePokers animated:YES];
        }else if (num == LSTypePostList){   // 帖子列表
            
        }else if (num == LSTypeVideoList){  // 视频专辑
            AlbumVC * albumVC = [[AlbumVC alloc] init];
            albumVC.hidesBottomBarWhenPushed = YES;
            albumVC.wapurl = url;
            [self.navigationController pushViewController:albumVC animated:YES];
        }else if (num == LSTypeClubDetail){ // 俱乐部详情页
            NSString * title = responseObject[@"data"][@"title"];
            ClubDetailViewController * clubDetaiVC = [[ClubDetailViewController alloc] init];
            clubDetaiVC.wapurl = url;
            clubDetaiVC.title = title;
            clubDetaiVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:clubDetaiVC animated:YES];
        }else if (num == LSTypeSpecial){    // 专题
            SpecialViewController * specialVC = [[SpecialViewController alloc] init];
            specialVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:specialVC animated:YES];
        }else if (num == LSTypeSpecialList){    // 专题列表
            SpecialDetailVC * specialVC = [[SpecialDetailVC alloc] init];
            specialVC.wapurl = url;
            specialVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:specialVC animated:YES];
        }else if (num == LSTypeAllVideo){   // 全部视频专辑
            MoreVideosVC * moreVideoVC = [[MoreVideosVC alloc] init];
            moreVideoVC.moreURL = url;
            moreVideoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreVideoVC animated:YES];
        }else if (num == LSTypeStar){   // 名人主页
            if ([responseObject[@"data"][@"certified"] isKindOfClass:[NSNull class]]) {
                AnyBodyVC * anyBodyVC = [[AnyBodyVC alloc] init];
                anyBodyVC.userURL = url;
                anyBodyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:anyBodyVC animated:YES];
            }else{
                StarVC * starVC = [[StarVC alloc] init];
                starVC.userURL = url;
                starVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:starVC animated:YES];
            }
           
        }
#warning 未进行测试
        else if(num == LSTypeH5){  // 如果是内部H5页面
            NSLog(@"%@", responseObject);
            NSString * wapurl = responseObject[@"content"][@"wapurl"];
            H5ViewController * h5VC = [[H5ViewController alloc] init];
            h5VC.wapurl = wapurl;
            h5VC.hidesBottomBarWhenPushed = YES;
            [self removeAction];
            [self.navigationController pushViewController:h5VC animated:YES];
        }
        else{   // 未识别type
            NSLog(@"---%@",url);
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"出错：%@",error);
    }];
    
    _requestURL = url;
}
// 点击cell跳转到资讯页详情页
- (void)turnPageToDetailView:(NSString *)url withNewsListModel:(NewsListModel *)newsListModel
{
    DetailWebViewController * detaiVC = [[DetailWebViewController alloc] init];
    detaiVC.url = url;
    _requestURL = url;
    detaiVC.newsModel = newsListModel;
    detaiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detaiVC animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}

@end


