//
//  LNPhotoCell.m
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/18.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "LNPhotoCell.h"
#import "LNPhotoPickerHeader.h"
#import "LNPhotoAsset.h"
#import "LNPhotoView.h"
#import "UIImageView+LNTouch.h"

static CGFloat IMAGE_WIDTH;

@interface LNPhotoCell ()

@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation LNPhotoCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        IMAGE_WIDTH = floor(((SCREEN_WIDTH - (LNPhotoVerticalSpace * 5)) / LNPhotoColumns));
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
