//
//  HotVideoCell.h
//  dipai
//
//  Created by 梁森 on 16/6/12.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotVideoCellDelegate <NSObject>

- (void)turePageToVideoVCWithTag:(NSInteger)tag andWapURL:(NSString *)wapurl;

@end

@interface HotVideoCell : UITableViewCell
/**
 *  视频模型的数组
 */
@property (nonatomic, strong) NSArray * videoModelArr;

/**
 *  更多内容的按钮
 */
@property (nonatomic, strong) UIButton * moreBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (nonatomic, assign) id <HotVideoCellDelegate> delegate;
@end
