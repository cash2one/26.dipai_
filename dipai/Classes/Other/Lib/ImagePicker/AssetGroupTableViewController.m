//
//  AssetGroupTableViewController.m
//  WYZ_ImgPickerc
//
//  Created by 王宇宙 on 16/7/13.
//  Copyright © 2016年 王宇宙. All rights reserved.
//

#import "AssetGroupTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetGroupTableViewCell.h"
#import "ImgSelectCollectionViewController.h"


@interface AssetGroupTableViewController ()

@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic,strong) NSMutableArray *groups;

@end

@implementation AssetGroupTableViewController
- (ALAssetsLibrary *)assetsLibrary{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}
- (NSMutableArray *)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if(group){
                    // group：分组的相册
                    if ([group numberOfAssets]>0){
                     [_groups addObject:group];
                    }
                    NSLog(@"%@", _groups);
                    [self.tableView reloadData];
                }
            } failureBlock:^(NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"访问相册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }];
        });
    }
    return _groups;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回相册";
    self.navigationItem.backBarButtonItem = backItem;
}


#pragma mark - -----------------代理方法-----------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"分组个数%lu", self.groups.count);
    return self.groups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 自定义的单元格
    AssetGroupTableViewCell *cell = [AssetGroupTableViewCell groupCell:tableView];
    ALAssetsGroup *group = self.groups[indexPath.row];
    NSLog(@"ALAssetsGroup:%@", group);
    cell.group = group;
    return cell;
}
// 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}
// 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 选择图片页面是一个UICollectionView
    ImgSelectCollectionViewController *collectionVC = [[ImgSelectCollectionViewController alloc] init];
    
    NSLog(@"已选图片数%lu", self.selectedPics);
    
    collectionVC.selectedPics = self.selectedPics;
    collectionVC.group = self.groups[indexPath.row];
    [self.navigationController pushViewController:collectionVC animated:YES];
}


@end
