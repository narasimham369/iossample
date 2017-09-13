//
//  BussinessFavorite.m
//  DirectoryApp
//
//  Created by Hari R Krishna on 3/22/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "BussinessFavorite.h"
#import <CLToolKit/CLCoreDataAdditions.h>

@implementation BussinessFavorite

+ (void)saveFavoriteDetails:(NSArray *)detailsArray{
    [self deleteAllEntries];
    for (int i = 0; i<detailsArray.count; i++) {
        id recList = [detailsArray objectAtIndex:i];
        BussinessFavorite *list = [self getFavoriteWithUserId:[recList valueForKey:@"user_id"]];
        if(list == nil )
            list = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"BussinessFavorite"];
        if(![[recList valueForKey:@"user_id"]isEqual:[NSNull null]])
            list.user_id= [[recList valueForKey:@"user_id"] intValue];
        if(![[recList valueForKey:@"favorited_id"]isEqual:[NSNull null]])
            list.favorited_id= [[recList valueForKey:@"favorited_id"] intValue];
        if(![[recList valueForKey:@"fullName"]isEqual:[NSNull null]])
            list.fullName = [NSString stringWithFormat:@"%@",[recList valueForKey:@"fullName"]];
        if(![[recList valueForKey:@"FavoritedOn"]isEqual:[NSNull null]])
            list.favoritedOn = [[recList valueForKey:@"FavoritedOn"] doubleValue];
        if(![[recList valueForKey:@"userPhone"]isEqual:[NSNull null]])
            list.userPhone = [NSString stringWithFormat:@"%@",[recList valueForKey:@"userPhone"]];
        if(![[recList valueForKey:@"specialCouponSendStatus"]isEqual:[NSNull null]])
            list.specialCouponSendStatus = [[recList valueForKey:@"specialCouponSendStatus"] boolValue];
        if(![[recList valueForKey:@"specialCouponSentCount"]isEqual:[NSNull null]])
            list.specialCouponSentCount = [[recList valueForKey:@"specialCouponSentCount"] intValue];
        if(![[recList valueForKey:@"thanksSendStatus"]isEqual:[NSNull null]])
            list.thanksSendStatus = [[recList valueForKey:@"thanksSendStatus"] boolValue];
        if(![[recList valueForKey:@"thanksSendStatus"]isEqual:[NSNull null]])
            list.thanksSendStatus = [[recList valueForKey:@"thanksSendStatus"] boolValue];
        if(![[recList valueForKey:@"userEmail"]isEqual:[NSNull null]])
            list.userEmail = [NSString stringWithFormat:@"%@",[recList valueForKey:@"userEmail"]];
        [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
    
}

+(BussinessFavorite *)getFavoriteWithUserId:(NSNumber *)userId{
    NSPredicate *recommendationPredicate = [NSPredicate predicateWithFormat:@"SELF.user_id== %@",userId];
    NSArray *recommendationsArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"BussinessFavorite" withPredicate:recommendationPredicate];
    if(recommendationsArray.count>0)
        return [recommendationsArray firstObject];
    else
        return nil;
}

+(NSArray *)getAllFavoritesUsers{
    NSArray *recommendationsListArray = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"BussinessFavorite"];
    recommendationsListArray = [[CLCoreDataAdditions sharedInstance] getAllDocuments:@"BussinessFavorite" sortByKey:@"specialCouponSentCount" withPredicate:nil whetherAscendingOrder:YES];
    return recommendationsListArray;
}

+(NSArray *)getAllActiveUsers{
    NSPredicate *recommendationPredicate = [NSPredicate predicateWithFormat:@"SELF.specialCouponSentCount!= %@",[NSNumber numberWithInt:2]];
    NSArray *recommendationsListArray = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"BussinessFavorite"];
    recommendationsListArray = [[CLCoreDataAdditions sharedInstance] getAllDocuments:@"BussinessFavorite" sortByKey:@"specialCouponSentCount" withPredicate:recommendationPredicate whetherAscendingOrder:YES];
    return recommendationsListArray;
}
#pragma mark - Delete All Recommendations

+ (void)deleteAllEntries {
    [[CLCoreDataAdditions sharedInstance] deleteAllEntities:@"BussinessFavorite"];
    [[CLCoreDataAdditions sharedInstance] saveEntity];
}


@end
