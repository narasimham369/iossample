//
//  States.m
//  DirectoryApp
//
//  Created by Vishnu KM on 27/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "States.h"
#import <UIKit/UIKit.h>
#import <CLToolKit/CLCoreDataAdditions.h>

@implementation States

+ (void)saveStatesDetails:(NSArray *)detailsArray withCountry:(NSString *)country{
    for (int i = 0; i<detailsArray.count; i++) {
        id statesData = [detailsArray objectAtIndex:i];
        States *states = [self getStatesWithStateId:[statesData valueForKey:@"state_id"]];
        if(states == nil )
            states = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"States"];
        if(![[statesData valueForKey:@"state_id"]isEqual:[NSNull null]])
            states.stateId= [[statesData valueForKey:@"state_id"] intValue];
        if(![[statesData valueForKey:@"state_name"]isEqual:[NSNull null]])
            states.stateName = [NSString stringWithFormat:@"%@",[statesData valueForKey:@"state_name"]];
        states.countryCode = [country intValue];
        [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
}

#pragma mark - GET States

+ (NSArray *)getStatesWithCountryCode:(NSNumber *)countryID {
    NSPredicate *myStatePredicate = [NSPredicate predicateWithFormat:@"SELF.countryCode == %@",countryID];
    NSArray *detailArrayStates = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"States" withPredicate:myStatePredicate];
    if (detailArrayStates.count != 0) {
        return detailArrayStates;
    }
    return nil;
}


+(States *)getStatesWithStateId:(NSNumber *)stateID{
    NSPredicate *myStatePredicate = [NSPredicate predicateWithFormat:@"SELF.stateId == %@",stateID];
    NSArray *myStateArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"States" withPredicate:myStatePredicate];
    if(myStateArray.count>0)
        return [myStateArray firstObject];
    else
        return nil;
}


@end
