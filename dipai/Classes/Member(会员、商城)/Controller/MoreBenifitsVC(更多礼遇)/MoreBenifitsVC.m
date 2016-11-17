//
//  MoreBenifitsVC.m
//  dipai
//
//  Created by 梁森 on 16/10/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MoreBenifitsVC.h"

// 礼遇详情
#import "BenifitsDetailVC.h"
// 会员礼遇单元格
#import "MemberBenefitCell.h"

// 视图模型
#import "MemberBeneCellModel.h"


#import "DataTool.h"
@interface MoreBenifitsVC ()<UITableViewDelegate, UITableViewDataSource, MemberBenefitCellDelegate>

@property (nonatomic, strong) UITableView * tableView;
// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) NSDictionary * dataDic;
// 视图模型数组
@property (nonatomic, strong) NSMutableArray * vMArr;
@end

@implementation MoreBenifitsVC
- (NSMutableArray *)vMArr{
    
    if (_vMArr == nil) {
        _vMArr = [NSMutableArray array];
    }
    return _vMArr;
}

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSDictionary *)dataDic{
    
    if (_dataDic == nil) {
        _dataDic = [NSDictionary dictionary];
    }
    return _dataDic;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
}

- (void)getData{
    
    [DataTool getAllBenefitsDataWithStr:BenifitsList parameters:nil success:^(id responseObject) {
        
        self.dataDic = responseObject;
        
        if (self.vMArr.count > 0) {
            // 如果再次进入此页面重复的数据不再加入
            [self.vMArr removeAllObjects];
        }
        
        for (int i = 0; i < self.dataDic.count; i ++) {
            NSString * Vx = [NSString stringWithFormat:@"V%d", i];
            NSArray * VArr = [self.dataDic objectForKey:Vx];
            MemberBeneCellModel  * model = [[MemberBeneCellModel alloc] init];
            model.benefitsArr = VArr;
            [self.vMArr addObject:model];
        }
        NSLog(@"%@", self.vMArr);
        
        MemberBeneCellModel * model = [self.vMArr objectAtIndex:0];
        NSLog(@"%f", model.cellHeight);
        
        [self.tableView reloadData];
    } failure:^(NSError * error) {
       
        NSLog(@"^=%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    
    [self addTableView];
    
    [self getData];
}

- (void)setNavigationBar{
    
    self.naviBar.titleStr = @"全部礼遇";
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.vMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MemberBenefitCell * cell = [MemberBenefitCell cellWithTableView:tableView];
    MemberBeneCellModel * model = [self.vMArr objectAtIndex:indexPath.row];
    cell.levelArr = model.benefitsArr;
    cell.level = [NSString stringWithFormat:@"%lu", indexPath.row];
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 跳转到礼遇详情
//    BenifitsDetailVC * benifitsDetailVC = [[BenifitsDetailVC alloc] init];
//    [self.navigationController pushViewController:benifitsDetailVC animated:YES];
}

- (void)MemberBenefitCell:(UITableViewCell *)cell didClickWithTag:(NSInteger)tag{
    
//    NSLog(@"%lu", cell.tag);
    
    // 跳转到礼遇详情
    BenifitsDetailVC * benifitsDetailVC = [[BenifitsDetailVC alloc] init];
    MemberBeneCellModel * model = [self.vMArr objectAtIndex:cell.tag];
    NSDictionary * dic = [model.benefitsArr objectAtIndex:tag];
    NSString * url = dic[@"wapurl"];
    benifitsDetailVC.wapurl = url;
     [self.navigationController pushViewController:benifitsDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MemberBeneCellModel * model = [self.vMArr objectAtIndex:indexPath.row];
    
    return model.cellHeight + 82*IPHONE6_H_SCALE;
    // 先算单元格的高度再创建单元格
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
