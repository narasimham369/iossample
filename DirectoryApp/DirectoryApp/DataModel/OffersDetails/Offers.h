//
//  Offers.h
//  DirectoryApp
//
//  Created by Vishnu KM on 01/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Offers : NSManagedObject
+ (void)saveOffersListDetails:(NSArray *)detailsArray;
+ (NSArray *)getOffersList;
+ (void)deleteAllEntries;
+ (void)saveOfferDetailsWithDataDictionary:(NSMutableDictionary *)dataDictionary;
+(void)deleteOfferWithOfferId:(NSNumber *)offerId;
@end

NS_ASSUME_NONNULL_END

#import "Offers+CoreDataProperties.h"
