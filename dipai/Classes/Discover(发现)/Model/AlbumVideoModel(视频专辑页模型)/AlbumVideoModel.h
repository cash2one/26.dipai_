//
//  AlbumVideoModel.h
//  dipai
//
//  Created by 梁森 on 16/6/13.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumVideoModel : NSObject

@property (nonatomic, strong) NSDictionary * albumDic;
/**
 *  专辑字典
 */
@property (nonatomic, strong) NSArray * videoArr;

@end
