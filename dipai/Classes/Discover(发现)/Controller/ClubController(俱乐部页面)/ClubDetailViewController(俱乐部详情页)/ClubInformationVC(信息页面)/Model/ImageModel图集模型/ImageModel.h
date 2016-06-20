//
//  ImageModel.h
//  dipai
//
//  Created by 梁森 on 16/6/16.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject
/**
 *  "picname":"http://10.0.0.14:8081/uploads/imgs/2015/10/1444288551gvk.jpg",
 "note1":""
 */
/**
*  图片
*/
@property (nonatomic, copy) NSString * picname;
/**
 *  图片描述
 */
@property (nonatomic, copy) NSString * note1;
@end
