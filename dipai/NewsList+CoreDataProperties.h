//
//  NewsList+CoreDataProperties.h
//  dipai
//
//  Created by 梁森 on 16/5/23.
//  Copyright © 2016年 梁森. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NewsList.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *iD;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *shorttitle;
@property (nullable, nonatomic, retain) NSString *commentNumber;
@property (nullable, nonatomic, retain) NSString *descriptioN;
@property (nullable, nonatomic, retain) id covers;
@property (nullable, nonatomic, retain) NSString *url;

@end

NS_ASSUME_NONNULL_END
