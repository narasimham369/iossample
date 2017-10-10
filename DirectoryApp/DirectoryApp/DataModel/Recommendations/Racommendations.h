//
//  Racommendations.h
//  DirectoryApp
//
//  Created by Bibin Mathew on 3/9/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>
NS_ASSUME_NONNULL_BEGIN
@interface Racommendations : NSManagedObject
+ (void)saveRecommendationsDetails:(NSArray *)detailsArray;
+(Racommendations *)getRecommendationWithUserId:(NSNumber *)userId;
+(NSArray *)getAllRecommendations;
+(NSArray *)getAllActiveUsers;
+ (void)deleteAllEntries;
@end
NS_ASSUME_NONNULL_END
#import "Racommendations+CoreDataProperties.h"
