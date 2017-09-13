//
//  SavedCoupons.m
//  DirectoryApp
//
//  Created by Vishnu KM on 06/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "SavedCoupons.h"
#import <UIKit/UIKit.h>
#import <CLToolKit/CLCoreDataAdditions.h>

@implementation SavedCoupons

+ (void)savedCouponsDetails:(NSArray *)detailsArray{
    for (int i = 0; i<detailsArray.count; i++) {
        id couponList = [detailsArray objectAtIndex:i];
        SavedCoupons *coupons = [self getSavedCouponsWithId:[couponList valueForKey:@"id"]];
        if(coupons == nil )
            coupons = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"SavedCoupons"];
        if(![[couponList valueForKey:@"business_id"]isEqual:[NSNull null]])
            coupons.businessID= [[couponList valueForKey:@"business_id"] intValue];
        if(![[couponList valueForKey:@"coupon_code"]isEqual:[NSNull null]])
            coupons.couponCode= [[couponList valueForKey:@"coupon_code"] intValue];
        if(![[couponList valueForKey:@"id"]isEqual:[NSNull null]])
            coupons.id= [[couponList valueForKey:@"id"] intValue];
        if(![[couponList valueForKey:@"business_address"]isEqual:[NSNull null]])
            coupons.business_address= [NSString stringWithFormat:@"%@",[couponList valueForKey:@"business_address"]];
        if(![[couponList valueForKey:@"city"]isEqual:[NSNull null]])
            coupons.city= [NSString stringWithFormat:@"%@",[couponList valueForKey:@"city"]];
        if(![[couponList valueForKey:@"state_name"]isEqual:[NSNull null]])
            coupons.state_name= [NSString stringWithFormat:@"%@",[couponList valueForKey:@"state_name"]];
        if(![[couponList valueForKey:@"discount_rate"]isEqual:[NSNull null]])
            coupons.discountRate= [NSString stringWithFormat:@"%@",[couponList valueForKey:@"discount_rate"]];
        if(![[couponList valueForKey:@"type"]isEqual:[NSNull null]])
            coupons.type= [[couponList valueForKey:@"type"] intValue];
        if(![[couponList valueForKey:@"available_date"]isEqual:[NSNull null]])
            coupons.availableDate = [NSString stringWithFormat:@"%@",[couponList valueForKey:@"available_date"]];
        if(![[couponList valueForKey:@"created_on"]isEqual:[NSNull null]])
            coupons.createdOn = [NSString stringWithFormat:@"%@",[couponList valueForKey:@"created_on"]];
        if(![[couponList valueForKey:@"business_phone"]isEqual:[NSNull null]])
            coupons.business_phone = [NSString stringWithFormat:@"%@",[couponList valueForKey:@"business_phone"]];
        if(![[couponList valueForKey:@"description"]isEqual:[NSNull null]])
            coupons.couponDescription = [NSString stringWithFormat:@"%@",[couponList valueForKey:@"description"]];
        if(![[couponList valueForKey:@"name"]isEqual:[NSNull null]])
            coupons.couponName = [NSString stringWithFormat:@"%@",[couponList valueForKey:@"name"]];
        if(![[couponList valueForKey:@"expiry_date"]isEqual:[NSNull null]])
            coupons.expiryDate = [couponList valueForKey:@"expiry_date"];
        if(![[couponList valueForKey:@"saved_on"]isEqual:[NSNull null]])
            coupons.savedOn = [NSString stringWithFormat:@"%@",[couponList valueForKey:@"saved_on"]];
        if(![[couponList valueForKey:@"is_special_coupon"]isEqual:[NSNull null]])
            coupons.is_special_coupon = [[couponList valueForKey:@"is_special_coupon"] boolValue];
        if(![[couponList valueForKey:@"status"]isEqual:[NSNull null]])
            coupons.status = [[couponList valueForKey:@"status"]boolValue ];
        if(![[couponList valueForKey:@"street"]isEqual:[NSNull null]])
            coupons.street = [NSString stringWithFormat:@"%@",[couponList valueForKey:@"street"]];

        if(![[couponList valueForKey:@"files"]isEqual:[NSNull null]]){
            NSArray *fileNamesArray = [couponList valueForKey:@"files"];
            if(fileNamesArray.count>0){
                if(![[fileNamesArray firstObject] isEqual:[NSNull null]]){
                    coupons.firstImageFileName = [NSString stringWithFormat:@"%@",[fileNamesArray firstObject]];
                }
            }
        }

        [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
    
}

#pragma mark - GET Categorylist

+ (NSArray *)getSavedCoupons {
    NSArray *couponListArray = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"SavedCoupons"];
    if (couponListArray.count != 0) {
        return couponListArray;
    }
    return nil;
}


+(SavedCoupons *)getSavedCouponsWithId:(NSNumber *)couponID{
    NSPredicate *savedCouponsListPredicate = [NSPredicate predicateWithFormat:@"SELF.id == %@",couponID];
    NSArray *savedCouponsListArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"SavedCoupons" withPredicate:savedCouponsListPredicate];
    if(savedCouponsListArray.count>0)
        return [savedCouponsListArray firstObject];
    else
        return nil;
}

+(void)deleteOfferWithOfferId:(NSNumber *)CouponId{
    NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"SELF.id == %@",CouponId];
    NSArray *deleteArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"SavedCoupons" withPredicate:deletePredicate];
    if(deleteArray.count>0){
        [[CLCoreDataAdditions sharedInstance]deleteObject:[deleteArray firstObject]];
        [[CLCoreDataAdditions sharedInstance]saveEntity];
    }
}


#pragma mark - Delete All Offers

+ (void)deleteAllEntries {
    [[CLCoreDataAdditions sharedInstance] deleteAllEntities:@"SavedCoupons"];
    [[CLCoreDataAdditions sharedInstance] saveEntity];
}


@end



