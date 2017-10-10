//
//  MyFavouriteSpots.h
//  DirectoryApp
//
//  Created by Vishnu KM on 27/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>


NS_ASSUME_NONNULL_BEGIN

@interface MyFavouriteSpots : NSManagedObject
+ (void)saveMyFavouriteSpotsDetails:(NSArray *)detailsArray;
+ (NSArray *)getMyFavouriteSpots;
+(void)RemoveOfferWithBussinessId:(NSNumber *)businessID;
+ (void)deleteAllEntries;
@end

NS_ASSUME_NONNULL_END

#import "MyFavouriteSpots+CoreDataProperties.h"
