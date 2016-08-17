//
//  UIImageView+getSize.h
//  study
//
//  Created by 梁森 on 16/6/28.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (getSize)

+(CGSize)downloadImageSizeWithURL:(id)imageURL;
+(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request;
+(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request;
+(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request;

@end
