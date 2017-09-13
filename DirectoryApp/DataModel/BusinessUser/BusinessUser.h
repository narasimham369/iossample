//
//  BusinessUser.h
//  DirectoryApp
//
//  Created by Bibin Mathew on 3/2/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>
NS_ASSUME_NONNULL_BEGIN
@interface BusinessUser : NSManagedObject
+(BusinessUser *)getBusinessUser;
+ (void)saveUserDetails:(NSMutableDictionary *)detailsArray;
+(void)saveBusinessuserToLocalDbWithDataDictionary:(NSMutableDictionary *)dataDictionary;
+ (void)deleteAllEntries;
@end
NS_ASSUME_NONNULL_END

#import "BusinessUser+CoreDataProperties.h"
