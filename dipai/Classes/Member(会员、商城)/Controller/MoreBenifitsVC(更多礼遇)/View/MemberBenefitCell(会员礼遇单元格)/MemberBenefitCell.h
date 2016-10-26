//
//  MemberBenefitCell.h
//  dipai
//
//  Created by 梁森 on 16/10/20.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemberBenefitCellDelegate <NSObject>

- (void)MemberBenefitCell:(UITableViewCell *)cell didClickWithTag:(NSInteger)tag;

@end

@interface MemberBenefitCell : UITableViewCell

@property (nonatomic, strong) NSArray * levelArr;

@property (nonatomic, copy) NSString * level;
// 会员等级名称
@property (nonatomic, strong) UILabel * levelName;

@property (nonatomic, strong) UIView * lineV;

@property (nonatomic, assign) id <MemberBenefitCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
