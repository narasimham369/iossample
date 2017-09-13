//
//  Countries.m
//  DirectoryApp
//
//  Created by Vishnu KM on 27/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Countries.h"
#import <UIKit/UIKit.h>
#import <CLToolKit/CLCoreDataAdditions.h>


@implementation Countries

+ (void)saveCountryDetails:(NSArray *)detailsArray{
    for (int i = 0; i<detailsArray.count; i++) {
        id countryData = [detailsArray objectAtIndex:i];
        Countries *countries = [self getCountriesWithCountryId:[countryData valueForKey:@"country_id"]];
        if(countries == nil )
        countries = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"Countries"];
        if(![[countryData valueForKey:@"country_id"]isEqual:[NSNull null]])
            countries.countryId= [[countryData valueForKey:@"country_id"] intValue];
        if(![[countryData valueForKey:@"country_code"]isEqual:[NSNull null]])
            countries.countryCode = [NSString stringWithFormat:@"%@",[countryData valueForKey:@"country_code"]];
        if(![[countryData valueForKey:@"country_name"]isEqual:[NSNull null]])
            countries.countryName = [NSString stringWithFormat:@"%@",[countryData valueForKey:@"country_name"]];
        
    [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
    
}

#pragma mark - GET Countries

+ (NSArray *)getCountries {
    NSArray *detailArrayCountries = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"Countries"];
    if (detailArrayCountries.count != 0) {
        return detailArrayCountries;
    }
        return nil;
}

    
+(Countries *)getCountriesWithCountryId:(NSNumber *)CountryID{
        NSPredicate *myCountryPredicate = [NSPredicate predicateWithFormat:@"SELF.countryId == %@",CountryID];
        NSArray *myCountryArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"Countries" withPredicate:myCountryPredicate];
        if(myCountryArray.count>0)
            return [myCountryArray firstObject];
        else
            return nil;
    }

@end
