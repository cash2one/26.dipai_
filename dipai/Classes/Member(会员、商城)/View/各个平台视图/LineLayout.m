//
//  LineLayout.m
//  自定义UICollectionView的布局
//
//  Created by Tengfei on 15/12/27.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import "LineLayout.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width

static const CGFloat ItemHW = 100;

@implementation LineLayout

-(instancetype)init
{
    if (self = [super init]) {
 //        UICollectionViewLayoutAttributes
    
        
    }
    return self;
}

/**
 *  一些初始化工作，最好在这里实现
 */
-(void)prepareLayout
{
    [super prepareLayout];
    
    //初始化
//    self.itemSize = CGSizeMake(243*IPHONE6_W_SCALE, 359*IPHONE6_W_SCALE);
     self.itemSize = CGSizeMake(121.5*IPHONE6_W_SCALE, 179.5*IPHONE6_W_SCALE);
    //     self.itemSize = CGSizeMake(100, 100);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 100;
        
    CGFloat inset = (self.collectionView.frame.size.width - ItemHW) / 2;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}


/**
 *  控制最后srollview的最后去哪里
 *  用来设置collectionView停止滚动那一刻的位置
 *
 *  @param proposedContentOffset 原本Scrollview停止滚动那一刻的位置
 *  @param velocity              滚动速度
 */
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //1.计算scrollview最后停留的范围
    CGRect lastRect ;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    //2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    //计算屏幕最中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2 ;
    
    //3.遍历所有的属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if(ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)){//取出最小值
            adjustOffsetX = attrs.center.x - centerX;
        }
    }
    
    
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}

/**
 *  返回yes，只要显示的边界发生改变，就需要重新布局：(会自动调用layoutAttributesForElementsInRect方法，获得所有cell的布局属性)
 */
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //0:计算可见的矩形框
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
//    UICollectionViewLayoutAttributes
    //1.取出默认cell的UICollectionViewLayoutAttributes
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    //计算屏幕最中间的x
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2 ;
    
//    NSLog(@"centerX%f", centerX);
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    //2.遍历所有的布局属性
    for (UICollectionViewLayoutAttributes *attrs in array) {
        
        if (CGRectIntersectsRect(attrs.frame, rect)) {
            
            BOOL isAtRight = YES;
            CGFloat distance = (attrs.center.x - CGRectGetMidX(visibleRect));
            if (distance<0) {
                distance = -distance;
                isAtRight = NO;
            }
            CGFloat precent ;
            if (distance < 180)
            {
                precent = 1.0;
            }
            else
            {
                precent = ((screenWidth / 2) - distance) / (screenWidth / 2);
            }
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0 / 600;
            
            if (precent < 0.5) {
                precent = 0.5;
            }
//            transform =  CATransform3DScale(transform, 1, precent, 1);
//            CGFloat p = isAtRight?M_PI_4:-M_PI_4;
//            transform = CATransform3DRotate(transform, p * (1 - precent), 0, 1, 0);
            
            
//            attrs.transform3D = transform;
//            attrs.zIndex = 1;
            attrs.alpha = precent;
            
        }

        
        //不是可见范围的 就返回，不再屏幕就直接跳过
        if (!CGRectIntersectsRect(visiableRect, attrs.frame)) continue;
        
        
        //每一个item的中心x值
        CGFloat itemCenterx = attrs.center.x;
        
//        NSLog(@"itemCenterx:%f",  itemCenterx);
        
        //差距越小，缩放比例越大
        //根据与屏幕最中间的距离计算缩放比例
        // ABS：取绝对值
//       CGFloat scale = 1 + (1 - ABS(itemCenterx - centerX) / self.collectionView.frame.size.width * 0.6)*0.8;//比例值很随意，适合就好
         CGFloat scale = 1 + (1 - ABS(itemCenterx - centerX) / self.collectionView.frame.size.width * 1.0)*1.0;//比例值很随意，适合就好
                
        //用这个，缩放不会改变frame大小，所以判断可见范围就无效，item即将离开可见范围的时候，突然消失不见
        attrs.transform3D = CATransform3DMakeScale(scale, scale, 1.0);
//        attrs.transform3D = CATransform3DMakeScale(1, 1, 1.0);  // 不会发生放大的效果     scale:放大比例
    }
    
    return array;
}

@end









