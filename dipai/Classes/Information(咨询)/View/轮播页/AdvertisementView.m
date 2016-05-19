//
//  AdvertisementView.m
//  dipai
//
//  Created by 梁森 on 16/4/29.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "AdvertisementView.h"
// 适配第三方
#import "Masonry.h"
#import "UIImageView+WebCache.h"
// 轮播页模型
#import "bannerModel.h"
@interface AdvertisementView()<UIScrollViewDelegate>
/**
 *  滚动视图
 */
@property (nonatomic, strong) UIScrollView * scroll;
/**
 *  分页控件
 */
@property (nonatomic, strong) UIPageControl * pageControl;
/**
 *  时间定时器
 */
@property (nonatomic, strong) NSTimer *timer;
/**
 *  传递过来的个数
 */
@property (nonatomic, assign) int count;

/**
 *  用来接收传递过来的模型数组
 */
@property (nonatomic, strong) NSArray * modelArr;

@end

@implementation AdvertisementView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置上面的子控件
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView
{
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HeaderViewHeight * IPHONE6_H_SCALE)];
//    scroll.backgroundColor = [UIColor redColor];
    scroll.scrollsToTop = NO;   // 这样就可以点击状态栏返回顶部了
    scroll.pagingEnabled = YES;
    scroll.bounces = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.delegate = self;
    [self addSubview:scroll];
    _scroll = scroll;
    // 设置滚动视图的内容视图
    
}
-(void)setScrollWithCount:(int)counts andArray:(NSArray *)bannerModelArray
{
    
    _modelArr = [NSArray array];
    _modelArr = bannerModelArray;
    _count = counts;
    
    _scroll.contentSize = CGSizeMake(counts * WIDTH, 0);
    // 往滚动视图上添加imageView
    for (int i = 0; i < counts; i ++) {
        UIImageView * picView = [[UIImageView alloc] initWithFrame:_scroll.bounds];
        picView.backgroundColor = [UIColor yellowColor];
        picView.userInteractionEnabled = YES;
        
        bannerModel * bannnerM = [[bannerModel alloc] init];
        bannnerM = bannerModelArray[i];
        [picView sd_setImageWithURL:[NSURL URLWithString:bannnerM.cover] placeholderImage:[UIImage imageNamed:@"123"]];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = _scroll.bounds;
        btn.backgroundColor = [UIColor clearColor];
        [picView addSubview:btn];
        btn.tag = ButtonTag + i;
        [btn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        // 往imageView上添加label
        UILabel * label = [[UILabel alloc] init];
        [label setFont:Font16];
        label.textColor = [UIColor whiteColor];
        label.text = bannnerM.title;
        
        // label上的文字首行缩进
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [paragraphStyle setFirstLineHeadIndent:10];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
        label.attributedText = attributedString;
        [label sizeToFit];
        
        label.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.3];
        [picView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(picView.mas_left);
            make.right.equalTo(picView.mas_right);
            make.bottom.equalTo(picView.mas_bottom);
            make.height.equalTo(@(LabelHeight * IPHONE6_H_SCALE));
        }];
        
        [_scroll addSubview:picView];
    }
    // 计算imageView的位置
    [_scroll.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        
        // 调整x => origin => frame
        CGRect frame = imageView.frame;
        frame.origin.x = idx * frame.size.width;
        
        imageView.frame = frame;
    }];
    
    // 往滚动视图上添加分页控件
    _pageControl = [[UIPageControl alloc] init];
//    _pageControl.backgroundColor = [UIColor blackColor];
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_scroll.mas_right).offset(-10);
        make.bottom.equalTo(_scroll.mas_bottom).offset(-14);
        make.height.equalTo(@5);
    }];
    // 总页数
    _pageControl.numberOfPages = counts;
    // 控件尺寸
    CGSize size = [_pageControl sizeForNumberOfPages:counts];
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    // 设置颜色
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    // 添加监听方法
    /** 在OC中，绝大多数"控件"，都可以监听UIControlEventValueChanged事件，button除外" */
//    [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    
    // 启动时钟
    [self startTimer];
}

#pragma mark -------轮播页上按钮的点击事件
- (void)ClickBtn:(UIButton *)btn
{
//    NSLog(@"按钮的tag值：－－－%lu", btn.tag);
    bannerModel * model = _modelArr[btn.tag - 100];
    NSString * url = model.url;
    if ([self.delegate respondsToSelector:@selector(turnPageToDetailView:)]) {
        [self.delegate performSelector:@selector(turnPageToDetailView:) withObject:url];
    } else
    {
        NSLog(@"轮播页的代理没有响应...");
    }
}

- (void)startTimer
{
    self.timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    // 添加到运行循环
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateTimer
{
    // 页号发生变化
    // (当前的页数 + 1) % 总页数
    int page = (self.pageControl.currentPage + 1) % _count;
    self.pageControl.currentPage = page;
    
    // 调用监听方法，让滚动视图滚动
    [self pageChanged:self.pageControl];
}
// 分页控件的监听方法
- (void)pageChanged:(UIPageControl *)page
{
    // 根据页数，调整滚动视图中的图片位置 contentOffset
    CGFloat x = page.currentPage * self.scroll.bounds.size.width;
    [self.scroll setContentOffset:CGPointMake(x, 0) animated:YES];
}

#pragma mark -------- UIScrollViewDelegate
// 滚动视图停下来，修改页面控件的小点（页数）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 停下来的当前页数
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    // 计算页数
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    self.pageControl.currentPage = page;
}

/**
 修改时钟所在的运行循环的模式后，抓不住图片
 
 解决方法：抓住图片时，停止时钟，送售后，开启时钟
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"%s", __func__);
    // 停止时钟，停止之后就不能再使用，如果要启用时钟，需要重新实例化
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"%s", __func__);
    [self startTimer];
}

@end
