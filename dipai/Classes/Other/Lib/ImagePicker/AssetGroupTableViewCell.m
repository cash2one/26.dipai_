//
//  AssetGroupTableViewCell.m
//  WYZ_ImgPickerc
//
//  Created by 王宇宙 on 16/7/13.
//  Copyright © 2016年 王宇宙. All rights reserved.
//

#import "AssetGroupTableViewCell.h"

#define MARGIN 10

@implementation AssetGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)groupCell:(UITableView *)tableView{
    NSString *reusedId = @"groupCell";
    AssetGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    return cell;
}
- (void)setGroup:(ALAssetsGroup *)group{
    //中文
    NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];   // 获取相册分组的名字
    if ([groupName isEqualToString:@"Camera Roll"]) {
        groupName = @"相机";
    } else if ([groupName isEqualToString:@"My Photo Stream"]) {
        groupName = @"我的照片";
    }
    //设置属性
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger groupCount = [group numberOfAssets];  // 获取相册分组的所有照片
    self.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",groupName, groupCount];
    UIImage *image =[UIImage imageWithCGImage:group.posterImage] ;   // 获取相册分组中的一张图片
    [self.imageView setImage:image];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat cellHeight = self.frame.size.height - 2 *MARGIN;
    // 设置图片的大小
    self.imageView.frame = CGRectMake(MARGIN, MARGIN, cellHeight, cellHeight);
}
@end
