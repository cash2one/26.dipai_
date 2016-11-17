//
//  ImgPickerViewController.m
//  WYZ_ImgPickerc
//
//  Created by 王宇宙 on 16/7/13.
//  Copyright © 2016年 王宇宙. All rights reserved.
//

#import "ImgPickerViewController.h"
#import "AssetGroupTableViewController.h"


#define IPHONE6_W_SCALE [UIScreen mainScreen].bounds.size.width / 375.0
@interface ImgPickerViewController ()

@property(nonatomic,strong) AssetGroupTableViewController* rootVc;

@end

@implementation ImgPickerViewController

-(instancetype)init{
    self=[super initWithRootViewController:self.rootVc];
    if (self) {
        self.navigationBar.tintColor=[UIColor whiteColor];  // 字体颜色
        self.navigationBar.barTintColor=[UIColor blackColor];
    }
    return self;
}


- (instancetype)initWithSelectedPics:(NSUInteger)pics{
    
    self.selectedPics = pics;
    self=[super initWithRootViewController:self.rootVc];
    if (self) {
        self.navigationBar.tintColor=[UIColor whiteColor];  // 字体颜色
        self.navigationBar.barTintColor=[UIColor blackColor];
    }
    return self;
    
}

-(AssetGroupTableViewController *)rootVc{
    if (!_rootVc) {
        _rootVc=[[AssetGroupTableViewController alloc]init];
        
        _rootVc.selectedPics = self.selectedPics;
        //        _rootVc.navigationItem.title=@"选择相册";
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
        //    titleLabel.backgroundColor = [UIColor redColor];
        titleLabel.font = [UIFont systemFontOfSize:38/2];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"相册";
        titleLabel.textColor = [UIColor whiteColor];
        _rootVc.navigationItem.titleView = titleLabel;
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        _rootVc.navigationItem.leftBarButtonItem = cancelItem;
        
    }
    return _rootVc;
}
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"1.已选中图片数：%lu", self.selectedPics);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
