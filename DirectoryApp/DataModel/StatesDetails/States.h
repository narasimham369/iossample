//
//  States.h
//  DirectoryApp
//
//  Created by Vishnu KM on 27/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface States : NSManagedObject
+ (void)saveStatesDetails:(NSMutableDictionary *)detailsArray withCountry:(NSString *)country;
+ (NSArray *)getStatesWithCountryCode:(NSNumber *)countryID;
+(States *)getStatesWithStateId:(NSNumber *)stateID;
@end
NS_ASSUME_NONNULL_END

#import "States+CoreDataProperties.h"
