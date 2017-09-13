//
//  UserDetails.m
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/23/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "UserDetails.h"
#import <UIKit/UIKit.h>
#import <CLToolKit/CLCoreDataAdditions.h>

@implementation UserDetails

+ (void)saveUserDetails:(NSMutableDictionary *)detailsArray{
    UserDetails *user = [self getUser];
    if(user == nil )
        user = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"UserDetails"];
    
    if([detailsArray valueForKey:@"address"]){
        if(![[detailsArray valueForKey:@"address"]isEqual:[NSNull null]])
            user.address= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"address"]];
    }
    if([detailsArray valueForKey:@"blocking_reason"]){
        if(![[detailsArray valueForKey:@"blocking_reason"]isEqual:[NSNull null]])
            user.blocking_reason= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"blocking_reason"]];
    }
    if([detailsArray valueForKey:@"city"]){
        if(![[detailsArray valueForKey:@"city"]isEqual:[NSNull null]])
            user.city= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"city"]];
    }
    if([detailsArray valueForKey:@"dob"]){
        if(![[detailsArray valueForKey:@"dob"]isEqual:[NSNull null]])
            user.dob= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"dob"]];
    }
    if([detailsArray valueForKey:@"first_name"]){
        if(![[detailsArray valueForKey:@"first_name"]isEqual:[NSNull null]])
            user.first_name= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"first_name"]];
    }
    if([detailsArray valueForKey:@"gender"]){
        if(![[detailsArray valueForKey:@"gender"]isEqual:[NSNull null]])
            user.gender= [detailsArray valueForKey:@"gender"];
    }
    if([detailsArray valueForKey:@"last_name"]){
        if(![[detailsArray valueForKey:@"last_name"]isEqual:[NSNull null]])
            user.last_name= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"last_name"]];
    }
    if([detailsArray valueForKey:@"loginBySocialMedia"]){
        if(![[detailsArray valueForKey:@"loginBySocialMedia"]isEqual:[NSNull null]])
            user.loginBySocialMedia= [[detailsArray valueForKey:@"loginBySocialMedia"] intValue];
    }
    if([detailsArray valueForKey:@"password"]){
        if(![[detailsArray valueForKey:@"password"]isEqual:[NSNull null]])
            user.password= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"password"]];
    }
    if([detailsArray valueForKey:@"phone"]){
        if(![[detailsArray valueForKey:@"phone"]isEqual:[NSNull null]])
            user.phone= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"phone"]];
    }
    if([detailsArray valueForKey:@"registered_on"]){
        if(![[detailsArray valueForKey:@"registered_on"]isEqual:[NSNull null]])
            user.registered_on= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"registered_on"]];
    }
    if([detailsArray valueForKey:@"state_id"]){
        if(![[detailsArray valueForKey:@"state_id"]isEqual:[NSNull null]])
            user.state_id= [[detailsArray valueForKey:@"state_id"] intValue];
    }
    if([detailsArray valueForKey:@"status"]){
        if(![[detailsArray valueForKey:@"status"]isEqual:[NSNull null]])
            user.status= [[detailsArray valueForKey:@"status"] intValue];
    }
    if([detailsArray valueForKey:@"user_id"]){
        if(![[detailsArray valueForKey:@"user_id"]isEqual:[NSNull null]])
            user.user_id= [[detailsArray valueForKey:@"user_id"] intValue];
    }
    if([detailsArray valueForKey:@"user_role_id"]){
        if(![[detailsArray valueForKey:@"user_role_id"]isEqual:[NSNull null]])
            user.user_role_id= [[detailsArray valueForKey:@"user_role_id"] intValue];
    }
    if([detailsArray valueForKey:@"zip"]){
        if(![[detailsArray valueForKey:@"zip"]isEqual:[NSNull null]])
            user.zip= [NSString stringWithFormat:@"%@",[detailsArray valueForKey:@"zip"]];
    }
    
    [[CLCoreDataAdditions sharedInstance] saveEntity];
    
}

#pragma mark - Get Events by ProductID

+(UserDetails *)getUserForUserID:(NSString *)userid {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.user_id == %d ",[userid intValue]];
    NSArray *tempArray = [[CLCoreDataAdditions sharedInstance]getAllDocumentsFor:@"UserDetails" withPredicate:predicate];
    if(tempArray.count != 0)
        return [tempArray objectAtIndex:0];
    return nil;
}

#pragma mark - GET User

+ (UserDetails *)getUser {
    NSArray *detailArrayPost = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"UserDetails"];
    if (detailArrayPost.count != 0) {
        return [detailArrayPost objectAtIndex:0];
    }
    return nil;
}

#pragma mark - Delete All User

+ (void)deleteAllEntries {
    [[CLCoreDataAdditions sharedInstance] deleteAllEntities:@"UserDetails"];
    [[CLCoreDataAdditions sharedInstance] saveEntity];
}

@end
