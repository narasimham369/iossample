//
//  MyFavouriteSpots.m
//  DirectoryApp
//
//  Created by Vishnu KM on 27/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "MyFavouriteSpots.h"
#import <UIKit/UIKit.h>
#import <CLToolKit/CLCoreDataAdditions.h>

@implementation MyFavouriteSpots

+ (void)saveMyFavouriteSpotsDetails:(NSArray *)detailsArray{
    for (int i = 0; i<detailsArray.count; i++) {
        id favourites = [detailsArray objectAtIndex:i];
        MyFavouriteSpots *spots = [self getfavouriteSpotsWithBusinessId:[favourites valueForKey:@"business_id"]];
        if(spots == nil )
            spots = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"MyFavouriteSpots"];
        if(![[favourites valueForKey:@"business_id"]isEqual:[NSNull null]])
            spots.businessID= [[favourites valueForKey:@"business_id"] intValue];
        if(![[favourites valueForKey:@"user_id"]isEqual:[NSNull null]])
            spots.userID= [[favourites valueForKey:@"user_id"] intValue];
        if(![[favourites valueForKey:@"business_name"]isEqual:[NSNull null]])
            spots.businessName = [NSString stringWithFormat:@"%@",[favourites valueForKey:@"business_name"]];
        if(![[favourites valueForKey:@"category_id"]isEqual:[NSNull null]])
            spots.categoryID= [[favourites valueForKey:@"category_id"] intValue];
        if(![[favourites valueForKey:@"business_email"]isEqual:[NSNull null]])
            spots.businessEmail = [NSString stringWithFormat:@"%@",[favourites valueForKey:@"business_email"]];
        if(![[favourites valueForKey:@"business_address"]isEqual:[NSNull null]])
            spots.businessAddress = [NSString stringWithFormat:@"%@",[favourites valueForKey:@"business_address"]];
        if(![[favourites valueForKey:@"business_phone"]isEqual:[NSNull null]])
            spots.businessPhone = [NSString stringWithFormat:@"%@",[favourites valueForKey:@"business_phone"]];
        if(![[favourites valueForKey:@"website"]isEqual:[NSNull null]])
            spots.website = [NSString stringWithFormat:@"%@",[favourites valueForKey:@"website"]];
        if(![[favourites valueForKey:@"latitude"]isEqual:[NSNull null]])
            spots.latitude = [[favourites valueForKey:@"latitude"] floatValue];
        if(![[favourites valueForKey:@"longitude"]isEqual:[NSNull null]])
            spots.longitude = [[favourites valueForKey:@"longitude"] floatValue];
        if(![[favourites valueForKey:@"opening_time"]isEqual:[NSNull null]])
            spots.openingTime = [NSString stringWithFormat:@"%@",[favourites valueForKey:@"opening_time"]];
        if(![[favourites valueForKey:@"closing_time"]isEqual:[NSNull null]])
            spots.closingTime = [NSString stringWithFormat:@"%@",[favourites valueForKey:@"closing_time"]];
        if(![[favourites valueForKey:@"favorite_spot_count"]isEqual:[NSNull null]])
            spots.favouriteCount= [[favourites valueForKey:@"favorite_spot_count"] intValue];
        if(![[favourites valueForKey:@"offer_count"]isEqual:[NSNull null]])
            spots.offerCount= [[favourites valueForKey:@"offer_count"] intValue];
        if(![[favourites valueForKey:@"review_count"]isEqual:[NSNull null]])
            spots.review_count= [[favourites valueForKey:@"review_count"] intValue];
        if(![[favourites valueForKey:@"recommentation_count"]isEqual:[NSNull null]])
            spots.recommentation_count= [[favourites valueForKey:@"recommentation_count"] intValue];
        if(![[favourites valueForKey:@"status"]isEqual:[NSNull null]])
            spots.status= [[favourites valueForKey:@"status"] boolValue];
        if(![[favourites valueForKey:@"time"]isEqual:[NSNull null]])
            spots.time = [NSString stringWithFormat:@"%@",[favourites valueForKey:@"time"]];
        [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
    
}

#pragma mark - GET favourite Spot

+ (NSArray *)getMyFavouriteSpots {
    NSArray *favouriteSpotsArray = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"MyFavouriteSpots"];
    if (favouriteSpotsArray.count != 0) {
        return favouriteSpotsArray;
    }
    return nil;
}

#pragma mark - Delete favourite Spot

+(void)RemoveOfferWithBussinessId:(NSNumber *)businessID{
    NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"SELF.businessID == %@",businessID];
    NSArray *deleteArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"MyFavouriteSpots" withPredicate:deletePredicate];
    if(deleteArray.count>0){
        [[CLCoreDataAdditions sharedInstance]deleteObject:[deleteArray firstObject]];
        [[CLCoreDataAdditions sharedInstance]saveEntity];
    }
}


+(MyFavouriteSpots *)getfavouriteSpotsWithBusinessId:(NSNumber *)businessID{
    NSPredicate *myCategoryListPredicate = [NSPredicate predicateWithFormat:@"SELF.businessID == %@",businessID];
    NSArray *myCategoryListArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"MyFavouriteSpots" withPredicate:myCategoryListPredicate];
    if(myCategoryListArray.count>0)
        return [myCategoryListArray firstObject];
    else
        return nil;
}

#pragma mark - Delete All Favorite Spots

+ (void)deleteAllEntries {
    [[CLCoreDataAdditions sharedInstance] deleteAllEntities:@"MyFavouriteSpots"];
    [[CLCoreDataAdditions sharedInstance] saveEntity];
}


@end
