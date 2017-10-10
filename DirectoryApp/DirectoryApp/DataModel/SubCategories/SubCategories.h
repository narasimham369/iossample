//
//  SubCategories.h
//  DirectoryApp
//
//  Created by Vishnu KM on 27/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubCategories : NSManagedObject
+(SubCategories *)getSubCategoriesWithCategoryId:(NSNumber *)CategoryID;
+ (NSArray *)getSubCategoryWithParentID:(NSNumber *)parentID;
+ (void)saveSubCategoriesDetails:(NSArray *)detailsArray;
+ (void)deleteAllEntries;
@end

NS_ASSUME_NONNULL_END

#import "SubCategories+CoreDataProperties.h"
