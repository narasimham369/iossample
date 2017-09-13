//
//  CategoryList.h
//  DirectoryApp
//
//  Created by Vishnu KM on 27/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryList : NSManagedObject
+(CategoryList *)getCategoriesWithCategoryId:(NSNumber *)CategoryID;
+ (void)saveCategoryListDetails:(NSArray *)detailsArray;
+ (NSArray *)getCategoryList;
+ (void)deleteAllEntries;
@end

NS_ASSUME_NONNULL_END

#import "CategoryList+CoreDataProperties.h"
