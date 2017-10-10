//
//  Offers.m
//  DirectoryApp
//
//  Created by Vishnu KM on 01/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Offers.h"
#import <UIKit/UIKit.h>
#import <CLToolKit/CLCoreDataAdditions.h>

@implementation Offers

+ (void)saveOffersListDetails:(NSArray *)detailsArray{
    for (int i = 0; i<detailsArray.count; i++) {
        id offersList = [detailsArray objectAtIndex:i];
        Offers *list = [self getOfferssWithOfferId:[offersList valueForKey:@"id"]];
        if(list == nil )
            list = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"Offers"];
        if(![[offersList valueForKey:@"id"]isEqual:[NSNull null]])
            list.offerID= [[offersList valueForKey:@"id"] intValue];
        if(![[offersList valueForKey:@"name"]isEqual:[NSNull null]])
            list.offerName = [NSString stringWithFormat:@"%@",[offersList valueForKey:@"name"]];
        if(![[offersList valueForKey:@"description"]isEqual:[NSNull null]])
            list.offerDescription = [NSString stringWithFormat:@"%@",[offersList valueForKey:@"description"]];
        if(![[offersList valueForKey:@"available_date"]isEqual:[NSNull null]])
            list.availableDate = [NSString stringWithFormat:@"%@",[offersList valueForKey:@"available_date"]];
        if(![[offersList valueForKey:@"expiry_date"]isEqual:[NSNull null]]){
            list.expiryDate = [NSString stringWithFormat:@"%@",[offersList valueForKey:@"expiry_date"]];
        }else{
             list.expiryDate =@"";
        }
        if(![[offersList valueForKey:@"is_special_coupon"]isEqual:[NSNull null]])
            list.is_special_coupon = [[offersList valueForKey:@"is_special_coupon"]intValue];
        if(![[offersList valueForKey:@"files"]isEqual:[NSNull null]]){
            NSArray *fileNamesArray = [offersList valueForKey:@"files"];
            if(fileNamesArray.count>0){
                if(![[fileNamesArray firstObject] isEqual:[NSNull null]]){
                    list.firstImageFileName = [NSString stringWithFormat:@"%@",[fileNamesArray firstObject]];
                }
            }
        }
        
        [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
    
}

#pragma mark - GET Categorylist

+ (NSArray *)getOffersList {
    NSPredicate *myOffersListPredicate = [NSPredicate predicateWithFormat:@"SELF.is_special_coupon  == %@",[NSNumber numberWithInt:0]];
   NSArray *myOffersListArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"Offers" withPredicate:myOffersListPredicate];
    if (myOffersListArray.count != 0) {
        return myOffersListArray;
    }
    return nil;
}


+(Offers *)getOfferssWithOfferId:(NSNumber *)offerID{
    NSPredicate *myOffersListPredicate = [NSPredicate predicateWithFormat:@"SELF.offerID == %@",offerID];
    NSArray *myOffersListArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"Offers" withPredicate:myOffersListPredicate];
    if(myOffersListArray.count>0)
        return [myOffersListArray firstObject];
    else
        return nil;
}

+(void)saveOfferDetailsWithDataDictionary:(NSMutableDictionary *)dataDictionary{
    Offers *offer = [self getOfferssWithOfferId:[dataDictionary valueForKey:@"id"]];
    if(offer == nil )
        offer = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"Offers"];
    if([dataDictionary valueForKey:@"id"])
        offer.offerID = [[dataDictionary valueForKey:@"id"] intValue];
    if([dataDictionary valueForKey:@"name"])
        offer.offerName = [dataDictionary valueForKey:@"name"];
    if([dataDictionary valueForKey:@"description"])
        offer.offerDescription = [dataDictionary valueForKey:@"description"];
    if([dataDictionary valueForKey:@"available_date"])
        offer.availableDate = [dataDictionary valueForKey:@"available_date"];
    if([dataDictionary valueForKey:@"expiry_date"])
        offer.expiryDate = [dataDictionary valueForKey:@"expiry_date"];
    if([dataDictionary valueForKey:@"files"])
        offer.firstImageFileName = [dataDictionary valueForKey:@"files"];
    [[CLCoreDataAdditions sharedInstance] saveEntity];

}

+(void)deleteOfferWithOfferId:(NSNumber *)offerId{
    NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"SELF.offerID == %@",offerId];
    NSArray *deleteArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"Offers" withPredicate:deletePredicate];
    if(deleteArray.count>0){
        [[CLCoreDataAdditions sharedInstance]deleteObject:[deleteArray firstObject]];
        [[CLCoreDataAdditions sharedInstance]saveEntity];
    }
}

#pragma mark - Delete All Offers

+ (void)deleteAllEntries {
    [[CLCoreDataAdditions sharedInstance] deleteAllEntities:@"Offers"];
    [[CLCoreDataAdditions sharedInstance] saveEntity];
}


@end

