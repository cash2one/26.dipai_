//
//  TwoBtnCell.h
//  dipai
//
//  Created by 梁森 on 16/6/14.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TwoBtnCell;
@protocol TwoBtnCellDelegate <NSObject>

- (void)tableViewCell:(TwoBtnCell *)cell DidClickWithURL:(NSString *)url;

@end

@interface TwoBtnCell : UITableViewCell

@property (nonatomic, strong) NSArray * modelArr;


@property (nonatomic, assign) id <TwoBtnCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
