//
//  CAPSPageMenu.h
//  
//
//  Created by Jin Sasaki on 2015/05/30.
//
//

#import <UIKit/UIKit.h>

@class CAPSPageMenu;

#pragma mark - Delegate functions
@protocol CAPSPageMenuDelegate <NSObject>

@optional
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index;

- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index;

@end

@interface MenuItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *menuItemSeparator;

- (void)setUpMenuItemView:(CGFloat)menuItemWidth menuScrollViewHeight:(CGFloat)menuScrollViewHeight indicatorHeight:(CGFloat)indicatorHeight separatorPercentageHeight:(CGFloat)separatorPercentageHeight separatorWidth:(CGFloat)separatorWidth separatorRoundEdges:(BOOL)separatorRoundEdges menuItemSeparatorColor:(UIColor *)menuItemSeparatorColor;

- (void)setTitleText:(NSString *)text;

@end

@interface CAPSPageMenu : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *menuScrollView;
@property (nonatomic, strong) UIScrollView *controllerScrollView;

@property (nonatomic, readonly) NSArray *controllerArray;
@property (nonatomic, readonly) NSArray *menuItems;
@property (nonatomic, readonly) NSArray *menuItemWidths;

@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) NSInteger lastPageIndex;

@property (nonatomic) CGFloat menuHeight;
@property (nonatomic) CGFloat menuMargin;
@property (nonatomic) CGFloat menuItemWidth;
@property (nonatomic) CGFloat selectionIndicatorHeight;
@property (nonatomic) NSInteger scrollAnimationDurationOnMenuItemTap;

@property (nonatomic, strong) UIColor *selectionIndicatorColor;
@property (nonatomic, strong) UIColor *selectedMenuItemLabelColor;
@property (nonatomic, strong) UIColor *unselectedMenuItemLabelColor;
@property (nonatomic, strong) UIColor *scrollMenuBackgroundColor;
@property (nonatomic, strong) UIColor *viewBackgroundColor;
@property (nonatomic, strong) UIColor *bottomMenuHairlineColor;
@property (nonatomic, strong) UIColor *menuItemSeparatorColor;

@property (nonatomic, strong) UIFont *menuItemFont;
@property (nonatomic) CGFloat menuItemSeparatorPercentageHeight;
@property (nonatomic) CGFloat menuItemSeparatorWidth;
@property (nonatomic) BOOL menuItemSeparatorRoundEdges;

@property (nonatomic) BOOL addBottomMenuHairline;
@property (nonatomic) BOOL menuItemWidthBasedOnTitleTextWidth;
@property (nonatomic) BOOL useMenuLikeSegmentedControl;
@property (nonatomic) BOOL centerMenuItems;
@property (nonatomic) BOOL enableHorizontalBounce;
@property (nonatomic) BOOL hideTopMenuBar;

@property (nonatomic, weak) id <CAPSPageMenuDelegate> delegate;

- (void)addPageAtIndex:(NSInteger)index;
- (void)moveToPage:(NSInteger)index;
- (instancetype)initWithViewControllers:(NSArray *)viewControllers frame:(CGRect)frame options:(NSDictionary *)options;

extern NSString * const CAPSPageMenuOptionSelectionIndicatorHeight;
extern NSString * const CAPSPageMenuOptionMenuItemSeparatorWidth;
extern NSString * const CAPSPageMenuOptionScrollMenuBackgroundColor;
extern NSString * const CAPSPageMenuOptionViewBackgroundColor;
extern NSString * const CAPSPageMenuOptionBottomMenuHairlineColor;
extern NSString * const CAPSPageMenuOptionSelectionIndicatorColor;
extern NSString * const CAPSPageMenuOptionMenuItemSeparatorColor;
extern NSString * const CAPSPageMenuOptionMenuMargin;
extern NSString * const CAPSPageMenuOptionMenuHeight;
extern NSString * const CAPSPageMenuOptionSelectedMenuItemLabelColor;
extern NSString * const CAPSPageMenuOptionUnselectedMenuItemLabelColor;
extern NSString * const CAPSPageMenuOptionUseMenuLikeSegmentedControl;
extern NSString * const CAPSPageMenuOptionMenuItemSeparatorRoundEdges;
extern NSString * const CAPSPageMenuOptionMenuItemFont;
extern NSString * const CAPSPageMenuOptionMenuItemSeparatorPercentageHeight;
extern NSString * const CAPSPageMenuOptionMenuItemWidth;
extern NSString * const CAPSPageMenuOptionEnableHorizontalBounce;
extern NSString * const CAPSPageMenuOptionAddBottomMenuHairline;
extern NSString * const CAPSPageMenuOptionMenuItemWidthBasedOnTitleTextWidth;
extern NSString * const CAPSPageMenuOptionScrollAnimationDurationOnMenuItemTap;
extern NSString * const CAPSPageMenuOptionCenterMenuItems;
extern NSString * const CAPSPageMenuOptionHideTopMenuBar;

@end
