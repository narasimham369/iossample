//
//  SurpriseBox.m
//  DirectoryApp
//
//  Created by Vishnu KM on 07/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "SurpriseBox.h"
#import <UIKit/UIKit.h>
#import <CLToolKit/CLCoreDataAdditions.h>


@implementation SurpriseBox

+ (void)saveSurpriseBoxDetails:(NSArray *)detailsArray{
    for (int i = 0; i<detailsArray.count; i++) {
        id surpriseBox = [detailsArray objectAtIndex:i];
        SurpriseBox *box = [self getSurpriseBoxDataWithUserId:[surpriseBox valueForKey:@"id"] :[surpriseBox valueForKey:@"notificationType"]];
        if(box == nil )
            box = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"SurpriseBox"];
        if(![[surpriseBox valueForKey:@"business_id"]isEqual:[NSNull null]])
            box.business_id= [[surpriseBox valueForKey:@"business_id"] intValue];
        if(![[surpriseBox valueForKey:@"favorite_spot_count"]isEqual:[NSNull null]])
           box.favorite_spot_count= [[surpriseBox valueForKey:@"favorite_spot_count"] intValue];
        if(![[surpriseBox valueForKey:@"id"]isEqual:[NSNull null]])
            box.id= [[surpriseBox valueForKey:@"id"] intValue];
        if(![[surpriseBox valueForKey:@"user_id"]isEqual:[NSNull null]])
            box.user_id= [[surpriseBox valueForKey:@"user_id"] intValue];
        if(![[surpriseBox valueForKey:@"couponId"]isEqual:[NSNull null]])
            box.couponid= [[surpriseBox valueForKey:@"couponId"] intValue];
        if(![[surpriseBox valueForKey:@"available_date"]isEqual:[NSNull null]])
            box.available_date= [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"available_date"]];
        if(![[surpriseBox valueForKey:@"recommentation_count"]isEqual:[NSNull null]])
            box.recommentation_count= [[surpriseBox valueForKey:@"recommentation_count"] intValue];
        if(![[surpriseBox valueForKey:@"review_count"]isEqual:[NSNull null]])
            box.review_count= [[surpriseBox valueForKey:@"review_count"] intValue];
        if(![[surpriseBox valueForKey:@"business_address"]isEqual:[NSNull null]])
            box.business_address = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"business_address"]];
        if(![[surpriseBox valueForKey:@"city"]isEqual:[NSNull null]])
            box.city = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"city"]];
        if(![[surpriseBox valueForKey:@"state_name"]isEqual:[NSNull null]])
            box.state_name = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"state_name"]];
        if(![[surpriseBox valueForKey:@"business_name"]isEqual:[NSNull null]])
            box.business_name = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"business_name"]];
        if(![[surpriseBox valueForKey:@"business_phone"]isEqual:[NSNull null]])
           box.business_phone = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"business_phone"]];
        if(![[surpriseBox valueForKey:@"description"]isEqual:[NSNull null]])
           box.descriptionDetails = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"description"]];
        if(![[surpriseBox valueForKey:@"expiry_date"]isEqual:[NSNull null]])
            box.expiry_date = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"expiry_date"]];
        if(![[surpriseBox valueForKey:@"name"]isEqual:[NSNull null]])
            box.name = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"name"]];
       if(![[surpriseBox valueForKey:@"savedStatus"]isEqual:[NSNull null]])
            box.savedStatus = [[surpriseBox valueForKey:@"savedStatus"]boolValue ];
        if(![[surpriseBox valueForKey:@"notificationType"]isEqual:[NSNull null]])
            box.notificationType = [[surpriseBox valueForKey:@"notificationType"]intValue ];
        if(![[surpriseBox valueForKey:@"street"]isEqual:[NSNull null]])
            box.street = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"street"]];
        if(![[surpriseBox valueForKey:@"user_image_cache"]isEqual:[NSNull null]])
            box.user_image_cache = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"user_image_cache"]];
        if(![[surpriseBox valueForKey:@"business_image_cache"]isEqual:[NSNull null]])
            box.business_image_cache = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"business_image_cache"]];
        if(![[surpriseBox valueForKey:@"notificationTime"]isEqual:[NSNull null]])
            box.notificationTime =[[surpriseBox valueForKey:@"notificationTime"] longLongValue];
        if(![[surpriseBox valueForKey:@"notificationStatus"]isEqual:[NSNull null]])
            box.notificationStatus =[[surpriseBox valueForKey:@"notificationStatus"] boolValue];
        if(![[surpriseBox valueForKey:@"recommendedUser"]isEqual:[NSNull null]])
            box.recommendedUser = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"recommendedUser"]];
        if(![[surpriseBox valueForKey:@"shared_user"]isEqual:[NSNull null]])
            box.shared_user = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"shared_user"]];
        if(![[surpriseBox valueForKey:@"shared_user_id"]isEqual:[NSNull null]])
            box.shared_user_id= [[surpriseBox valueForKey:@"shared_user_id"] intValue];
        if(![[surpriseBox valueForKey:@"shared_user_image_cache"]isEqual:[NSNull null]])
            box.shared_user_image_cache = [NSString stringWithFormat:@"%@",[surpriseBox valueForKey:@"shared_user_image_cache"]];
        if(![[surpriseBox valueForKey:@"files"]isEqual:[NSNull null]]){
            NSArray *fileNamesArray = [surpriseBox valueForKey:@"files"];
            if(fileNamesArray.count>0){
                if(![[fileNamesArray firstObject] isEqual:[NSNull null]]){
                    box.imageName = [NSString stringWithFormat:@"%@",[fileNamesArray firstObject]];
                }
            }
        }
        [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
    
}

#pragma mark - GET Categorylist

+ (NSArray *)getSurpriseBoxData {
    NSArray *surpriseBoxArray = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"SurpriseBox"];
    if (surpriseBoxArray.count != 0) {
        return surpriseBoxArray;
    }
    return nil;
}

+(void)updateSavedStatusWithCouponID:(NSNumber*)coupId{
    NSPredicate *updateStatusPredicate = [NSPredicate predicateWithFormat:@"SELF.couponid== %@",coupId];
    SurpriseBox *status = [[[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"SurpriseBox" withPredicate:updateStatusPredicate] firstObject];
    status.savedStatus = [[NSNumber numberWithInt:1] boolValue];
    [[CLCoreDataAdditions sharedInstance] saveEntity];
    
}

+(SurpriseBox *)getSurpriseBoxDataWithUserId:(NSNumber *)UserID :(NSNumber *)notificationType{
    NSPredicate *surpriseBoxListPredicate = [NSPredicate predicateWithFormat:@"SELF.id == %@&&SELF.notificationType == %@",UserID,notificationType];
    NSArray *surpriseBoxListArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"SurpriseBox" withPredicate:surpriseBoxListPredicate];
    if(surpriseBoxListArray.count>0)
        return [surpriseBoxListArray firstObject];
    else
        return nil;
}

#pragma mark - Delete Surprice Spot

+(void)RemoveSurpriceWithId:(NSNumber *)UserID :(NSNumber *)notificationType{
    NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"SELF.id == %@&&SELF.notificationType == %@",UserID,notificationType];
    NSArray *deleteArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"SurpriseBox" withPredicate:deletePredicate];
    if(deleteArray.count>0){
        [[CLCoreDataAdditions sharedInstance]deleteObject:[deleteArray firstObject]];
        [[CLCoreDataAdditions sharedInstance]saveEntity];
    }
}

#pragma mark - Delete All Offers

+ (void)deleteAllEntries {
    [[CLCoreDataAdditions sharedInstance] deleteAllEntities:@"SurpriseBox"];
    [[CLCoreDataAdditions sharedInstance] saveEntity];
}

@end
