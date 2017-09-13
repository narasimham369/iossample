//
//  CategoryList.m
//  DirectoryApp
//
//  Created by Vishnu KM on 27/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "CategoryList.h"
#import <UIKit/UIKit.h>
#import <CLToolKit/CLCoreDataAdditions.h>


@implementation CategoryList

+ (void)saveCategoryListDetails:(NSArray *)detailsArray{
     [self deleteAllEntries];
    for (int i = 0; i<detailsArray.count; i++) {
        id categoryList = [detailsArray objectAtIndex:i];
        CategoryList *list = [self getCategoriesWithCategoryId:[categoryList valueForKey:@"category_id"]];
        if(list == nil )
            list = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"CategoryList"];
        if(![[categoryList valueForKey:@"category_id"]isEqual:[NSNull null]])
            list.categoryID= [[categoryList valueForKey:@"category_id"] intValue];
        if(![[categoryList valueForKey:@"parent_id"]isEqual:[NSNull null]])
            list.parentID = [[categoryList valueForKey:@"parent_id"] intValue];
        if(![[categoryList valueForKey:@"category_name"]isEqual:[NSNull null]])
            list.categoryName = [NSString stringWithFormat:@"%@",[categoryList valueForKey:@"category_name"]];
        if(![[categoryList valueForKey:@"description"]isEqual:[NSNull null]])
            list.categoryDescription = [NSString stringWithFormat:@"%@",[categoryList valueForKey:@"description"]];
        
        [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
    
}

#pragma mark - GET Categorylist

+ (NSArray *)getCategoryList {
    NSArray *categoryListArray = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"CategoryList"];
    if (categoryListArray.count != 0) {
        return categoryListArray;
    }
    return nil;
}


+(CategoryList *)getCategoriesWithCategoryId:(NSNumber *)CategoryID{
    NSPredicate *myCategoryListPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryID == %d",[CategoryID intValue]];
    NSArray *myCategoryListArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"CategoryList" withPredicate:myCategoryListPredicate];
    if(myCategoryListArray.count>0)
        return [myCategoryListArray firstObject];
    else
        return nil;
}

+ (void)deleteAllEntries {
    [[CLCoreDataAdditions sharedInstance] deleteAllEntities:@"CategoryList"];
    [[CLCoreDataAdditions sharedInstance] saveEntity];
}

@end
