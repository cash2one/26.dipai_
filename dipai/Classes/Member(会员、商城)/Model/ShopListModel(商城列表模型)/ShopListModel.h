//
//  ShopListModel.h
//  dipai
//
//  Created by 梁森 on 16/10/21.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface ShopListModel : NSObject<MJKeyValue>

/*
 "name":"衣服",
 "url":"http://dipaiapp.replays.net/app/goods/list/2",
 "data":Array[2]
 */

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, strong) NSArray * data;

@end
