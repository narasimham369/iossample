//
//  BusinessUser.m
//  DirectoryApp
//
//  Created by Bibin Mathew on 3/2/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Utilities.h"
#import "BusinessUser.h"
#import <CLToolKit/CLCoreDataAdditions.h>

@implementation BusinessUser

+ (void)saveUserDetails:(NSMutableDictionary *)detailsArray{
    BusinessUser *user = [self getBusinessWithBusinessId:[detailsArray valueForKey:@"business_id"]];
    if(user == nil ){
        user = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"BusinessUser"];
    }
    if([detailsArray valueForKey:@"address"]){
        if(![[detailsArray valueForKey:@"address"]isEqual:[NSNull null]])
            user.address= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"address"]];
    }
    if([detailsArray valueForKey:@"street"]){
        if(![[detailsArray valueForKey:@"street"]isEqual:[NSNull null]])
            user.street= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"street"]];
    }
    if([detailsArray valueForKey:@"business_address"]){
        if(![[detailsArray valueForKey:@"business_address"]isEqual:[NSNull null]])
            user.address= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"business_address"]];
    }
    if([detailsArray valueForKey:@"blocking_reason"]){
        if(![[detailsArray valueForKey:@"blocking_reason"]isEqual:[NSNull null]])
            user.blocking_reason= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"blocking_reason"]];
    }
    if([detailsArray valueForKey:@"business_name"]){
        if(![[detailsArray valueForKey:@"business_name"]isEqual:[NSNull null]])
            user.businessName= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"business_name"]];
    }
    if([detailsArray valueForKey:@"country_name"]){
        if(![[detailsArray valueForKey:@"country_name"]isEqual:[NSNull null]])
            user.countryName= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"country_name"]];
    }
    if([detailsArray valueForKey:@"city"]){
        if(![[detailsArray valueForKey:@"city"]isEqual:[NSNull null]])
            user.city= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"city"]];
    }
    if([detailsArray valueForKey:@"email"]){
        if(![[detailsArray valueForKey:@"email"]isEqual:[NSNull null]])
            user.email= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"email"]];
    }
    if([detailsArray valueForKey:@"state_name"]){
        if(![[detailsArray valueForKey:@"state_name"]isEqual:[NSNull null]])
            user.stateName= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"state_name"]];
    }
    if([detailsArray valueForKey:@"business_email"]){
        if(![[detailsArray valueForKey:@"business_email"]isEqual:[NSNull null]])
            user.email= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"business_email"]];
    }
    if([detailsArray valueForKey:@"first_name"]){
        if(![[detailsArray valueForKey:@"first_name"]isEqual:[NSNull null]])
            user.firstName= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"first_name"]];
    }
    
    if([detailsArray valueForKey:@"last_name"]){
        if(![[detailsArray valueForKey:@"last_name"]isEqual:[NSNull null]])
            user.lastName= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"last_name"]];
    }
    if([detailsArray valueForKey:@"latitude"]){
        if(![[detailsArray valueForKey:@"latitude"]isEqual:[NSNull null]])
            user.latitude= [[detailsArray valueForKey:@"latitude"] doubleValue];
    }
    if([detailsArray valueForKey:@"loginBySocialMedia"]){
        if(![[detailsArray valueForKey:@"loginBySocialMedia"]isEqual:[NSNull null]])
            user.loginBySocialMedia= [[detailsArray valueForKey:@"loginBySocialMedia"] intValue];
    }
    if([detailsArray valueForKey:@"longitude"]){
        if(![[detailsArray valueForKey:@"longitude"]isEqual:[NSNull null]])
            user.longitude= [[detailsArray valueForKey:@"longitude"] doubleValue];
    }
    if([detailsArray valueForKey:@"password"]){
        if(![[detailsArray valueForKey:@"password"]isEqual:[NSNull null]])
            user.password= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"password"]];
    }
    if([detailsArray valueForKey:@"opening_time"]){
        if(![[detailsArray valueForKey:@"opening_time"]isEqual:[NSNull null]])
            user.openingTime= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"opening_time"]];
    }
    if([detailsArray valueForKey:@"closing_time"]){
        if(![[detailsArray valueForKey:@"closing_time"]isEqual:[NSNull null]])
            user.closingTime= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"closing_time"]];
    }
    if([detailsArray valueForKey:@"business_phone"]){
        if(![[detailsArray valueForKey:@"business_phone"]isEqual:[NSNull null]])
            user.phone= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"business_phone"]];
    }
    if([detailsArray valueForKey:@"subCategoryId"]){
        if(![[detailsArray valueForKey:@"subCategoryId"]isEqual:[NSNull null]])
            user.subCategoryId= [[detailsArray valueForKey:@"subCategoryId"] intValue];
    }
    if([detailsArray valueForKey:@"business_image_cache"]){
        if(![[detailsArray valueForKey:@"business_image_cache"]isEqual:[NSNull null]])
            user.business_image_cache=[NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"business_image_cache"]];
            }
    if([detailsArray valueForKey:@"country_id"]){
        if(![[detailsArray valueForKey:@"country_id"]isEqual:[NSNull null]])
            user.country_id= [[detailsArray valueForKey:@"country_id"] intValue];
    }
    if([detailsArray valueForKey:@"favorite_spot_count"]){
        if(![[detailsArray valueForKey:@"favorite_spot_count"]isEqual:[NSNull null]])
            user.favoriteCount= [[detailsArray valueForKey:@"favorite_spot_count"] intValue];
    }
    if([detailsArray valueForKey:@"recommentation_count"]){
        if(![[detailsArray valueForKey:@"recommentation_count"]isEqual:[NSNull null]])
            user.recommendCount= [[detailsArray valueForKey:@"recommentation_count"] intValue];
    }
    if([detailsArray valueForKey:@"review_count"]){
        if(![[detailsArray valueForKey:@"review_count"]isEqual:[NSNull null]])
            user.reviewCount= [[detailsArray valueForKey:@"review_count"] intValue];
    }
    if([detailsArray valueForKey:@"registered_on"]){
        if(![[detailsArray valueForKey:@"registered_on"]isEqual:[NSNull null]])
            user.registered_on= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"registered_on"]];
    }
    if([detailsArray valueForKey:@"state_id"]){
        if(![[detailsArray valueForKey:@"state_id"]isEqual:[NSNull null]])
            user.state_id= [[detailsArray valueForKey:@"state_id"] intValue];
    }
    if([detailsArray valueForKey:@"business_id"]){
        if(![[detailsArray valueForKey:@"business_id"]isEqual:[NSNull null]])
            user.business_id= [[detailsArray valueForKey:@"business_id"] intValue];
    }
    if([detailsArray valueForKey:@"user_id"]){
        if(![[detailsArray valueForKey:@"user_id"]isEqual:[NSNull null]])
            user.bus_user_id= [[detailsArray valueForKey:@"user_id"] intValue];
    }
    if([detailsArray valueForKey:@"mainCategoryId"]){
        if(![[detailsArray valueForKey:@"mainCategoryId"]isEqual:[NSNull null]])
            user.mainCategoryId= [[detailsArray valueForKey:@"mainCategoryId"] intValue];
    }
    if([detailsArray valueForKey:@"mainCategoryName"]){
        if(![[detailsArray valueForKey:@"mainCategoryName"]isEqual:[NSNull null]])
            user.mainCategoryName= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"mainCategoryName"]];
    }

    if([detailsArray valueForKey:@"zip"]){
        if(![[detailsArray valueForKey:@"zip"]isEqual:[NSNull null]])
            user.zipCode= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"zip"]];
    }
    if([detailsArray valueForKey:@"subCategoryName"]){
        if(![[detailsArray valueForKey:@"subCategoryName"]isEqual:[NSNull null]])
            user.subCategoryName= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"subCategoryName"]];
    }
    
    [[CLCoreDataAdditions sharedInstance] saveEntity];
    
}

#pragma mark - GET Business User

+ (BusinessUser *)getUser {
    NSArray *detailArrayPost = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"BusinessUser"];
    if (detailArrayPost.count != 0) {
        return [detailArrayPost objectAtIndex:0];
    }
    return nil;
}

+(void)saveBusinessuserToLocalDbWithDataDictionary:(NSMutableDictionary *)dataDictionary{
    BusinessUser *businessUser = [self getBusinessWithBusinessId:[dataDictionary valueForKey:@"business_id"]];
    if(businessUser == nil){
        businessUser = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"BusinessUser"];
    }
    businessUser.business_id = [[dataDictionary valueForKey:@"business_id"] intValue];
    businessUser.bus_user_id = [[dataDictionary valueForKey:@"user_id"] intValue];
    if([dataDictionary valueForKey:@"firstName"]){
        if(![[dataDictionary valueForKey:@"firstName"]isEqual:[NSNull null]])
            businessUser.firstName = [dataDictionary valueForKey:@"firstName"];
    }
    if([dataDictionary valueForKey:@"lastName"]){
        if(![[dataDictionary valueForKey:@"lastName"]isEqual:[NSNull null]])
            businessUser.lastName = [dataDictionary valueForKey:@"lastName"];
    }
    if([dataDictionary valueForKey:@"businessName"]){
        if(![[dataDictionary valueForKey:@"businessName"]isEqual:[NSNull null]])
            businessUser.businessName = [dataDictionary valueForKey:@"businessName"];
    }
    if([dataDictionary valueForKey:@"countryName"]){
        if(![[dataDictionary valueForKey:@"countryName"]isEqual:[NSNull null]])
            businessUser.countryName = [dataDictionary valueForKey:@"countryName"];
    }
    if([dataDictionary valueForKey:@"state_name"]){
        if(![[dataDictionary valueForKey:@"state_name"]isEqual:[NSNull null]])
            businessUser.stateName = [dataDictionary valueForKey:@"state_name"];
    }
    if([dataDictionary valueForKey:@"subCategoryName"]){
        if(![[dataDictionary valueForKey:@"subCategoryName"]isEqual:[NSNull null]])
            businessUser.subCategoryName = [dataDictionary valueForKey:@"subCategoryName"];
    }
    if([dataDictionary valueForKey:@"mainCategoryName"]){
        if(![[dataDictionary valueForKey:@"mainCategoryName"]isEqual:[NSNull null]])
            businessUser.mainCategoryName = [dataDictionary valueForKey:@"mainCategoryName"];
    } if([dataDictionary valueForKey:@"street"]){
        if(![[dataDictionary valueForKey:@"street"]isEqual:[NSNull null]])
            businessUser.street= [NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"street"]];
    }
    if([dataDictionary valueForKey:@"address"]){
        if(![[dataDictionary valueForKey:@"address"]isEqual:[NSNull null]])
            businessUser.address = [dataDictionary valueForKey:@"address"];
    }
    if([dataDictionary valueForKey:@"countryId"]){
        if(![[dataDictionary valueForKey:@"countryId"]isEqual:[NSNull null]])
            businessUser.country_id = [[dataDictionary valueForKey:@"countryId"] intValue];
        
    }
    if([dataDictionary valueForKey:@"mainCategoryId"]){
        if(![[dataDictionary valueForKey:@"mainCategoryId"]isEqual:[NSNull null]])
            businessUser.mainCategoryId = [[dataDictionary valueForKey:@"mainCategoryId"] intValue];
        
    }
    if([dataDictionary valueForKey:@"subCategoryId"]){
        if(![[dataDictionary valueForKey:@"subCategoryId"]isEqual:[NSNull null]])
            businessUser.subCategoryId = [[dataDictionary valueForKey:@"subCategoryId"] intValue];
        
    }
    if([dataDictionary valueForKey:@"zip"]){
        if(![[dataDictionary valueForKey:@"zip"]isEqual:[NSNull null]])
            businessUser.zipCode = [dataDictionary valueForKey:@"zip"];
    }
    if([dataDictionary valueForKey:@"city"]){
        if(![[dataDictionary valueForKey:@"city"]isEqual:[NSNull null]])
            businessUser.city = [dataDictionary valueForKey:@"city"];
    }
    
    if([dataDictionary valueForKey:@"stateId"]){
        if(![[dataDictionary valueForKey:@"stateId"]isEqual:[NSNull null]])
            businessUser.state_id = [[dataDictionary valueForKey:@"stateId"] intValue];
    }
    if([dataDictionary valueForKey:@"phone"]){
        if(![[dataDictionary valueForKey:@"phone"]isEqual:[NSNull null]])
            businessUser.phone = [dataDictionary valueForKey:@"phone"] ;
    }
    if([dataDictionary valueForKey:@"email"]){
        if(![[dataDictionary valueForKey:@"email"]isEqual:[NSNull null]])
            businessUser.email = [dataDictionary valueForKey:@"email"] ;
    }
    if([dataDictionary valueForKey:@"password"]){
        if(![[dataDictionary valueForKey:@"password"]isEqual:[NSNull null]])
            businessUser.password = [dataDictionary valueForKey:@"password"] ;
    }
    if([dataDictionary valueForKey:@"openingTime"]){
        if(![[dataDictionary valueForKey:@"openingTime"]isEqual:[NSNull null]])
            businessUser.openingTime = [dataDictionary valueForKey:@"openingTime"] ;
    }

    if([dataDictionary valueForKey:@"closingTime"]){
        if(![[dataDictionary valueForKey:@"closingTime"]isEqual:[NSNull null]])
            businessUser.closingTime = [dataDictionary valueForKey:@"closingTime"] ;
    }

    if([dataDictionary valueForKey:@"latitude"]){
        if(![[dataDictionary valueForKey:@"latitude"]isEqual:[NSNull null]])
            businessUser.latitude = [[dataDictionary valueForKey:@"latitude"] doubleValue];
    }
    if([dataDictionary valueForKey:@"longitude"]){
        if(![[dataDictionary valueForKey:@"longitude"]isEqual:[NSNull null]]){
            businessUser.longitude = [[dataDictionary valueForKey:@"longitude"] doubleValue];
        }
        [[CLCoreDataAdditions sharedInstance]saveEntity];
    }
}
    +(BusinessUser *)getBusinessWithBusinessId:(NSNumber *)businessId{
        NSPredicate *businessPredicate = [NSPredicate predicateWithFormat:@"SELF.business_id==%@",businessId];
        NSArray *businessArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"BusinessUser" withPredicate:businessPredicate];
        if(businessArray.count>0)
            return [businessArray firstObject];
        else
            return nil;
    }
    
    +(BusinessUser *)getBusinessUser{
        NSArray *businessArray = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"BusinessUser"];
        return [businessArray firstObject];
    }
    
#pragma mark - Delete All User
    
    + (void)deleteAllEntries {
        [[CLCoreDataAdditions sharedInstance] deleteAllEntities:@"BusinessUser"];
        [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
    @end
