//
//  UserDetails.h
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/23/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDetails : NSManagedObject
+ (void)saveUserDetails:(NSMutableDictionary *)detailsArray;
+(UserDetails *)getUserForUserID:(NSString *)userid;
+ (UserDetails *)getUser;
+ (void)deleteAllEntries;
@end




#import "User+CoreDataProperties.h"





