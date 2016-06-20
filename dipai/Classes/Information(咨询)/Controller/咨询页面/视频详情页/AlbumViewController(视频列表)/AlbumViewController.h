//
//  AlbumViewController.h
//  dipai
//
//  Created by 梁森 on 16/6/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumModel;
@protocol AlbumViewControllerDelegate <NSObject>
// 传递视频网址和视频下标
- (void)sendVideoUrl:(NSString *)videoUrl andIndex:(NSInteger)index andVideoID:(NSString *)iD andURL:(NSString *)url andAblumModel:(AlbumModel *)albumModel;

@end

@interface AlbumViewController : UITableViewController
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) id <AlbumViewControllerDelegate> delegate;

@end
