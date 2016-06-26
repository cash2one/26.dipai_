//
//  ForumModel.m
//  dipai
//
//  Created by 梁森 on 16/6/22.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ForumModel.h"
#import "SectionModel.h"
@implementation ForumModel

+ (NSDictionary *)objectClassInArray{
    return @{@"section":[SectionModel class]};
}

@end
