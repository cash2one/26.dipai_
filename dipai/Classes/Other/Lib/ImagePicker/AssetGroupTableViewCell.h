//
//  AssetGroupTableViewCell.h
//  WYZ_ImgPickerc
//
//  Created by 王宇宙 on 16/7/13.
//  Copyright © 2016年 王宇宙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// 自定义的单元格
@interface AssetGroupTableViewCell : UITableViewCell

// 分组的相册
@property(nonatomic,strong) ALAssetsGroup* group;
// 创建单元格的类方法
+(instancetype)groupCell:(UITableView*)tableView;
@end
