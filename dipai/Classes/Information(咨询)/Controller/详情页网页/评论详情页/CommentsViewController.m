//
//  CommentsViewController.m
//  dipai
//
//  Created by 梁森 on 16/5/19.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CommentsViewController.h"

#import "UIBarButtonItem+Item.h"

#import "DataTool.h"
// 评论列表中的数据模型
#import "CommentsModel.h"
// 评论列表自定义单元格
#import "CommentsTableViewCell.h"

// VM 评论的frame
#import "CommentsFrame.h"

// 刷新
#import "MJChiBaoZiFooter2.h"
#import "MJChiBaoZiHeader.h"

#import "SVProgressHUD.h"
// 发表的背景图
#import "BackgroundView.h"
// 评论视图(发表)
#import "CommentView.h"
//
#import "LSAlertView.h"
// 登录页面
#import "LoginViewController.h"

#import "SBModel.h"

// 普通人主页
#import "AnyBodyVC.h"
// 名人主页
#import "StarVC.h"

#import "Masonry.h"
@interface CommentsViewController ()<UITableViewDataSource, UITableViewDelegate, CommentViewDelegate, LSAlertViewDeleagte, CommentsTableViewCellDelegate>

{
    // 发表的内容
    NSString * _sendContent;
    
    // 回复的ID
    NSString * _replyID;
    
    // 判断是否点击回复
    NSString * _reply;
    
    // 回复的用户名
    NSString * _replyName;
}
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * tableView;
/**
 *  背景图
 */
@property (nonatomic, strong) UIView * backView;
/**
 *  发表视图
 */
@property (nonatomic, strong) CommentView * commentView;

@property (nonatomic, strong) UIView * alertBackView;

@property (nonatomic, strong) LSAlertView * alertView;
/**
 *  回复视图
 */
@property (nonatomic, strong) UIImageView * replyView;

// 回复用户的模型
@property (nonatomic, strong) CommentsModel * model;

@property (nonatomic, strong) SBModel * sbModel;
// 没有评论的提示图片
@property (nonatomic, strong) UIImageView * imageV;

@end

@implementation CommentsViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    // 每次进来的时候都要检测是否登录
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if ((cookieName || wxData) && _sendContent) {  // 如果已经登录，并且有发表内容，则进行发表
        NSMutableDictionary * CommentDic = [NSMutableDictionary dictionary];
        //        CommentDic[@"id"] = self.newsModel.iD;
        
        NSLog(@"---replyID---%@", _replyID);
        
        CommentDic[@"id"] = self.iD;
        if (_reply) {   // 如果是进行回复
            CommentDic[@"types"] = _replyID;
        } else{ // 进行评论
            CommentDic[@"types"] = @"0";
        }
           // 0:评论  1:回复
        CommentDic[@"type"] = self.type;
        CommentDic[@"content"] = _sendContent;
        [DataTool postWithStr:SendComment parameters:CommentDic success:^(id responseObject) {
            
            NSLog(@"发表评论返回的数据---%@", responseObject);
            NSString * content = [responseObject objectForKey:@"content"];
            NSLog(@"－－content--%@", content);
            
            [SVProgressHUD showSuccessWithStatus:@"发表成功"];
        } failure:^(NSError * error) {
            
            NSLog(@"发表评论的错误信息%@", error);
            
        }];
    }
    
    [self.tableView.header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏内容
    [self setUpNavigationBar];
    
    [self setUpUI];
    // 添加底部的评论视图
    [self addBottomView];
    
    // 对键盘添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 添加下拉刷新控件
//    [self]
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark --- 键盘发生变化后通知
- (void)keyBoardChanged:(NSNotification *)note
{
    // 键盘的大小
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 键盘出现的时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    NSLog(@"%@", _commentView);
    if (frame.origin.y == HEIGHT) {   // 当键盘没有弹出的时候
        
        [UIView animateWithDuration:duration animations:^{
            
            _commentView.transform = CGAffineTransformIdentity;
        }];
    } else
    {
        [UIView animateWithDuration:duration animations:^{
            
            _commentView.transform = CGAffineTransformMakeTranslation(0, -(frame.size.height + Margin242 * IPHONE6_H_SCALE));
        }];
    }
}

#pragma mark --- 设置导航栏内容
- (void)setUpNavigationBar
{
    self.naviBar.titleStr = @"评论列表";
    self.naviBar.popV.hidden = NO;
    self.naviBar.backgroundColor = [UIColor whiteColor];
    self.naviBar.bottomLine.hidden = NO;
    self.naviBar.popImage = [UIImage imageNamed:@"houtui"];
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];

    
}
#pragma mark --- 返回上一个视图控制器
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 设置UI
- (void)setUpUI{
    CGFloat x = 0;
    CGFloat y = 64;
    CGFloat w = WIDTH;
//    CGFloat h = HEIGHT - Margin92 * IPHONE6_H_SCALE;
    CGFloat h = HEIGHT  - Margin92 * IPHONE6_H_SCALE;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tableView];
    
    UIImageView * imageV = [[UIImageView alloc] init];
    [self.view addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"meiyouxiangguanpinglun"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(298 * 0.5 * IPHONE6_H_SCALE);
        make.width.equalTo(@(242 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(187 * 0.5 * IPHONE6_W_SCALE));
    }];
    _imageV = imageV;
    _imageV.hidden = YES;
    
    // 添加下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏状态
    [header setTitle:@"正在玩命加载中..." forState:MJRefreshStateRefreshing];
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
    // 设置footer
    self.tableView.footer = footer;
}

#pragma mark --- 加载新的数据
- (void)loadNewData{
    // 如果网络有问题结束刷新状态
//    [NSTimer scheduledTimerWithTimeInterval:6.5 target:self selector:@selector(errorWithRefresh) userInfo:nil repeats:NO];
    
    NSString * url = [NSString stringWithFormat:@"%@/%@/%@", CommentsURL, self.iD, self.type];
//    NSLog(@"%@", url);
    
    [DataTool getCommentsListWithStr:url parameters:nil success:^(id responseObject) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        // 传递过来的是模型数组(模型是评论模型)
        
        if ([responseObject isKindOfClass:[NSString class]]) {
            
            _imageV.hidden = NO;
        }else{
            _imageV.hidden = YES;
            NSArray * commentsArr = responseObject;
            NSMutableArray * commentsFrameArr = [NSMutableArray array];
            for (CommentsModel * commentModel in commentsArr) {
                CommentsFrame * commentsFrame = [[CommentsFrame alloc] init];
                // 将模型传递给视图模型
                commentsFrame.comments = commentModel;
                [commentsFrameArr addObject:commentsFrame];
            }
            // 将视图模型数组赋值给数据源
            NSLog(@"模型个数：%lu", commentsFrameArr.count);
            self.dataSource = commentsFrameArr;
        }
        
        [self.tableView reloadData];
    } failure:^(NSError * error) {
    
        NSLog(@"获取评论列表的错误信息%@",error);
    }];
}
// 如果网络有问题结束刷新
- (void)errorWithRefresh{
    // 如果数据源中没有数据
    if (self.dataSource.count < 1) {
        // 结束刷新
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络不通畅"];
    }
    
}
#pragma mark --- 加载更多数据
- (void)loadMoreData{
    
    CommentsFrame * commentsFrameModel = [self.dataSource lastObject];
    CommentsModel * commentsModel = commentsFrameModel.comments;
    
    NSString * url = [NSString stringWithFormat:@"%@/%@/%@/%@", CommentsURL, self.iD, self.type, commentsModel.comment_id];
    
    
    NSLog(@"---url---%@", url);
    [DataTool getCommentsListWithStr:url parameters:nil success:^(id responseObject) {
        [self.tableView.footer endRefreshing];
        
        if ([responseObject isKindOfClass:[NSString class]]) {  // 如果返回的数据为空
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }else{
            // 传递过来的是模型数组(模型是评论模型)
            NSArray * commentsArr = responseObject;

            NSMutableArray * commentsFrameArr = [NSMutableArray array];
            for (CommentsModel * commentModel in commentsArr) {
                CommentsFrame * commentsFrame = [[CommentsFrame alloc] init];
                // 将模型传递给视图模型
                commentsFrame.comments = commentModel;
                [commentsFrameArr addObject:commentsFrame];
            }
            // 将视图模型数组赋值给数据源
            [self.dataSource addObjectsFromArray:commentsFrameArr];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
        NSLog(@"获取评论列表的错误信息%@",error);
    }];
}
#pragma mark --- 添加底部的评论按钮
- (void)addBottomView{
    UIView * bottomView = [[UIView alloc] init];
    CGFloat bottomX= 0;
    CGFloat bottomH = 92 * 0.5 * IPHONE6_H_SCALE;
    CGFloat bottomY = HEIGHT - bottomH;
    CGFloat bottomW = WIDTH;
    bottomView.frame = CGRectMake(bottomX, bottomY, bottomW, bottomH);
    [self.view addSubview:bottomView];
    
    // 横线
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color216;
    line.frame = CGRectMake(0, 0, WIDTH, 0.5);
    [bottomView addSubview:line];
    
    // 评论按钮
    UIButton * commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnX = Margin30 * IPHONE6_W_SCALE;
    CGFloat btnY = Margin14 * IPHONE6_H_SCALE;
    CGFloat btnW = WIDTH - 2 * btnX;
    CGFloat btnH = bottomH - 2 * btnY;
    commentBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [commentBtn setImage:[UIImage imageNamed:@"xiepinglunBtn"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:commentBtn];
}

#pragma mark --- 评论按钮的点击事件
- (void)commentAction{
    UIView * backView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backView.backgroundColor = ColorBlack60;
    
    // 当前顶层窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 添加到灰色的背景图
    [window addSubview:backView];
    _backView = backView;
    // 添加评论视图
    CommentView * commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, Margin242 * IPHONE6_H_SCALE)];
    commentView.delegate = self;
    
    if (_reply) {   // 如果点击了回复
        commentView.placeholder = [NSString stringWithFormat:@"回复%@:", _replyName];
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    commentView.userInteractionEnabled = YES;
    [commentView addGestureRecognizer:tap];
    commentView.backgroundColor = Color239;
    [window addSubview:commentView];
    _commentView = commentView;
    
    UITapGestureRecognizer * backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperviewAction)];
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:backTap];
    
    [_commentView.textView becomeFirstResponder];
}

- (void)tapAction{
    
}
#pragma mark --- 灰色背景移出,评论视图移除
- (void)removeFromSuperviewAction
{
    // 灰色背景移除
    [_backView removeFromSuperview];
    // 移除评论视图
    [_commentView removeFromSuperview];
    //    [_commentView.textView resignFirstResponder];
}

#pragma mark --- CommentViewDelegate
// 发表按钮的点击事件
- (void)commnetView:(CommentView *)commentView sendMessage:(NSString *)message
{
    if (_reply) {// 进行回复
        //
        _reply = nil;
        NSLog(@"进行回复...");
        [self sendMessageWithTypes:_replyID andID:_replyID];
    } else{
        // 对文章进行评论
        [self sendMessageWithTypes:@"0" andID:self.iD];
    }
   
    
}
#pragma mark --- 进行评论或回复
- (void)sendMessageWithTypes:(NSString *)types  andID:(NSString * )ID{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    if (cookieName || wxData) {
        NSLog(@"已经登录。。。进行发表");
        NSMutableDictionary * CommentDic = [NSMutableDictionary dictionary];
        NSLog(@"types和ID%@---%@", types, ID);
        CommentDic[@"id"] = self.iD;
        CommentDic[@"types"] = types;//0:评论 1:回复
        CommentDic[@"type"] = self.type;
        CommentDic[@"content"] = _commentView.textView.text;
        [DataTool postWithStr:SendComment parameters:CommentDic success:^(id responseObject) {
            
            NSLog(@"发表评论返回的数据---%@", responseObject);
            NSString * content = [responseObject objectForKey:@"content"];
            NSLog(@"－－content--%@", content);
        } failure:^(NSError * error) {
            
            NSLog(@"发表评论的错误信息%@", error);
            
        }];
        // 移除评论视图
        [self removeFromSuperviewAction];
        
        // 显示发表成功
        [SVProgressHUD showSuccessWithStatus:@"发表成功"];
        // 再刷新一次
        [self.tableView.header beginRefreshing];
       
    }else{
        [self addAlertView];
    }
}

#pragma mark --- 添加登录的alertView
- (void)addAlertView{
    LSAlertView * alertView = [[LSAlertView alloc] init];
    alertView.delegate = self;
    CGFloat x = Margin105 * IPHONE6_W_SCALE;
    CGFloat y = Margin574 * IPHONE6_H_SCALE;
    CGFloat w = Margin540 * IPHONE6_W_SCALE;
    CGFloat h = Margin208 * IPHONE6_H_SCALE;
    alertView.frame = CGRectMake(x, y, w, h);
    UIView * alertBackView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    alertBackView.backgroundColor = ColorBlack30;
    // 当前顶层窗口
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 添加到灰色的背景图
    [window addSubview:alertBackView];
    [window addSubview:alertView];
    _alertBackView = alertBackView;
    _alertView = alertView;
}

#pragma mark --- LSAlertViewDeleagte
// 取消
- (void)lsAlertView:(LSAlertView *)alertView cancel:(NSString * )cancel{
    [self removeAlerView];
}

- (void)removeAlerView
{
    // 移除提示框的背景图
    [_alertBackView removeFromSuperview];
    // 移除提示框
    [_alertView removeFromSuperview];
}
// 确定
- (void)lsAlertView:(LSAlertView *)alertView sure:(NSString *)sure{
    // 移除提示框
    [self removeAlerView];
    // 移除评论框
    [self removeFromSuperviewAction];
    // 将发表的内容进行保存
    _sendContent = _commentView.textView.text;
    
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNav animated:YES completion:nil];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsTableViewCell * cell = [CommentsTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    CommentsFrame * commentsFrameModel = self.dataSource[indexPath.row];
    cell.commentsFrame = commentsFrameModel;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%lu", indexPath.row);
}

#pragma mark --- CommentsTableViewCellDelegate
#pragma mark --- 点击单元格中的评论或回复视图
- (void)tableViewCell:(CommentsTableViewCell *)cell didClickedContentWithID:(NSString *)ID andModel:(CommentsModel *)model{
    
    _model = model;
    
    [DataTool getSBDataWithStr:_model.wapurl parameters:nil success:^(id responseObject) {
        
        SBModel * sbModel = [[SBModel alloc] init];
        sbModel = responseObject;
        _sbModel = sbModel;
    } failure:^(NSError * error) {
        NSLog(@"获取个人数据出错：%@", error);
    }];
    
    if (_replyView) {   // 如果有回复视图
        [_replyView removeFromSuperview];
    }
    
    _replyID = ID;
    UIImageView * replyView = [[UIImageView alloc] init];
    CGFloat replyViewX = (128+130)/2 * IPHONE6_W_SCALE;
    CGFloat replyViewY = 50 / 2 * IPHONE6_H_SCALE;
    CGFloat replyViewW = 301 / 2 * IPHONE6_W_SCALE;
    CGFloat replyViewH = 74 / 2 * IPHONE6_H_SCALE;
    replyView.frame = CGRectMake(replyViewX, replyViewY, replyViewW, replyViewH);
    replyView.image = [UIImage imageNamed:@"anniu_beijing"];
    [cell addSubview:replyView];
    // 图片要能与用户交互
    replyView.userInteractionEnabled = YES;
    _replyView = replyView;
    
    // 回复按钮
    UIButton * replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat replyBtnX = 0;
    CGFloat replyBtnY = 0;
    CGFloat replyBtnW = replyViewW / 2;
    CGFloat replyBtnH = replyViewH;
    replyBtn.frame = CGRectMake(replyBtnX, replyBtnY, replyBtnW, replyBtnH);
    replyBtn.backgroundColor = [UIColor clearColor];
    [replyBtn addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    [replyView addSubview:replyBtn];
    
    // 查看主页按钮
    UIButton * checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat checkBtnX = CGRectGetMaxX(replyBtn.frame);
    CGFloat checkBtnY = 0;
    CGFloat checkBtnW = replyBtnW;
    CGFloat checkBtnH = replyBtnH;
    checkBtn.frame = CGRectMake(checkBtnX, checkBtnY, checkBtnW, checkBtnH);
    [checkBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    [replyView addSubview:checkBtn];
    
    _reply = @"yes";
    
    _replyName = model.username;
}
#pragma mark --- 点击单元格中的用户头像
- (void)tableViewCell:(CommentsTableViewCell *)cell dicClickFaceWithModel:(CommentsModel *)model{
    NSLog(@"点击用户头像");
}

//- (void)tableViewCell:(CommentsTableViewCell *)cell didClickedContentWithID:(NSString *)ID{
//    
//}
#pragma mark ---- 回复事件
- (void)replyAction{
    NSLog(@"回复....");
    [_replyView removeFromSuperview];
    [self commentAction];
    // 对某个评论进行回复
//    [self sendMessageWithTypes:@"1" andID:_replyID];
}
#pragma mark --- 查看用户主页
- (void)checkAction{
    NSLog(@"查看用户主页 ...");
    [_replyView removeFromSuperview];
    AnyBodyVC * anyBodyVC = [[AnyBodyVC alloc] init];
    StarVC * starVC = [[StarVC alloc] init];
    
    if ([_sbModel.data[@"certified"] isKindOfClass:[NSNull class]]) {   // 如果认证为空，就是普通人主页
        anyBodyVC.userURL = _model.wapurl;
        [self.navigationController pushViewController:anyBodyVC animated:YES];
    }else{
        starVC.userURL = _model.wapurl;
        [self.navigationController pushViewController:starVC animated:YES];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 回复视图移除
    [_replyView removeFromSuperview];
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsFrame * commentsFrameModel = self.dataSource[indexPath.row];
    
    return commentsFrameModel.cellHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
