//
//  X_FlowLayout.m
//  dipai
//
//  Created by 梁森 on 16/6/25.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "X_FlowLayout.h"

@implementation X_FlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *visiableAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *atts = [@[] mutableCopy];
    for (UICollectionViewLayoutAttributes *attributes in visiableAttributes) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            UICollectionViewLayoutAttributes *oriAtt = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
            [atts addObject:oriAtt];
        }else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView){
            UICollectionViewLayoutAttributes *oriAtt = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:attributes.indexPath];
            [atts addObject:oriAtt];
        }else{
            [atts addObject:attributes];
        }
    }
    
    return atts;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    
    CGPoint original;
    if (indexPath.section == 0 && indexPath.item == 0) {
        original = CGPointMake(15*IPHONE6_W_SCALE, (40+10)*IPHONE6_H_SCALE);
    }else{
        UICollectionViewLayoutAttributes *preAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section]];
        if (CGRectGetMinY(attributes.frame) > CGRectGetMinY(preAttributes.frame)+self.itemSize.height*2/3) {
            original = CGPointMake(15*IPHONE6_W_SCALE, CGRectGetMaxY(preAttributes.frame)+5*IPHONE6_H_SCALE);
        }else{
            original = CGPointMake(CGRectGetMaxX(preAttributes.frame)+8.5f*IPHONE6_W_SCALE, CGRectGetMinY(preAttributes.frame));
        }
    }
    
    attributes.frame = CGRectMake(original.x, original.y, self.itemSize.width, self.itemSize.height);
    
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        CGRect rect = attributes.frame;
        attributes.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 40*IPHONE6_H_SCALE);
    }
    
    return attributes;
}

@end
