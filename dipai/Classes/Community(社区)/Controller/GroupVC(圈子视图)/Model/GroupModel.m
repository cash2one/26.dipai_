//
//  GroupModel.m
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "GroupModel.h"
#import "NSDate+MJ.h"
@implementation GroupModel
+ (NSDictionary *)replacedKeyFromPropertyName

{
    
    return @{@"iD" : @"id"};
    
}

// 重写时间的get方法
//- (NSString *)addtime{
//    
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss ";
//    NSDate *created_at = [fmt dateFromString:_addtime];
//    //    NSLog(@"--time--%@", created_at);
//    if ([created_at isThisYear]) { // 今年
//        
//        if ([created_at isToday]) { // 今天
//            
//            // 计算跟当前时间差距
//            NSDateComponents *cmp = [created_at deltaWithNow];
//            
//            //            NSLog(@"%ld--%ld--%ld",cmp.hour,cmp.minute,cmp.second);
//            
//            if (cmp.hour >= 1) {
//                return [NSString stringWithFormat:@"%ld小时之前",cmp.hour];
//            }else if (cmp.minute > 1){
//                return [NSString stringWithFormat:@"%ld分钟之前",cmp.minute];
//            }else{
//                return @"刚刚";
//            }
//            
//        }else if ([created_at isYesterday]){ // 昨天
//            fmt.dateFormat = @"昨天 HH:mm";
//            return  [fmt stringFromDate:created_at];
//            
//        }else{ // 前天
//            fmt.dateFormat = @"MM-dd HH:mm";
//            return  [fmt stringFromDate:created_at];
//        }
//        
//        
//        
//    }else{ // 不是今年
//        
//        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
//        
//        return [fmt stringFromDate:created_at];
//        
//    }
//    return _addtime;
//    
//}
@end
