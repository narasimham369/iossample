//
//  Racommendations.m
//  DirectoryApp
//
//  Created by Bibin Mathew on 3/9/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Racommendations.h"
#import <CLToolKit/CLCoreDataAdditions.h>

@implementation Racommendations

+ (void)saveRecommendationsDetails:(NSArray *)detailsArray{
    [self deleteAllEntries];
    for (int i = 0; i<detailsArray.count; i++) {
        id recList = [detailsArray objectAtIndex:i];
        Racommendations *list = [self getRecommendationWithUserId:[recList valueForKey:@"user_id"]];
        if(list == nil )
            list = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"Racommendations"];
        if(![[recList valueForKey:@"recommendation_id"]isEqual:[NSNull null]])
            list.recommendation_id= [[recList valueForKey:@"recommendation_id"] intValue];
        if(![[recList valueForKey:@"user_id"]isEqual:[NSNull null]])
            list.user_id= [[recList valueForKey:@"user_id"] intValue];
        if(![[recList valueForKey:@"fullName"]isEqual:[NSNull null]])
            list.fullName = [NSString stringWithFormat:@"%@",[recList valueForKey:@"fullName"]];
        if(![[recList valueForKey:@"RecommendedOn"]isEqual:[NSNull null]])
            list.recemmendedTime = [[recList valueForKey:@"RecommendedOn"] doubleValue];
        if(![[recList valueForKey:@"userPhone"]isEqual:[NSNull null]])
            list.userPhone = [NSString stringWithFormat:@"%@",[recList valueForKey:@"userPhone"]];
        
        if(![[recList valueForKey:@"specialCouponSendStatus"]isEqual:[NSNull null]])
            list.isSpecialCouponSend = [[recList valueForKey:@"specialCouponSendStatus"] boolValue];
        if(![[recList valueForKey:@"specialCouponSentCount"]isEqual:[NSNull null]])
            list.specialCouponSentCount = [[recList valueForKey:@"specialCouponSentCount"] intValue];
        if(![[recList valueForKey:@"thanksSendStatus"]isEqual:[NSNull null]])
            list.isthanksSend = [[recList valueForKey:@"thanksSendStatus"] boolValue];
        if(![[recList valueForKey:@"thanksSendStatus"]isEqual:[NSNull null]])
            list.isthanksSend = [[recList valueForKey:@"thanksSendStatus"] boolValue];
        if(![[recList valueForKey:@"userEmail"]isEqual:[NSNull null]])
            list.userEmailId = [NSString stringWithFormat:@"%@",[recList valueForKey:@"userEmail"]];
        [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
}

+(Racommendations *)getRecommendationWithUserId:(NSNumber *)userId{
    NSPredicate *recommendationPredicate = [NSPredicate predicateWithFormat:@"SELF.user_id == %@",userId];
    NSArray *recommendationsArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"Racommendations" withPredicate:recommendationPredicate];
    if(recommendationsArray.count>0)
        return [recommendationsArray firstObject];
    else
        return nil;
}

+(NSArray *)getAllRecommendations{
    NSArray *recommendationsListArray = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"Racommendations"];
    recommendationsListArray = [[CLCoreDataAdditions sharedInstance] getAllDocuments:@"Racommendations" sortByKey:@"specialCouponSentCount" withPredicate:nil whetherAscendingOrder:YES];
    return recommendationsListArray;
}

+(NSArray *)getAllActiveUsers{
    NSPredicate *recommendationPredicate = [NSPredicate predicateWithFormat:@"SELF.specialCouponSentCount!= %@",[NSNumber numberWithInt:2]];
    NSArray *recommendationsListArray = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"Racommendations"];
    recommendationsListArray = [[CLCoreDataAdditions sharedInstance] getAllDocuments:@"Racommendations" sortByKey:@"specialCouponSentCount" withPredicate:recommendationPredicate whetherAscendingOrder:YES];
    return recommendationsListArray;
}

#pragma mark - Delete All Recommendations

+ (void)deleteAllEntries {
    [[CLCoreDataAdditions sharedInstance] deleteAllEntities:@"Racommendations"];
    [[CLCoreDataAdditions sharedInstance] saveEntity];
}

@end
