//
//  LocationHandler.h
//
//  Created by Vaisakh Krishnan on 08/01/16.
//  Copyright © 2016 CL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@protocol LocationHandlerDelegate ;

@interface LocationHandler : NSObject

+(LocationHandler *) sharedHandler;

- (NSString *)getState;
- (NSString *)getCountry;
- (NSString *)getStreet;
- (NSString *)getCountryCode;
- (NSString *)getLatitude;
- (NSString *)getLongitude;
- (NSString *)getAltitude;
- (NSString *)getPostelCode;
- (NSString *)getCity;
- (void)startLocationUpdate;
- (BOOL)isLocationServiceEnabled;
- (void)startLocationServiceinViewController:(UIViewController *)viewController;
- (void)checkLocationServiceEnabledInViewController:(UIViewController *) viewController WithSucessBlockSuccessBlock:(void (^)( BOOL isSuccess))success;

@property (nonatomic,strong) id<LocationHandlerDelegate>locationHandlerDelegate;

@end

@protocol LocationHandlerDelegate <NSObject>

- (void)locationHandlerData:(LocationHandler *)locationHandler withLocationDetails:(id)locationDetails;

@end
