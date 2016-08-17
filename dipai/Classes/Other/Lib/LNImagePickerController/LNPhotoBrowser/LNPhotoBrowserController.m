//
//  LNPhotoBrowserController.m
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/18.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "LNPhotoBrowserController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LNPhotoPickerHeader.h"
#import "UIImage+LNImage.h"
#import "UIView+LNView.h"
#import "UIImageView+LNTouch.h"

@interface LNPhotoBrowserController ()<UIScrollViewDelegate>{
    NSArray *photos;
}

@property (nonatomic, readwrite, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, strong) UIButton *completionButton;

@property (nonatomic, strong) UIImageView *checkButton;

@property (nonatomic, strong) UIView *badgeView;

@property (nonatomic, strong) UIView *footerView;

@end

@implementation LNPhotoBrowserController
@synthesize selectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.checkButton];
    [self.view addSubview:self.footerView];
    [self.footerView addSubview:self.completionButton];
    [self.footerView addSubview:self.badgeView];
    self.badgeView.badgeValue = [NSString stringWithFormat:@"%ld",[self.selectedPhotos count]];
    if ([photos count] == 0) {
        photos = [[NSArray alloc] initWithArray:self.selectedPhotos];
        selectedIndex = 0;
    }
    [self createImageView];
    [self refreshButtonStatus];
}

- (void)viewWillAppear:(BOOL)animated{
    self.checkButton.tag = selectedIndex;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * [photos count], self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * selectedIndex, 0);
    self.scrollView.delegate = self;
    [self displayImageWithIndex:selectedIndex];
}

- (void)viewDidAppear:(BOOL)animated{
    self.checkButton.tap = [LNTouchTap tapWithTapBlock:^(UIImageView *sender) {
        if (![self.selectedPhotos containsObject:photos[sender.tag]]) {
            if ([self.delegate respondsToSelector:@selector(photoBrowser:shouldSelectPhotoAssets:)]) {
                if ([self.delegate photoBrowser:self shouldSelectPhotoAssets:[self.selectedPhotos count]]) {
                    if ([self.delegate respondsToSelector:@selector(photoBrowser:didSelectedPhotoAsset:)]) {
                        sender.image = [UIImage imageNamed:@"image_selected"];
                        [self.selectedPhotos addObject:photos[sender.tag]];
                        [self.delegate photoBrowser:self didSelectedPhotoAsset:photos[sender.tag]];
                    }
                }
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(photoBrowser:deSelectedPhotoAsset:)]) {
                sender.image = [UIImage imageNamed:@"image_unselect"];
                [self.selectedPhotos removeObject:photos[sender.tag]];
                [self.delegate photoBrowser:self deSelectedPhotoAsset:photos[sender.tag]];
            }
        }
        self.badgeView.badgeValue = [NSString stringWithFormat:@"%ld",[self.selectedPhotos count]];
        [self refreshButtonStatus];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)createImageView{
    for (int i = 0; i < [photos count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"default_image"] imageCompressForWidth:SCREEN_WIDTH]];
        imageView.frame = CGRectMake(SCREEN_WIDTH * i, (self.scrollView.frame.size.height - imageView.frame.size.height) / 2, imageView.frame.size.width, imageView.frame.size.height);
        [self.imageViews addObject:imageView];
        [self.scrollView addSubview:imageView];
    }
}

- (void)displayImageWithIndex:(NSInteger)index{
    //设置imageView
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",index + 1,[photos count]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image;
        if ([photos[index] isKindOfClass:[LNPhotoAsset class]]) {
            LNPhotoAsset *photoAsset = photos[index];
            image = photoAsset.screenWidthImage;
        }else if([photos[index] isKindOfClass:[NSURL class]]){
            NSURL *url = self.selectedPhotos[index];
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        }
       dispatch_async(dispatch_get_main_queue(), ^{
           self.checkButton.tag = index;
           if ([self.selectedPhotos containsObject:photos[index]]) {
               [self.checkButton setImage:[UIImage imageNamed:@"image_selected"]];
           }else{
               [self.checkButton setImage:[UIImage imageNamed:@"image_unselect"]];
           }
           UIImageView *imageView = [self.imageViews objectAtIndex:index];
           imageView.image = [image imageCompressForWidth:SCREEN_WIDTH];
       });
    });
}

#pragma mark - UIScrollView Delegate
//view停止滚动时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.checkButton.tag = currentPage;
    [self displayImageWithIndex:currentPage];
}

- (void)setDataSource:(id<LNPhotoBrowserDataSource>)dataSource{
    photos = [dataSource numberOfPhotosInPhotoBrowser:self];
}

#pragma mark - Event Response
/**
 *  完成
 *
 *  @param sender
 */
- (void)completionAction:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:IMAGE_PICKER object:self.selectedPhotos];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  刷新按钮状态
 */
- (void)refreshButtonStatus{
    self.completionButton.enabled = [self.selectedPhotos count];
    self.completionButton.alpha = [self.selectedPhotos count] + 0.5;
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
- (UIScrollView*)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UIView*)footerView{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
        _footerView.backgroundColor = [UIColor blackColor];
        _footerView.alpha = 0.7;
    }
    return _footerView;
}

- (UIButton*)completionButton{
    if (_completionButton == nil) {
        _completionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _completionButton.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 44);
        [_completionButton setTitle:@"完成" forState:UIControlStateNormal];
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

- (UIImageView*)checkButton{
    if (_checkButton == nil) {
        _checkButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_unselect"]];
    }
    return _checkButton;
}

- (NSMutableArray*)imageViews{
    if (_imageViews == nil) {
        _imageViews = [[NSMutableArray alloc] init];
    }
    return _imageViews;
}

@end
