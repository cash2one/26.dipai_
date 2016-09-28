//
//  MorePicsVC.m
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "MorePicsVC.h"
#import "UIImageView+WebCache.h"
#import "ImageModel.h"

@interface MorePicsVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *ImgView;

@property (nonatomic, strong) UILabel *PageLabel;

//scroll里面的图片view 数组
@property (nonatomic,strong) NSMutableArray *arr_viewImg;
//scroller里面的scroller   数组
@property (nonatomic,strong) NSMutableArray *arr_scro;
//未缩放的 view的Img 的frame 的数组
@property (nonatomic,strong) NSMutableArray *arr_imgF;
//scroller 显示的当前页数
@property (nonatomic,assign) int currentPage;


@end

@implementation MorePicsVC
- (NSMutableArray *) arr_imgF{
    if (!_arr_imgF) {
        _arr_imgF = [NSMutableArray array];
    }
    return _arr_imgF;
}
- (NSMutableArray *) arr_scro{
    if (!_arr_scro) {
        _arr_scro = [NSMutableArray array];
    }
    return _arr_scro;
}
- (NSMutableArray *)arr_viewImg{
    if (!_arr_viewImg) {
        _arr_viewImg = [NSMutableArray array];
    }
    return _arr_viewImg;
}
- (int)currentPage{
    if (!_currentPage) {
        _currentPage = 1;
    }
    return _currentPage;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1]];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_beijingditu"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setUpNavigationBar];
    
    [self setUpUI];
}
#pragma mark --- 设置导航栏
- (void)setUpNavigationBar{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"houtui_baise"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}
#pragma mark --- 返回上一个视图控制器
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUpUI{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
//
    _PageLabel = [[UILabel alloc] init];
//    _PageLabel.backgroundColor = [UIColor redColor];
    _PageLabel.center = CGPointMake(self.view.center.x, HEIGHT - 30-64);
    _PageLabel.text = [NSString stringWithFormat:@"1/%lu" , (unsigned long)_images.count];
    
    _PageLabel.textColor = [UIColor whiteColor];
    [_PageLabel sizeToFit];
    [self.view addSubview:_PageLabel];
//
    for ( int i = 0 ; i < _images.count ; i++ ) {
        
        UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(WIDTH * i, -SPWidth  , WIDTH , HEIGHT -64)];
        sc.maximumZoomScale = 2.0;
        sc.minimumZoomScale = 1.0;
        sc.decelerationRate = 0.2;
        sc.delegate = self;
        sc.tag = 1 + i;
        [_scrollView addSubview:sc];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
        ImageModel * imageModel = _images[i];
        NSString *str = imageModel.picname;
        [img sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"123"]];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makePicBigger:)];
        tap.numberOfTapsRequired = 2;

        sc.userInteractionEnabled = YES;
        [sc addGestureRecognizer:tap];
        
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.tag = 1000 + i;
        img.userInteractionEnabled = YES;
        [sc addSubview:img];
        sc.contentSize = CGSizeMake( WIDTH , 0);
        
        [self.arr_viewImg addObject:img];
        [self.arr_scro addObject:sc];
        UIImageView *viewimg = [[UIImageView alloc]initWithFrame:img.frame];
        [self.arr_imgF addObject:viewimg];
    }
    _scrollView.contentSize = CGSizeMake( WIDTH * _images.count , 0);
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    UIImageView *imgView  = [self.arr_viewImg objectAtIndex:self.currentPage-1];
    
    if (imgView.frame.size.width > WIDTH  && imgView.frame.size.height > Height126) {
        
        scrollView.contentSize = CGSizeMake(imgView.frame.size.width, imgView.frame.size.height);
        
    }else if (imgView.frame.size.width > WIDTH && imgView.frame.size.height <= Height126 ){
        
        scrollView.contentSize = CGSizeMake(imgView.frame.size.width, Height126 );
        
    }else if (imgView.frame.size.width <= WIDTH && imgView.frame.size.height > Height126 ){
        
        scrollView.contentSize = CGSizeMake( WIDTH , imgView.frame.size.height);
    }else if (imgView.frame.size.width <= WIDTH && imgView.frame.size.height <= Height126 ){
        
        scrollView.contentSize = CGSizeMake( WIDTH , Height126 );
    }else{
        NSArray *arr1 = [scrollView subviews];
        
        UIScrollView *scro = [arr1 objectAtIndex:self.currentPage-1];
        scro.contentSize = CGSizeMake( WIDTH , Height126 );
    }
    imgView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag >0 == NO) {
        NSInteger numOfPage = ABS(self.scrollView.contentOffset.x / scrollView.frame.size.width);
        
        if (numOfPage != self.currentPage-1) {
            
            UIScrollView *scro = [self.arr_scro objectAtIndex:self.currentPage-1];
            scro.contentSize = CGSizeMake( WIDTH , Height126 );
            scro.zoomScale = 1;
        }
        self.currentPage = (int)(numOfPage + 1);
        _PageLabel.text = [NSString stringWithFormat:@"%d/%ld",_currentPage , _images.count];
        [_PageLabel sizeToFit];
    }
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    UIImageView *imgView  = [self.arr_viewImg objectAtIndex:self.currentPage-1];
    UIImageView *noscaView = [self.arr_imgF objectAtIndex:self.currentPage-1];
    if (imgView.frame.size.width <= WIDTH && imgView.frame.size.height <= Height126){
        scrollView.contentSize = CGSizeMake( WIDTH , Height126 );
        imgView.frame = noscaView.frame;
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    if(scrollView.tag == self.currentPage){
        //取出 当前缩放图 的 未缩放的frame
        UIImageView *imgView  = [self.arr_viewImg objectAtIndex:self.currentPage-1];
        if (imgView.frame.size.width > WIDTH ) {
            
        }
        return imgView;
    }
    return nil;
}
#pragma mark --- 双击放大图片
- (void)makePicBigger:(UIGestureRecognizer *)gesture{
    
    
    NSLog(@"双击放大图片...");
    UIScrollView * sc = (UIScrollView *)gesture.view;
//
//    CGFloat zs = sc.zoomScale;
//    zs = (zs == 1.0) ? 2.0 : 1.0;
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    sc.zoomScale = zs;
//    [UIView commitAnimations];
    
    
//    CGPoint touchPoint = [gesture locationInView:gesture.view];
//    if (sc.zoomScale == sc.maximumZoomScale) {
//        [sc setZoomScale:sc.minimumZoomScale animated:YES];
//    } else {
//        [sc zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
//    }
    
    CGFloat zoomScale = sc.zoomScale;
    
    NSLog(@"%f", zoomScale);
    
    zoomScale = (zoomScale == 1.0) ? 3.0 : 1.0;
    
    NSLog(@"%f", zoomScale);
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[gesture locationInView:gesture.view]];
    [sc zoomToRect:zoomRect animated:YES];
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.view.frame.size.height / scale;
    zoomRect.size.width  =self.view.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}



@end
