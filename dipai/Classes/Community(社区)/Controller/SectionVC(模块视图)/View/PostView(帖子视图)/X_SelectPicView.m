
//
//  X_SelectPicView.m
//  dipai
//
//  Created by 梁森 on 16/6/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "X_SelectPicView.h"
#import "X_FlowLayout.h"
#import "LNPhotoAsset.h"
#import "X_SelectPicViewCell.h"
#import "X_SelectPicHeaderView.h"

@interface X_SelectPicView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end
NSString *cellId = @"cellId";

NSUInteger colNumber = 4;                          //每行显示4张图片

@implementation X_SelectPicView
{
    BOOL _isShownPlus;                        //判断是否显示加号
    UILongPressGestureRecognizer *_longPress; //长安手势
}

+ (X_SelectPicView *)shareSelectPicView{
    X_SelectPicView *sv = [[X_SelectPicView alloc] initWithFrame:CGRectZero];
    
    return sv;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr = [NSMutableArray array];
        [self addSubview:self.collectionView];
    }
    
    return self;
}

- (UICollectionView *)collectionView{
    if (_collectionView) {
        return _collectionView;
    }
    X_FlowLayout *layout = [[X_FlowLayout alloc] init];
    layout.itemCount = self.dataSource.count;
    layout.colNumber = colNumber;
    layout.headerReferenceSize = CGSizeMake(WIDTH, 40*IPHONE6_H_SCALE);
    layout.itemSize = CGSizeMake(80*[UIScreen mainScreen].bounds.size.width/375.f, 80*[UIScreen mainScreen].bounds.size.width/375.0);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
     _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveAction:)];
    [_collectionView addGestureRecognizer:_longPress];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[X_SelectPicViewCell class] forCellWithReuseIdentifier:cellId];
    [_collectionView registerClass:[X_SelectPicHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    return _collectionView;
}

- (void)moveAction:(UISwipeGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
                if (_isShownPlus) {
                    if (selectIndexPath.item != self.dataArr.count-1) {
                        [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
                    }else{
                        break ;
                    }
                }else{
                    [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
            if (_isShownPlus) {
                if (selectIndexPath.item == self.dataArr.count-1) {
                    break ;
                }else{
                    [self.collectionView updateInteractiveMovementTargetPosition:[_longPress locationInView:_longPress.view]];
                }
            }else{
                [self.collectionView updateInteractiveMovementTargetPosition:[_longPress locationInView:_longPress.view]];
            }
            
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
            break;
        }
        default: [self.collectionView cancelInteractiveMovement];
            break;
    }
}

- (void)setDataSource:(NSArray *)dataSource{
    if (!dataSource.count) {
        if (self.superView) {
            for (UIView *subView in self.superView.subviews) {
                if ([subView isKindOfClass:[UITextField class]]) {
                    [subView becomeFirstResponder];
                }
            }
        }
        self.hidden = YES;
        
        return ;
    }
    
    self.hidden = NO;
    NSMutableArray *arr = [NSMutableArray array];
    for (LNPhotoAsset *photoAsset in dataSource) {
        [arr addObject:photoAsset.thumbImage];
    }
    if (dataSource.count < 9) {
        _isShownPlus = YES;
        [arr addObject:[UIImage imageNamed:@"tianjiatupian"]];
    }else{
        _isShownPlus = NO;
    }
    _dataSource = [NSArray arrayWithArray:arr];

    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:arr];
    
    [self layoutSubviews];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger row = self.dataSource.count%colNumber?self.dataSource.count/colNumber+1 : self.dataSource.count/colNumber;
    CGFloat height = 17+(80+5)*IPHONE6_H_SCALE*row+40*IPHONE6_H_SCALE;
    self.frame = CGRectMake(0, 0, WIDTH, height);
    self.collectionView.frame = self.bounds;

    [self willMoveToSuperview:self.superView];
    
    if (self.superView) {
        self.y = self.superView.height-self.height;
    }
    
    [self.collectionView reloadData];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (_superView == newSuperview) {
        return ;
    }
    if (newSuperview) {
        _superView = newSuperview;

        [self layoutSubviews];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectPicView:atIndex:)]) {
        [self.delegate didSelectPicView:self atIndex:indexPath.item];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    X_SelectPicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    __block typeof(cell) weakCell = cell;
    cell.action = ^{
        NSIndexPath *index = [collectionView indexPathForCell:weakCell];
        [self.dataArr removeObjectAtIndex:index.item];
        
        [collectionView deleteItemsAtIndexPaths:@[index]];
        if ([self.delegate respondsToSelector:@selector(deletePicView:atIndex:)]) {
            [self.delegate deletePicView:self atIndex:index.item];
        }
        if (indexPath.item == self.dataArr.count-1) {
            weakCell.btn.hidden = YES;
            weakCell.imgV.hidden = YES;
            weakCell.imgV0.hidden = NO;
        }
        
        [collectionView reloadItemsAtIndexPaths:@[index]];
        [collectionView reloadData];
    };
    cell.icon = self.dataArr[indexPath.item];
    
    if (_isShownPlus) {
        if (indexPath.item == self.dataSource.count-1) {
            cell.btn.hidden = YES;
            cell.imgV.hidden = YES;
            cell.imgV0.hidden = NO;
            cell.btnAction = ^{
                if (_Commplete) {
                    _Commplete();
                }
            };
        }else{
            cell.btn.hidden = NO;
            cell.imgV.hidden = NO;
            cell.imgV0.hidden = YES;
        }
    }else{
        cell.btn.hidden = NO;
        cell.imgV.hidden = NO;
        cell.imgV0.hidden = YES;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        X_SelectPicHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.commplete = ^{
            if (_Commplete) {
                _Commplete();
            }
        };
        
        return header;
    }
    
    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if (_isShownPlus) {
        if (sourceIndexPath.item == self.dataArr.count-1 || destinationIndexPath.item == self.dataArr.count-1) {
            return ;
        }
    }
    [self.dataArr exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    [collectionView reloadData];
}

@end
