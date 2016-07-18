//
//  ClubInformationVC.m
//  dipai
//
//  Created by 梁森 on 16/6/15.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ClubInformationVC.h"

// 自定义单元格
#import "CellInClubInfo.h"
// 表格的脚视图
#import "TableFooterView.h"
// 俱乐部信息页模型
#import "InfoModel.h"

// 提示打电话视图
#import "CallView.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"

#import "DataTool.h"
@interface ClubInformationVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataArr;
/**
 *  tableView的headerView
 */
@property (nonatomic, strong) UIImageView * headerView;
/**
 *  表格的脚视图
 */
@property (nonatomic, strong) TableFooterView * footerView;
/**
 *  黑色背景图
 */
@property (nonatomic, strong) UIView * blackView;

/**
 *  提示打电话视图
 */
@property (nonatomic, strong) CallView * callView;
/**
 *  信息页模型
 */
@property (nonatomic, strong) InfoModel * infoModel;

@end

@implementation ClubInformationVC

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    // 利用block将其它三个页面的接口传递过去
//    NSString * recommendURL = _infoModel.rcd;   // 推荐接口
//    NSString * newsURL = _infoModel.relation;   // 新闻接口
//    NSString * commentsURL = _infoModel.comment;    // 评论接口
//    NSArray * URLArr = @[recommendURL, newsURL, commentsURL];
//    if ([self.delegate respondsToSelector:@selector(sendURLWhenDisappearWithArr:andID:)]) {
//        [self.delegate sendURLWhenDisappearWithArr:URLArr andID:_infoModel.iD];
//    } else{
//        NSLog(@"ClubInfomationVC的代理没有响应...");
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 搭建UI
    [self createUI];
    
    // 获取数据
    [self getData];
}
#pragma mark --- 搭建UI
- (void)createUI{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // 添加表格的头视图
    [self addTableViewHeaderView];
    // 添加表格的脚视图
    [self addTableViewFooterView];
    
}
#pragma mark --- addTableViewHeaderView
- (void)addTableViewHeaderView{
    UIImageView * headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 330*0.5*IPHONE6_H_SCALE)];
    headerView.userInteractionEnabled = YES;
    UILabel * picLbl = [[UILabel alloc] init];
    picLbl.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.7];
    picLbl.text = @"俱乐部图集";
    picLbl.textColor = [UIColor whiteColor];
    picLbl.font = Font11;
    picLbl.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:picLbl];
    [picLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-Margin40 * IPHONE6_W_SCALE);
        make.bottom.equalTo(headerView.mas_bottom).offset(-18*0.5*IPHONE6_H_SCALE);
        make.width.equalTo(@(146*0.5*IPHONE6_W_SCALE));
        make.height.equalTo(@(54*0.5*IPHONE6_H_SCALE));
    }];
    _headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [headerView addSubview:btn];
//    btn.userInteractionEnabled = YES;
    btn.frame = headerView.bounds;
    [btn addTarget:self action:@selector(showMorePics) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark --- 进入图集的点击事件
- (void)showMorePics{
    if ([self.delegate respondsToSelector:@selector(showMorePicsWithImages:)]) {
        [self.delegate showMorePicsWithImages:_infoModel.imgs];
    } else{
        NSLog(@"ClubInformationVC的代理没有响应...");
    }
}
#pragma mark --- addTableViewFooterView
// 添加表格的脚视图
- (void)addTableViewFooterView{
    // 高度是34 ＋ 54*3 ＋ 28*3（最多有九个标签）
    TableFooterView * footerView = [[TableFooterView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 140 * IPHONE6_H_SCALE)];
//    footerView.tagArr = _infoModel.tags;
    self.tableView.tableFooterView = footerView;
    _footerView = footerView;
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArr.count;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellInClubInfo * cell = [CellInClubInfo cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.picView.image = [UIImage imageNamed:@"dizhi"];
        
//        NSLog(@"%@", _infoModel.address);
        cell.contentLbl.text = _infoModel.address;
    }
    if (indexPath.row == 1) {
        cell.picView.image = [UIImage imageNamed:@"dianhua"];
        
//        NSLog(@"%@", _infoModel.telephone);
        cell.contentLbl.text = _infoModel.telephone;
    }
    if (indexPath.row == 2) {
        cell.picView.image = [UIImage imageNamed:@"yingyeshijian"];
        
//        NSLog(@"%@", _infoModel.business_hours);
        cell.contentLbl.text = _infoModel.business_hours;
    }
    if (indexPath.row == 2) {
        cell.accessView.hidden = YES;
    }
    return cell;
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58.5 * IPHONE6_H_SCALE;
}
#pragma mark --- 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [self callAction];
    }
}

#pragma mark --- 打电话事件
- (void)callAction{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_infoModel.telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark --- 取消打电话
- (void)cancelAction{
    _blackView.hidden = YES;
    _callView.hidden = YES;
}

#pragma mark --- 获取数据
- (void)getData{
    
    NSString * url= self.wapurl;
    if (url) {
        [DataTool getClubInfoWithStr:url parameters:nil success:^(id responseObject) {
            
//            NSLog(@"俱乐部信息页面获取数据：－－－%@",responseObject);
            InfoModel * infoModel = responseObject;
            _infoModel = infoModel;
            
//            NSLog(@"%@", _infoModel.address);
            // 设置数据
            [self setData];
            
            [self.tableView reloadData];
        } failure:^(NSError * error) {
            
            NSLog(@"获取俱乐部信息页面数据出错：%@", error);
        }];
    } else{
        NSLog(@"接口为空...");
    }
    
}

#pragma mark --- 设置数据
- (void)setData{
    // 表格头视图
    [_headerView sd_setImageWithURL:[NSURL URLWithString:_infoModel.picname] placeholderImage:[UIImage imageNamed:@"123"]];
    
    NSLog(@"%@", _infoModel.tags);
    
    _footerView.tagArr = _infoModel.tags;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
