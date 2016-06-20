//
//  AlbumViewController.m
//  dipai
//
//  Created by 梁森 on 16/6/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AlbumViewController.h"
// 视频列表中的单元格
#import "AlbumTableViewCell.h"
// 视频列表中模型
#import "AlbumModel.h"
@interface AlbumViewController ()
{
    NSInteger _index;
}

@property (nonatomic, strong) AlbumTableViewCell * cell;
@end

@implementation AlbumViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //  没有分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _index = -1;
//    self.tableView.backgroundColor = [UIColor colorWithRed:27 / 255.0 green:27 / 255.0 blue:27 / 255.0 alpha:1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"数据源的个数%lu", self.dataSource.count);
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumTableViewCell * cell = [AlbumTableViewCell cellWithTableView:tableView];
    
    if (indexPath.row == _index) {
            cell.titleLbl.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
            cell.backgroundColor = [UIColor colorWithRed:45 / 255.0 green:45 / 255.0 blue:45 / 255.0 alpha:1];
        } else{
            cell.titleLbl.textColor = Color123;
            cell.backgroundColor = [UIColor colorWithRed:27 / 255.0 green:27 / 255.0 blue:27 / 255.0 alpha:1];
        }

    
    cell.albumModel = self.dataSource[indexPath.row];
    return cell;
}

// 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 获取点击的单元格
    AlbumTableViewCell * cell = (AlbumTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
//    _cell.titleLbl.textColor = Color123;
//    _cell.backgroundColor = [UIColor colorWithRed:27 / 255.0 green:27 / 255.0 blue:27 / 255.0 alpha:1];
    
    // 改变文字颜色
    cell.titleLbl.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
//    // 改变背景颜色
    cell.backgroundColor = [UIColor colorWithRed:45 / 255.0 green:45 / 255.0 blue:45 / 255.0 alpha:1];
    
    // 记录点击的单元格行数
    _index = indexPath.row;
    
    
    AlbumModel * albumModel = self.dataSource[indexPath.row];
    // 将视频播放地址传递给代理
    if ([self.delegate respondsToSelector:@selector(sendVideoUrl:andIndex:andVideoID:andURL:andAblumModel:)]) {
        NSInteger videoIndex = indexPath.row;
        [self.delegate sendVideoUrl:albumModel.videourl andIndex:videoIndex andVideoID:albumModel.iD andURL:albumModel.video_url andAblumModel:albumModel];
    } else{
        NSLog(@"AlbumViewController的代理没有响应...");
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumTableViewCell * cell = (AlbumTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    // 改变文字颜色
    cell.titleLbl.textColor = Color123;
//    // 改变背景颜色
    cell.backgroundColor = [UIColor colorWithRed:27 / 255.0 green:27 / 255.0 blue:27 / 255.0 alpha:1];
}
#pragma mark --- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170 / 2 * IPHONE6_H_SCALE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
