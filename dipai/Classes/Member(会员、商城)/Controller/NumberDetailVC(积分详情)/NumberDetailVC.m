//
//  NumberDetailVC.m
//  dipai
//
//  Created by 梁森 on 16/10/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "NumberDetailVC.h"
#import "Masonry.h"
#import "DataTool.h"
#import "MJChiBaoZiFooter2.h"

//  积分详情模型
#import "NumberDetailModel.h"
// 积分详情单元格
#import "NumberDetailCell.h"
@interface NumberDetailVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString * _page;   // 加载发送参数
}
// 当前可用积分数
@property (nonatomic, strong) UILabel * currentNumLbl ;
// 表格
@property (nonatomic, strong) UITableView * tableView;
// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation NumberDetailVC

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    
    [self setUpUI];
    
    [self getData];
}

- (void)getData{
    
    [DataTool getDetailNumberDataWithStr:NumberDtailURL parameters:nil success:^(id responseObject) {
        NSMutableArray * arr = responseObject;
        self.dataSource = [arr objectAtIndex:0];
        _page = [arr objectAtIndex:1];
        
         [self setData];
        [self.tableView reloadData];
    } failure:^(NSError * error) {
       
        NSLog(@"获取数据出错：%@", error);
    }];
}

- (void)setData{
    
    _currentNumLbl.text = self. count_integral;
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"积分详情";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpUI{
    
    UIView * topV = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 73 * IPHONE6_H_SCALE + 0.5)];
    topV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topV];
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.text = @"当前可用积分";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = Font12;
    [topV addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topV.mas_centerX);
        make.top.equalTo(topV.mas_top).offset(14 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH));
        make.height.equalTo(@(12 * IPHONE6_W_SCALE));
    }];

    // 当前可用积分数
    UILabel * currentNumLbl = [[UILabel alloc] init];
    currentNumLbl.textColor = [UIColor redColor];
    currentNumLbl.textAlignment = NSTextAlignmentCenter;
    currentNumLbl.font = [UIFont fontWithName:@"Helvetica" size:24 * IPHONE6_W_SCALE];
    [topV addSubview:currentNumLbl];
    [currentNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topV.mas_centerX);
        make.top.equalTo(titleLbl.mas_bottom).offset(12 * IPHONE6_H_SCALE);
        make.height.equalTo(@(24 * IPHONE6_W_SCALE));
        make.width.equalTo(@(WIDTH));
    }];
    currentNumLbl.text = @"";
    _currentNumLbl = currentNumLbl;

    UIView * lineV = [[UIView alloc] init];
    lineV.backgroundColor = Color216;
    [topV addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topV.mas_left);
        make.right.equalTo(topV.mas_right);
        make.bottom.equalTo(topV.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
//
    UIView * middleV = [[UIView alloc] init];
    middleV.backgroundColor = SeparateColor;
    [self.view addSubview:middleV];
    [middleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(topV.mas_bottom);
        make.height.equalTo(@(43 * IPHONE6_H_SCALE));
    }];
    // 积分明细标题
    UILabel * detailLbl = [[UILabel alloc] init];
    detailLbl.font = Font16;
    detailLbl.text = @"积分明细";
    [middleV addSubview:detailLbl];
    [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleV.mas_left).offset(15 * IPHONE6_W_SCALE);
        make.centerY.equalTo(middleV.mas_centerY);
        make.width.equalTo(@(WIDTH - 15 * IPHONE6_W_SCALE));
        make.height.equalTo(@(16 * IPHONE6_W_SCALE));
    }];
    
    [self addTableView];
}
- (void)addTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 232 * 0.5 * IPHONE6_H_SCALE + 0.5 + 64, WIDTH, HEIGHT -(232 * 0.5 * IPHONE6_H_SCALE + 0.5)-64 ) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = SeparateColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"加载更多消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.tableView.footer = footer;
}

- (void)loadMoreData{
    
    NSString * url = [NumberDtailURL stringByAppendingString:[NSString stringWithFormat:@"/%@", _page]];
    [DataTool getDetailNumberDataWithStr:url parameters:nil success:^(id responseObject) {
        
        [self.tableView.footer endRefreshing];
        if ([responseObject isKindOfClass:[NSString class]]) {  // 如果没有更多内容
//            [self.tableView.footer endRefreshing];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }else{
//            [self.tableView.footer endRefreshing];
            NSMutableArray * arr = responseObject;
            [self.dataSource addObjectsFromArray:arr[0]];
            _page = arr[1];
        }
//        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取数据出错：%@", error);
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NumberDetailCell * cell = [NumberDetailCell cellWithTableView:tableView];
    NumberDetailModel * model = [self.dataSource objectAtIndex:indexPath.row];
    cell.detailModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NumberDetailModel * model = [self.dataSource objectAtIndex:indexPath.row];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = Font12;
    CGRect detailRect = [model.content boundingRectWithSize:CGSizeMake(WIDTH - 90 * IPHONE6_W_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGFloat detailH = detailRect.size.height;
    return 55 * IPHONE6_H_SCALE + 0.5 + 47 * 0.5 * IPHONE6_H_SCALE + detailH + 7 * IPHONE6_H_SCALE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
