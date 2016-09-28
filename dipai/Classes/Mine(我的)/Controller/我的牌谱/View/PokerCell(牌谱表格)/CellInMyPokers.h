//
//  CellInMyPokers.h
//  dipai
//
//  Created by 梁森 on 16/9/9.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModelOfPoker;
@class CellInMyPokers;
@class ModelInPoker;
@protocol  CellInMyPokersDelegate <NSObject>

// 点击隐藏按钮的事件
- (void)tableViewCell:(CellInMyPokers *)cell withTag:(NSInteger)tag withDidRow:(NSInteger)didRow;

// 选中牌谱的事件
- (void)tableViewCell:(CellInMyPokers *)cell withImage:(UIImage *)image withPicId:(NSInteger)iD withModel:(ModelInPoker *)model;

@end

@interface CellInMyPokers : UITableViewCell

@property (nonatomic, strong) ModelOfPoker * model;

@property (nonatomic, assign) NSInteger didRow;

// present过来的标识
@property (nonatomic, copy) NSString * present;
/**
 *  已选中的图片数组
 */
@property (nonatomic, strong) NSMutableArray * selectedPokerArr;
/**
 *  已选中图片的ID
 */
@property (nonatomic, strong) NSMutableArray * selectedPokerId;

@property (nonatomic, assign) id <CellInMyPokersDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath;
@end
