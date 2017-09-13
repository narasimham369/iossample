//
//  SurpriseBox.h
//  DirectoryApp
//
//  Created by Vishnu KM on 07/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SurpriseBox : NSManagedObject
+ (void)saveSurpriseBoxDetails:(NSArray *)detailsArray;
+ (NSArray *)getSurpriseBoxData;
+ (void)deleteAllEntries;
+(void)updateSavedStatusWithCouponID:(NSNumber*)coupId;
+(void)RemoveSurpriceWithId:(NSNumber *)UserID :(NSNumber *)notificationType;
@end

NS_ASSUME_NONNULL_END

#import "SurpriseBox+CoreDataProperties.h"
