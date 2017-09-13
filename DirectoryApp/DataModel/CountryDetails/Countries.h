//
//  Countries.h
//  DirectoryApp
//
//  Created by Vishnu KM on 27/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>



NS_ASSUME_NONNULL_BEGIN

@interface Countries : NSManagedObject
+ (void)saveCountryDetails:(NSMutableDictionary *)detailsArray;
+ (NSArray *)getCountries;
@end


NS_ASSUME_NONNULL_END

#import "Countries+CoreDataProperties.h"
