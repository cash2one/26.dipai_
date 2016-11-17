//
//  ImgPreviewCollectionView.h
//  WYZ_ImgPickerc
//
//  Created by 王宇宙 on 16/7/13.
//  Copyright © 2016年 王宇宙. All rights reserved.
//

#import "ImgPreviewCollectionView.h"
#import "AssetModel.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define MARGIN 10

static NSString * const reuseIdentifier = @"browserCell";

//collectionCell
@interface CollectionCell : UICollectionViewCell
@property (nonatomic,weak) UIImageView *imageView;
@end

@implementation CollectionCell
- (UIImageView *)imageView{
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
        //手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchScale:)];
        [imageView addGestureRecognizer:pinch];
    }
    return _imageView;
}
- (void)pinchScale:(UIPinchGestureRecognizer *)recognizer{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1.0;
}
@end



#pragma mark - -----------------PhotoBrowser -----------------
@interface ImgPreviewCollectionView()

@property (nonatomic,weak) UILabel *indexLabel;
@property (nonatomic,assign) BOOL isRemoveAnimation;

@end

@implementation ImgPreviewCollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assetModels.count;
}

// 单元格的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // 单元格的背景色
    cell.backgroundColor=[UIColor blackColor];
    AssetModel *model = self.assetModels[indexPath.item];
    [model originalImg:^(UIImage *image) {
        cell.imageView.image = image;
        CGFloat scale = image.size.height / image.size.width;
        cell.imageView.center = CGPointMake(WIDTH*0.5, HEIGHT *0.5);
        cell.imageView.bounds = CGRectMake(0, 0, WIDTH, WIDTH *scale);
    }];
    
    
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    NSLog(@"还原------");
    
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    if (index < 0) return;
    
    _currentIndex = index;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    CollectionCell *cell = (CollectionCell*)[self cellForItemAtIndexPath:indexPath];
    
    cell.imageView.transform = CGAffineTransformIdentity;
    
    if (self.isRemoveAnimation == NO) {
        self.isRemoveAnimation = YES;
        //移除缩放效果
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        CollectionCell *cell = (CollectionCell*)[self cellForItemAtIndexPath:indexPath];
        
        cell.imageView.transform = CGAffineTransformIdentity;
    
        [UIView animateWithDuration:0.25 animations:^{
            cell.imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.isRemoveAnimation = NO;
        }];
    }
    
    [self setCurrentIndex:index];
}
-(instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(WIDTH, HEIGHT);
    self.collectionViewLayout = flowLayout;
    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]){
        //背景色
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        //注册cell
        [self registerClass:[CollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
       
        // 点击还原小图
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
        [self addGestureRecognizer:tap];
    }
    return self;

}


- (void)show{
    
    self.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 在窗口上添加图片浏览器
    [window addSubview:self];
    [window bringSubviewToFront:self.indexLabel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
    //        self.contentOffset = CGPointMake(_currentIndex * WIDTH, 0);
    // 滑动到选中的图片的
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
   
}

- (void)back:(UIGestureRecognizer *)recognizer{
    self.frame=_previousFrame;
    [self.indexLabel removeFromSuperview];
    [self removeFromSuperview];
//    [UIView animateWithDuration:0.5 animations:^{
//        self.frame=_previousFrame;
//    } completion:^(BOOL finished) {
//        [self.indexLabel removeFromSuperview];
//        [self removeFromSuperview];
//    }];
    
}
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
//    self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex + 1,self.assetModels.count];
}
- (UILabel *)indexLabel{
    if (_indexLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18.0];
        label.textColor = [UIColor blackColor];
        _indexLabel = label;
        label.center = CGPointMake(WIDTH*0.5, 30);
        label.bounds = CGRectMake(0, 0, 100, 30);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:label];
    }
    return _indexLabel;
}

@end

