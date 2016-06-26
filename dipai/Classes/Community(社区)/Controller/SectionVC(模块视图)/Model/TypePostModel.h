//
//  TypePostModel.h
//  dipai
//
//  Created by 梁森 on 16/6/26.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface TypePostModel : NSObject<MJKeyValue>
/*
 "type":"171",
 "state":"1",
 "data"
 */

@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, strong) NSArray * data;
@end
