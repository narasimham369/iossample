//
//  LocationHandler.m
//  uQuote
//
//  Created by Vaisakh Krishnan on 08/01/16.
//  Copyright © 2016 CL. All rights reserved.
//

#import "LocationHandler.h"

#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import <CLToolKit/CLAlertHandler.h>

static NSString * VEACity = @"City";
static NSString * VEAState = @"State";
static NSString * VEAStreet = @"Street";
static NSString * VEACountry = @"Country";
static NSString * VEALatitude = @"Latitude";
static NSString * VEAAltitude = @"Altitude";
static NSString * VEALongitude =@"Longitude";
static NSString * VEALocality = @"Locality";
static NSString * VEAPostelCode = @"PostelCode";
static NSString * VEACountryCode = @"CountryCode";
static NSString * VEALocationCount = @"LocationCount";
static NSString * VEALocationUpdated = @"com.vea.locationUpdated";
static NSString *TWEEmptyLastName = @"Last Name is empty.";
static NSString *VEALocationDisabledMessage =  @"V-Guard would like to access your location to provide you better service. \n\n Do you want to enable Location service?";
static NSString *VEALocationEnabledMessage =  @"V-Guard would like to access your location to provide you better service. \n\n Do you want to enable Location service?";

@interface LocationHandler() <CLLocationManagerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation LocationHandler

+(LocationHandler *) sharedHandler {
    static LocationHandler *handler;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (void)startLocationServiceinViewController:(UIViewController *)viewController {
    if(self.locationManager == nil)
        self.locationManager = [[CLLocationManager alloc]init];
    int count = [[NSUserDefaults standardUserDefaults] valueForKey:VEALocationCount] == NULL? 0:[[[NSUserDefaults standardUserDefaults] valueForKey:VEALocationCount] intValue];
    
    if([CLLocationManager locationServicesEnabled]) {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
            if(count == 3) {
                [[CLAlertHandler standardHandler] showOkCancelAlert:VEALocationDisabledMessage title:@"" withSuccessButton:@"Allow" withCancelButton:@"Don't Allow" inContoller:viewController WithCompletionBlock:^(BOOL isSuccess) {
                    if(isSuccess) {
                        BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
                        if (canOpenSettings)
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }];
            } else {
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:count+1] forKey:VEALocationCount];
                [[CLAlertHandler standardHandler] showOkCancelAlert:VEALocationEnabledMessage title:VERANOPPNAME withSuccessButton:@"Allow" withCancelButton:@"Don't Allow" inContoller:viewController WithCompletionBlock:^(BOOL isSuccess){
                    if(isSuccess) {
                        BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
                        if (canOpenSettings)
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }];
            }
        } else {
            
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.activityType = CLActivityTypeFitness;
            self.locationManager.distanceFilter = 10; // meters
#ifdef __IPHONE_8_0
            NSUInteger code = [CLLocationManager authorizationStatus];
            if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
                if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                    [self.locationManager requestAlwaysAuthorization];
                } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                    [self.locationManager  requestWhenInUseAuthorization];
                } else {
                    NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
                }
            }
#endif
            [self.locationManager startUpdatingLocation];
            [self.locationManager  requestWhenInUseAuthorization];
        }
    }
}


- (void)checkLocationServiceEnabledInViewController:(UIViewController *) viewController WithSucessBlockSuccessBlock:(void (^)( BOOL isSuccess))success {
    int count = [[NSUserDefaults standardUserDefaults] valueForKey:VEALocationCount] == NULL? 0:[[[NSUserDefaults standardUserDefaults] valueForKey:VEALocationCount] intValue];
    if([CLLocationManager locationServicesEnabled]) {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
            if(count == 3) {
                [[CLAlertHandler standardHandler] showOkCancelAlert:VEALocationDisabledMessage title:VERANOPPNAME withSuccessButton:@"Allow" withCancelButton:@"Don't Allow" inContoller:viewController WithCompletionBlock:^(BOOL isSuccess) {
                    if(isSuccess) {
                        BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
                        if (canOpenSettings) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                            success(NO);
                        }
                    }else {
                        success(NO);
                    }
                }];
            } else {
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:count+1] forKey:VEALocationCount];
                [[CLAlertHandler standardHandler] showOkCancelAlert:VEALocationEnabledMessage title:VERANOPPNAME withSuccessButton:@"Allow" withCancelButton:@"Don't Allow" inContoller:viewController WithCompletionBlock:^(BOOL isSuccess) {
                    if(isSuccess) {
                        BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
                        if (canOpenSettings) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                            success(NO);
                        }
                    }else {
                        success(NO);
                    }
                }];
            }
        } else {
            success(YES);
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            //[self.locationManager startUpdatingLocation];
        }
    }
}

#pragma mark -

- (void)startLocationUpdate {
    //[self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

#pragma mark -

- (BOOL)isLocationServiceEnabled {
    return ([CLLocationManager authorizationStatus]== kCLAuthorizationStatusDenied);
}

#pragma mark - CLLocation manager Delegates

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            [self.locationManager stopUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            [self.locationManager startUpdatingLocation];
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = manager.location;
    CLLocationCoordinate2D coordinate =  location.coordinate;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:VEALatitude];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:VEALongitude];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",location.altitude] forKey:VEAAltitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude
                                                        longitude:coordinate.longitude];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        if (placemarks && placemarks.count > 0){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.locationManager stopUpdatingLocation];
            });
            
            CLPlacemark *placemark = [placemarks firstObject];
            
            NSDictionary *addressDictionary = placemark.addressDictionary;//structuredAddress
            [[NSUserDefaults standardUserDefaults] setObject:placemark.postalCode forKey:VEAPostelCode];
            [[NSUserDefaults standardUserDefaults] setObject:[addressDictionary valueForKey:@"State"] forKey:VEAState];
            [[NSUserDefaults standardUserDefaults] setObject:[addressDictionary valueForKey:@"Street"] forKey:VEAStreet];
            [[NSUserDefaults standardUserDefaults] setObject:[addressDictionary valueForKey:@"Country"] forKey:VEACountry];
            [[NSUserDefaults standardUserDefaults] setObject:[addressDictionary valueForKey:@"CountryCode"] forKey:VEACountryCode];
            [[NSUserDefaults standardUserDefaults] setObject:[addressDictionary valueForKey:@"City"] forKey:VEACity];
            [[NSNotificationCenter defaultCenter] postNotificationName:VEALocationUpdated object:nil];
            NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",coordinate.latitude],VEALatitude,[NSString stringWithFormat:@"%f",coordinate.longitude],VEALongitude,[NSString stringWithFormat:@"%@ %@",placemark.locality != nil?placemark.locality:placemark.subLocality, placemark.administrativeArea],VEALocality, nil];
            if(self.locationHandlerDelegate  && [self.locationHandlerDelegate respondsToSelector:@selector(locationHandlerData:withLocationDetails:)]) {
                [self.locationHandlerDelegate locationHandlerData:self withLocationDetails:dataDictionary];
            }
            
        }
    }];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - UIAlertView Delegates

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1002 && buttonIndex == 1) {
        BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
        if (canOpenSettings)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - Getters

- (NSString *)getLatitude {
    return [[NSUserDefaults standardUserDefaults] valueForKey:VEALatitude];
}

- (NSString *)getLongitude {
    return [[NSUserDefaults standardUserDefaults] valueForKey:VEALongitude];
}

- (NSString *)getAltitude {
    return [[NSUserDefaults standardUserDefaults] valueForKey:VEAAltitude];
}

- (NSString *)getPostelCode {
    return [[NSUserDefaults standardUserDefaults] valueForKey:VEAPostelCode];
}

- (NSString *)getState {
    return [[NSUserDefaults standardUserDefaults] valueForKey:VEAState];
}
- (NSString *)getCountry {
    return [[NSUserDefaults standardUserDefaults] valueForKey:VEACountry];
}
- (NSString *)getStreet {
    return [[NSUserDefaults standardUserDefaults] valueForKey:VEAStreet];
}
- (NSString *)getCountryCode {
    return [[NSUserDefaults standardUserDefaults] valueForKey:VEACountryCode];
}

- (NSString *)getCity {
    return [[NSUserDefaults standardUserDefaults]valueForKey:VEACity];
}

@end
