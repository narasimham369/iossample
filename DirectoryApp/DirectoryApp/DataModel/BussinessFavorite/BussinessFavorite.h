//
//  BussinessFavorite.h
//  DirectoryApp
//
//  Created by Hari R Krishna on 3/22/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>
NS_ASSUME_NONNULL_BEGIN
@interface BussinessFavorite : NSManagedObject
+ (void)saveFavoriteDetails:(NSArray *)detailsArray;
+(NSArray *)getAllFavoritesUsers;
+(BussinessFavorite *)getFavoriteWithUserId:(NSNumber *)userId;
+(NSArray *)getAllActiveUsers;
+ (void)deleteAllEntries ;
@end
NS_ASSUME_NONNULL_END
#import "BussinessFavorite+CoreDataProperties.h"
