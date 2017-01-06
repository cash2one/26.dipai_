//
//  RootTabBarController.m
//  dipai
//
//  Created by 梁森 on 16/4/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "RootTabBarController.h"
// 四个子控制器
#import "InfomationViewController.h"
#import "DiscoverController.h"
#import "CommunityController.h"
#import "MineController.h"

// 会员中心和积分商城
#import "MemberViewController.h"
// 根导航栏控制器
#import "RootNavigationController.h"
@interface RootTabBarController ()<UITabBarControllerDelegate>

@property(readonly, nonatomic) NSUInteger lastSelectedIndex;

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 管理子控制器
    [self setUpChildController];
    // 设置tabBar
    [self setTabBar];
    
   
    self.delegate = self;
    
}

- (void)setTabBar
{
    // 设置tabBar的背景图片
     [self.tabBar setBackgroundImage:[UIImage imageNamed:@"biaoqianlan_beijingtu"]];
    
    NSArray * selectImg = @[@"zixun_xuanzhong", @"faxian_xuanzhong",@"shuiditubiao_xuanzhong", @"shequ_xuanzhong", @"wode_xuanzhong"];
    NSArray * normarl = @[@"zixun_moren", @"faxian_moren",@"shuiditubiao_moren", @"shequ_moren", @"wode_moren"];
    NSArray * title = @[@"资讯", @"发现",@"", @"社区", @"我的"];
    for (int i=0; i<self.tabBar.items.count; i++) {
        
        UITabBarItem *item = self.tabBar.items[i];
        if (i == 2) {
            
            item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        }
        
        // item上选中的图片和未被选中的图片
        UIImage *selectImage = [UIImage imageNamed:selectImg[i]];
        // 代码解决图片渲染问题
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage *unSelectImage = [UIImage imageNamed:normarl[i]];
        unSelectImage = [unSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // 熟记该方法
        item = [item initWithTitle:title[i] image:unSelectImage selectedImage:selectImage];
        
        //设置tabbar的选中和非选中的字体颜色。
        [item setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1],NSFontAttributeName:Font10} forState:UIControlStateNormal];
        
        [item setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:Font10} forState:UIControlStateSelected];
        
    }
}

// 注意：可能会多次调用
+ (void)initialize
{
    // appearanceWhenContainedIn：获取当前类下的所有外观
//    UITabBarItem * item = [UITabBarItem appearanceWhenContainedIn:self, nil];
//    NSMutableDictionary * selectedDic = [NSMutableDictionary dictionary];
//    selectedDic[NSForegroundColorAttributeName] = TabBarItemSelectedColor;
//    selectedDic[NSFontAttributeName] = TabBarItemSelectedFont;
//    // 设置文字颜色
//    [item setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
//    
//    NSMutableDictionary * normalDic = [NSMutableDictionary dictionary];
//    normalDic[NSForegroundColorAttributeName] = TabBarItemNormalColor;
//    normalDic[NSFontAttributeName] = TabBarItemNormalFont;
//    [item setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    
    
}
- (void)setUpChildController
{
    InfomationViewController * infoController = [[InfomationViewController alloc] init];
    RootNavigationController * infoNav = [[RootNavigationController alloc] initWithRootViewController:infoController];
    infoController.title = @"资讯";
//    [self setUPchildVC:infoController withImage:[UIImage imageNamed:@"zixun_moren"] withSelectedImage:[UIImage imageWithOriginalName:@"zixun_xuanzhong"] withTitle:@"资讯"];
    
    DiscoverController * discoverController = [[DiscoverController alloc] init];
    RootNavigationController * disNav = [[RootNavigationController alloc] initWithRootViewController:discoverController];
    discoverController.title = @"发现";
//    [self setUPchildVC:discoverController withImage:[UIImage imageNamed:@"faxian_moren"] withSelectedImage:[UIImage imageWithOriginalName:@"faxian_xuanzhong"] withTitle:@"发现"];
    
    //
    MemberViewController * memberVC = [[MemberViewController alloc] init];
    RootNavigationController * memberNav = [[RootNavigationController alloc] initWithRootViewController:memberVC];

    CommunityController * communityController = [[CommunityController alloc] init];
    RootNavigationController * comNav = [[RootNavigationController alloc] initWithRootViewController:communityController];
//    [self setUPchildVC:communityController withImage:[UIImage imageNamed:@"shequ_moren"] withSelectedImage:[UIImage imageWithOriginalName:@"shequ_xuanzhong"] withTitle:@"社区"];
    
    MineController * mineController = [[MineController alloc] init];
    RootNavigationController * mineNav = [[RootNavigationController alloc] initWithRootViewController:mineController];
//    [self setUPchildVC:mineController withImage:[UIImage imageNamed:@"wode_xuanzhong"] withSelectedImage:[UIImage imageWithOriginalName:@"wode_moren"] withTitle:@"我的"];
    
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObject:infoNav];
    [arr addObject:disNav];
    [arr addObject:memberNav];
    [arr addObject:comNav];
    [arr addObject:mineNav];
    self.viewControllers = arr;
}

#pragma mark --------抽取代码，添加子控制器
- (void)setUPchildVC:(UIViewController *)VC withImage:(UIImage *)image withSelectedImage:(UIImage *)selectedImage withTitle:(NSString *)title
{

}

#pragma mark ------- UITabBarDelegate

// 点击以后再次点击不再响应
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex != self.selectedIndex) {
        //设置最近一次变更
        _lastSelectedIndex = self.selectedIndex;
    }
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    //判断是否相等,不同才设置
    if (self.selectedIndex != selectedIndex) {
        //设置最近一次
        _lastSelectedIndex = self.selectedIndex;
    }
    
    //调用父类的setSelectedIndex
    [super setSelectedIndex:selectedIndex];
}
#pragma mark -------- UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%lu", self.selectedIndex);  // 各个tabBar的点击事件
    // 将点击的tabBar下标记录下来
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.selectedIndex) forKey:tabBarIndex];
    if (self.selectedIndex == 2) {
        [MobClick event:@"centralTabBarBtnClick"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
