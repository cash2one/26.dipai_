//
//  ImgSelectCollectionViewController.m
//  WYZ_ImgPickerc
//
//  Created by 王宇宙 on 16/7/13.
//  Copyright © 2016年 王宇宙. All rights reserved.
//

#import "ImgSelectCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetModel.h"
#import "ImgPickerViewController.h"
#import "ImgPreviewCollectionView.h"

#import "SVProgressHUD.h"

#define MARGIN 10
#define COL 4
#define kWidth [UIScreen mainScreen].bounds.size.width

@interface ShowCell : UICollectionViewCell

@property (nonatomic,weak) UIButton *selectedButton;

@end

@implementation ShowCell

@end



@interface ImgSelectCollectionViewController ()

// 所有的相片
@property (nonatomic,strong) NSMutableArray *assetModels;
//选中的模型
@property (nonatomic,strong) NSMutableArray *selectedModels;
//选中的图片
@property (nonatomic,strong) NSMutableArray *selectedImages;

@end

@implementation ImgSelectCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

//设置类型
- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = MARGIN;
    flowLayout.minimumInteritemSpacing = MARGIN;
    CGFloat cellHeight = (kWidth - (COL + 1) * MARGIN) / COL;
    flowLayout.itemSize = CGSizeMake(cellHeight, cellHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    return [super initWithCollectionViewLayout:flowLayout];
}
- (NSMutableArray *)assetModels{
    if (_assetModels == nil) {
        _assetModels = [NSMutableArray array];
    }
    return _assetModels;
}
- (NSMutableArray *)selectedImages{
    if (_selectedImages == nil) {
        _selectedImages = [NSMutableArray array];
    }
    return _selectedImages;
}
- (NSMutableArray *)selectedModels{
    if (_selectedModels == nil) {
        _selectedModels = [NSMutableArray array];
    }
    return _selectedModels;
}
- (void)setGroup:(ALAssetsGroup *)group{
    _group = group;
    [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset == nil) return ;
        if (![[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {//不是图片
            return;
        }
        AssetModel *model = [[AssetModel alloc] init];
        model.thumbnail = [UIImage imageWithCGImage:asset.thumbnail];
        model.imgUrl = asset.defaultRepresentation.url;
        [self.assetModels addObject:model];
        
        
//        NSLog(@"----%lu", self.assetModels.count);
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[ShowCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //右侧完成按钮
    UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishSelecting)];
    self.navigationItem.rightBarButtonItem = finish;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//出口,选择完成图片
- (void)finishSelecting{
    
    if ([self.navigationController isKindOfClass:[ImgPickerViewController class]]) {
        ImgPickerViewController *picker = (ImgPickerViewController *)self.navigationController;
        
        [self.selectedModels removeAllObjects];
        
        if (picker.selectOriginals || picker.selectThumbnails) {
            
            for (AssetModel *model in self.assetModels) {
                if (model.isSelect) {   // 如果被选中了
                    
                    NSLog(@"添加选中图片...");
                    [self.selectedModels addObject:model];
                }
            }
            
            //获取原始图片可能是异步的,因此需要判断最后一个,然后传出
            [self.selectedImages removeAllObjects];
            
            
            // 放到主线程中
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (int i = 0; i < self.selectedModels.count; i++) {
                    AssetModel *model = self.selectedModels[i];
                    [model originalImg:^(UIImage *image) {
                        [self.selectedImages addObject:image];
                        
                        
                        if ( i == self.selectedModels.count - 1) {//最后一个
                        
                            NSLog(@"选中的图片数%lu", self.selectedImages.count);
                            NSLog(@"已选图片数：%lu", self.selectedPics);
                            if (self.selectedImages.count + self.selectedPics> 9) {
                                [SVProgressHUD showErrorWithStatus:@"最多上传九张图片"];
                            }else{
                                
                                if (picker.selectOriginals) {
                                    
                                    picker.selectOriginals(self.selectedImages);
                                }
                                //移除
                                [self dismissViewControllerAnimated:YES completion:nil];
                            }
                            
                            
                        }
                    }];
                    
                    
                //
                }
            });
            
            
            
            if (picker.selectThumbnails) {
                picker.selectThumbnails([_selectedModels valueForKeyPath:@"thumbnail"]);
                //移除
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            
        }
    }
    
    
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.assetModels.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    AssetModel *model = self.assetModels[indexPath.item];
    
    if (cell.backgroundView == nil) {//防止多次创建
        UIImageView *imageView = [[UIImageView alloc] init];
        cell.backgroundView = imageView;
    }
    UIImageView *backView = (UIImageView *)cell.backgroundView;
    backView.image = model.thumbnail;
    if (cell.selectedButton == nil) {//防止多次创建
        UIButton *selectButton = [[UIButton alloc] init];
//        [selectButton setTitle:@"no" forState:UIControlStateNormal];
//        [selectButton setTitle:@"yes" forState:UIControlStateSelected];
        
        [selectButton setImage:[UIImage imageNamed:@"image_selected@3x"] forState:UIControlStateSelected];
        [selectButton setImage:[UIImage imageNamed:@"image_unselect@3x"] forState:UIControlStateNormal];
        selectButton.frame = selectButton.imageView.frame;
        
        selectButton.titleLabel.font=[UIFont systemFontOfSize:10];
        [selectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        CGFloat width = cell.bounds.size.width;
        selectButton.frame = CGRectMake(width - 30, 0, 30, 30);
//        selectButton.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:selectButton];
        cell.selectedButton = selectButton;
        [selectButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.selectedButton.tag = indexPath.item;//重新绑定
    cell.selectedButton.selected = model.isSelect;//恢复设定状态
    return cell;
}
- (void)buttonClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    AssetModel *model = self.assetModels[sender.tag];
    //因为冲用的问题,不能根据选中状态来记录
    if (sender.selected == YES) {//选中了记录
        
        NSLog(@"选中...");
        
        model.isSelect = YES;
    }else{//否则移除记录
        
        NSLog(@"mei选中...");
        model.isSelect = NO;
    }
}

#pragma mark --- 单元格的点击事件  预览大图片
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"预览大图片");
    
    ShowCell* cell=(ShowCell*)[collectionView cellForItemAtIndexPath:indexPath];
    CGRect previousFrame=[self.collectionView convertRect:cell.frame toView:self.view];
    
    // 图片浏览器
    ImgPreviewCollectionView *browser = [[ImgPreviewCollectionView alloc] initWithFrame:previousFrame];
    browser.assetModels = self.assetModels;
    browser.currentIndex = indexPath.item;
    browser.previousFrame=previousFrame;
    [browser show];
}

@end
