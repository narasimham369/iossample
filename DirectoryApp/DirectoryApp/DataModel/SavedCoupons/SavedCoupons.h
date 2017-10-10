//
//  SavedCoupons.h
//  DirectoryApp
//
//  Created by Vishnu KM on 06/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SavedCoupons : NSManagedObject
+ (void)savedCouponsDetails:(NSArray *)detailsArray;
+ (NSArray *)getSavedCoupons;
+(void)deleteOfferWithOfferId:(NSNumber *)CouponId;
+ (void)deleteAllEntries;

@end

NS_ASSUME_NONNULL_END

#import "SavedCoupons+CoreDataProperties.h"
