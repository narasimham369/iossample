//
//  SubCategories.m
//  DirectoryApp
//
//  Created by Vishnu KM on 27/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "SubCategories.h"
#import <UIKit/UIKit.h>
#import <CLToolKit/CLCoreDataAdditions.h>

@implementation SubCategories

+ (void)saveSubCategoriesDetails:(NSArray *)detailsArray{
    for (int i = 0; i<detailsArray.count; i++) {
        id subCategoryList = [detailsArray objectAtIndex:i];
        SubCategories *list = [self getSubCategoriesWithCategoryId:[subCategoryList valueForKey:@"category_id"]];
        if(list == nil )
            list = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"SubCategories"];
        if(![[subCategoryList valueForKey:@"category_id"]isEqual:[NSNull null]])
            list.categoryID= [[subCategoryList valueForKey:@"category_id"] intValue];
        if(![[subCategoryList valueForKey:@"parent_id"]isEqual:[NSNull null]])
            list.parentID = [[subCategoryList valueForKey:@"parent_id"] intValue];
        if(![[subCategoryList valueForKey:@"category_name"]isEqual:[NSNull null]])
            list.categoryName = [NSString stringWithFormat:@"%@",[subCategoryList valueForKey:@"category_name"]];
        if(![[subCategoryList valueForKey:@"description"]isEqual:[NSNull null]])
            list.subCategoryDescription = [NSString stringWithFormat:@"%@",[subCategoryList valueForKey:@"description"]];
        
        [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
    
}

#pragma mark - GET Subcateogories


+ (NSArray *)getSubCategoryWithParentID:(NSNumber *)parentID {
    NSPredicate *subCategoryPredicate = [NSPredicate predicateWithFormat:@"SELF.parentID == %@",parentID];
    NSArray *subCategoryArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"SubCategories" withPredicate:subCategoryPredicate];
    if (subCategoryArray.count != 0) {
        return subCategoryArray;
    }
    return nil;
}



+(SubCategories *)getSubCategoriesWithCategoryId:(NSNumber *)CategoryID{
    NSPredicate *myCategoryListPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryID == %@",CategoryID];
    NSArray *myCategoryListArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"SubCategories" withPredicate:myCategoryListPredicate];
    if(myCategoryListArray.count>0)
        return [myCategoryListArray firstObject];
    else
        return nil;
}


+ (void)deleteAllEntries {
    [[CLCoreDataAdditions sharedInstance] deleteAllEntities:@"SubCategories"];
    [[CLCoreDataAdditions sharedInstance] saveEntity];
}



@end
