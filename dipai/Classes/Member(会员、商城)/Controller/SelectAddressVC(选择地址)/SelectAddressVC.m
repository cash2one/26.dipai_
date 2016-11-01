//
//  SelectAddressVC.m
//  dipai
//
//  Created by 梁森 on 16/10/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "SelectAddressVC.h"

// 地址单元格
#import "AddressCell.h"

// 添加收货地址
#import "AddAddressVC.h"
// 地址模型
#import "AddressModel.h"

#import "Masonry.h"
#import "DataTool.h"
#import "SVProgressHUD.h"
@interface SelectAddressVC ()<UITableViewDelegate, UITableViewDataSource>

{
    NSInteger _cellTag; //
}


// 表格
@property (nonatomic, strong) UITableView * tableView;
// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) NSMutableArray * cellArr;

@end

@implementation SelectAddressVC

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)cellArr{
    
    if (_cellArr == nil) {
        _cellArr = [NSMutableArray array];
    }
    return _cellArr;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    // 页面每次出现的时候都要重新加载数据，因为可能增加新的地址
    [self getData];
}

- (void)getData{
    
    [DataTool getAllAddressDataWithStr:AddressListURL parameters:nil success:^(id responseObject) {
        
        self.dataSource = responseObject;
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        NSLog(@"获取数据错误信息：%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(240, 238, 245, 1);
    [self setNavigationBar];
    
    _cellTag = -1;
}

- (void)setNavigationBar{
    
    self.naviBar.titleLbl.hidden = YES;
    self.naviBar.popV.hidden = NO;
    [self.naviBar.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLbl = [[UILabel alloc] init];
    [self.view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@(44));
        make.width.equalTo(@(160 * IPHONE6_W_SCALE));
    }];
    titleLbl.text = @"选择收货地址";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment =  NSTextAlignmentCenter;
    
    [self addTableView];
    
    
   // 新增地址
    UIView * bottomV = [[UIView alloc] init];
    bottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(53 * IPHONE6_H_SCALE));
    }];
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color216;
    [bottomV addSubview:line];
    line.frame = CGRectMake(0, 0, WIDTH, 0.5);
    
    UILabel * addLbl = [[UILabel alloc] init];
    addLbl.font = Font15;
    addLbl.text = @"新增地址";
    addLbl.textAlignment = NSTextAlignmentRight;
    addLbl.textColor = [UIColor redColor];
    [bottomV addSubview:addLbl];
    [addLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomV.mas_centerY);
        make.right.equalTo(bottomV.mas_right).offset(-285 * IPHONE6_W_SCALE * 0.5);
        make.width.equalTo(@(WIDTH - 285 * 0.5 * IPHONE6_W_SCALE));
        make.height.equalTo(@(53 * IPHONE6_H_SCALE));
    }];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"xinzengdizhi"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomV.mas_centerY);
        make.left.equalTo(bottomV.mas_left).offset(252 * 0.5 * IPHONE6_W_SCALE);
        make.width.equalTo(@(53 * IPHONE6_W_SCALE));
        make.height.equalTo(@(53 * IPHONE6_W_SCALE));
    }];
}

- (void) addTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 53 * IPHONE6_H_SCALE-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBA(240, 238, 245, 1);
    [self.view addSubview:self.tableView];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressCell * cell =  [AddressCell cellWithTableView:tableView];
    cell.addressModel = [self.dataSource objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    if (_cellTag >= 0) {    // 如果重选了默认地址
        if (cell.tag == _cellTag) {
            cell.flagV.hidden = NO;
        }else{
            cell.flagV.hidden = YES;
        }
    }
   
    [self.cellArr addObject:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressModel * model = [self.dataSource objectAtIndex:indexPath.row];
    NSString * addressStr = [NSString stringWithFormat:@"%@%@", model.district, model.address];
   CGSize titleSize = [addressStr sizeWithFont:Font13 constrainedToSize:CGSizeMake(WIDTH - 65 * IPHONE6_W_SCALE, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat h = titleSize.height;
    return 63 * IPHONE6_H_SCALE + h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (AddressCell * cell in self.cellArr) {
        cell.flagV.hidden = YES;
    }
    
    AddressCell * cell  =  [tableView cellForRowAtIndexPath:indexPath];
    cell.flagV.hidden = NO;
    
    NSLog(@"didTag--->%lu", cell.tag);
    
    _cellTag = cell.tag;
    AddressModel * model = [self.dataSource objectAtIndex:indexPath.row];
    // 选择默认地址
    NSString * url = [AddDefaAddressURL stringByAppendingString:[NSString stringWithFormat:@"/%@", model.address_id]];
    [DataTool addDefaultAddWithStr:url parameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"msg"] isEqualToString:@"success"]) {
            NSLog(@"选择默认地址成功..");
//             [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * error) {
       
        NSLog(@"选择默认地址出错：%@", error);
    }];
    // 返回
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressCell * cell  =  [tableView cellForRowAtIndexPath:indexPath];
    cell.flagV.hidden = YES;
}


// 添加收货地址
- (void)addAddressAction{
    
    AddAddressVC * addAddressVC = [[AddAddressVC alloc] init];
    [self presentViewController:addAddressVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
