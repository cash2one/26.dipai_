//
//  LNPhotoLibaryController.m
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/15.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "LNPhotoLibaryController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LNPhotoBrowserController.h"
#import "UIView+LNView.h"
#import "UIImageView+LNTouch.h"
#import "LNPhotoCell.h"
#import "LNPhotoAsset.h"
#import "LNPhotoView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LNPhotoLibaryController ()<UITableViewDataSource,UITableViewDelegate,LNPhotoBrowserDataSource,LNPhotoBrowserDelegate>

@property (nonatomic, readwrite, strong) UIBarButtonItem *leftBarButton;

@property (nonatomic, readwrite, strong) UITabBar *tabBar;

@property (nonatomic, readwrite, strong) NSMutableArray *photos;

//@property (nonatomic, readwrite, copy) NSMutableArray *selectedPhotos;

@property (nonatomic, strong) UIButton *broswerButton;

@property (nonatomic, strong) UIButton *completionButton;

@property (nonatomic, strong) UIView *badgeView;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) UITableView *tableView;

@end

static CGFloat IMAGE_WIDTH;

@implementation LNPhotoLibaryController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = self.leftBarButton;
    
    self.navigationItem.title = @"相册";
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tabBar];
    [self.tabBar addSubview:self.broswerButton];
    [self.tabBar addSubview:self.completionButton];
    [self.tabBar addSubview:self.badgeView];
    
    IMAGE_WIDTH = floor(((SCREEN_WIDTH - (LNPhotoVerticalSpace * 5)) / LNPhotoColumns));
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.badgeView.badgeValue = @"0";
    [self allPhotos];
}

- (void)viewWillAppear:(BOOL)animated{
    [self setUpDefault];
    self.badgeView.badgeValue = [NSString stringWithFormat:@"%ld",[self.selectedPhotos count]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ceil([self.photos count] / 4);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Cell";
    LNPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[LNPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row * LNPhotoColumns, LNPhotoColumns)];
    NSArray *array = [self.photos objectsAtIndexes:indexSet];
    for (int i = 0; i < [array count]; i++) {
        LNPhotoAsset *photoAsset = array[i];
        UIImageView *imageView = [[LNPhotoView alloc] initWithFrame:CGRectMake((i + 1) * LNPhotoVerticalSpace + i * IMAGE_WIDTH, LNPhotoHorizontalSpace, IMAGE_WIDTH, cell.frame.size.height - LNPhotoHorizontalSpace)];
        imageView.image = photoAsset.thumbImage;
        imageView.tag = i + LNPhotoColumns * indexPath.row;
        imageView.tap = [LNTouchTap tapWithTapBlock:^(UIImageView *sender) {
            LNPhotoBrowserController *photoBrowser = [[LNPhotoBrowserController alloc] init];
            photoBrowser.delegate = self;
            photoBrowser.dataSource = self;
            photoBrowser.selectedIndex = sender.tag;
            photoBrowser.selectedPhotos = [self.selectedPhotos mutableCopy];
            [self.navigationController pushViewController:photoBrowser animated:YES];
        }];
        [self setCheckedImageView:imageView index:imageView.tag];
        [cell addSubview:imageView];
    }
}

#pragma mark - LNPhotoBroswer Delegate
- (NSArray*)numberOfPhotosInPhotoBrowser:(LNPhotoBrowserController *)photoBrowser{
    return self.photos;
}

- (void)photoBrowser:(LNPhotoBrowserController *)photoBrowser deSelectedPhotoAsset:(LNPhotoAsset *)photoAsset{
    [self.selectedPhotos removeObject:photoAsset];
}

- (void)photoBrowser:(LNPhotoBrowserController *)photoBrowser didSelectedPhotoAsset:(LNPhotoAsset *)photoAsset{
    [self.selectedPhotos addObject:photoAsset];
}

- (BOOL)photoBrowser:(LNPhotoBrowserController *)photoBrowser shouldSelectPhotoAssets:(NSInteger)count{
    if (count < self.maxSelectedCount) {
        return YES;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"最多选择%ld张照片",self.maxSelectedCount] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
}


#pragma mark - Event Response
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  获取本地照片
 */
- (void)allPhotos{
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (!group) {
            
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (!result) {
                        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                    }else{
                        [self.photos addObject:[[LNPhotoAsset alloc] initWithAsset:result]];
                    }
                }];
            });
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

/**
 *  默认设置
 */
- (void)setUpDefault{
    if (!self.maxSelectedCount) {
        self.maxSelectedCount = 4;
    }
    [self refreshButtonStatus];
}

/**
 *  刷新按钮状态（可用或不可用）
 */
- (void)refreshButtonStatus{
    self.broswerButton.enabled = [self.selectedPhotos count];
    self.broswerButton.alpha = [self.selectedPhotos count] + 0.5;
    self.completionButton.enabled = [self.selectedPhotos count];
    self.completionButton.alpha = [self.selectedPhotos count] + 0.5;
}

/**
 *  完成
 *
 *  @param sender
 */
- (void)completionAction:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:IMAGE_PICKER object:self.selectedPhotos];
    [self dismiss];
}

/**
 *  图片浏览
 *
 *  @param sender
 */
- (void)broswerAction:(id)sender{
    LNPhotoBrowserController *photoBrowserController = [[LNPhotoBrowserController alloc] init];
//    photoBrowserController.dataSource = self;
    photoBrowserController.delegate = self;
    photoBrowserController.selectedPhotos = self.selectedPhotos;
    [self.navigationController pushViewController:photoBrowserController animated:YES];
}

/**
 *  初始化选择标志
 *
 *  @param imageView
 *  @param index     
 */
- (void)setCheckedImageView:(UIImageView*)imageView index:(NSInteger)index{
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(2*IMAGE_WIDTH / 3, 2, IMAGE_WIDTH / 3, IMAGE_WIDTH / 3)];
    if ([self.selectedPhotos containsObject:self.photos[index]]) {
        selectView.image = [UIImage imageNamed:@"image_selected"];
    }else{
        selectView.image = [UIImage imageNamed:@"image_unselect"];
    }
    selectView.tag = index;
    selectView.tap = [LNTouchTap tapWithTapBlock:^(UIImageView *sender) {
        if (![self.selectedPhotos containsObject:[self.photos objectAtIndex:sender.tag]]) {
            if ([self.selectedPhotos count] < self.maxSelectedCount) {
                sender.image = [UIImage imageNamed:@"image_selected"];
                [self.selectedPhotos addObject:[self.photos objectAtIndex:sender.tag]];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"最多选择%ld张照片",self.maxSelectedCount] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alertView show];
            }
        }else{
            sender.image = [UIImage imageNamed:@"image_unselect"];
            [self.selectedPhotos removeObject:[self.photos objectAtIndex:sender.tag]];
        }
        self.badgeView.badgeValue = [NSString stringWithFormat:@"%ld",[self.selectedPhotos count]];
        [self refreshButtonStatus];
    }];
    [imageView addSubview:selectView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Getter and Setter
- (UIBarButtonItem*)leftBarButton{
    if (_leftBarButton == nil) {
        _leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
    return _leftBarButton;
}

- (NSMutableArray*)photos{
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableArray*)selectedPhotos{
    if (_selectedPhotos == nil) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

- (ALAssetsLibrary*)assetsLibrary{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (UITableView*)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor = [UIColor lightGrayColor];
    }
    return _tableView;
}

- (UIView*)tabBar{
    if (_tabBar == nil) {
        _tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    }
    return _tabBar;
}

- (UIButton*)broswerButton{
    if (_broswerButton == nil) {
        _broswerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _broswerButton.frame = CGRectMake(0, 0, 60, 44);
        [_broswerButton setTitle:@"浏览" forState:UIControlStateNormal];
        [_broswerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_broswerButton addTarget:self action:@selector(broswerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _broswerButton;
}

- (UIButton*)completionButton{
    if (_completionButton == nil) {
        _completionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _completionButton.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 44);
        [_completionButton setTitle:@"完成" forState:UIControlStateNormal];
        [_completionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_completionButton addTarget:self action:@selector(completionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completionButton;
}

- (UIView*)badgeView{
    if (_badgeView == nil) {
        _badgeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 20, 12, 20, 20)];
//        _badgeView.backgroundColor = UIColorFromRGBA(67, 212, 144, 1.0);
        _badgeView.backgroundColor = UIColorFromRGBA(288, 0, 0, 1.0);
        _badgeView.layer.cornerRadius = 10.0f;
    }
    return _badgeView;
}

@end
