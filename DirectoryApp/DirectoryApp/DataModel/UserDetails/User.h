//
//  User.h
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/23/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface User : NSManagedObject
+ (void)saveUserDetails:(NSMutableDictionary *)detailsArray;
+ (void)saveUserToLocalDBWithDataDictionary:(id)dataDictionary;
+ (User *)getUserForUserID:(NSString *)userid;
+ (User *)getUser;
+ (void)deleteAllEntries;
@end

//NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"





