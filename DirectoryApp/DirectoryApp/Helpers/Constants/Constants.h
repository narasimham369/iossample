//
//  Constants.h
//  Ribbon
//
//  Created by Bibin Mathew (OLD) on 12/8/15.
//  Copyright © 2015 Bibin's Mac Mini(CL-003). All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppName @"Glu"
#define closeImageName @"closeIcon"
#define ProfileImagePlaceholder @"ProfilePlaceholder"


#pragma mark - Color codes

#define AppCommonBlueColor [UIColor colorWithRed:0.14 green:0.62 blue:0.91 alpha:1.0]//239fe9 - SkyBlue
#define AppCommonGrayColor [UIColor colorWithRed:0.68 green:0.69 blue:0.70 alpha:1.0];//adb1b2 - Cool Gray
#define AppButtonBackColor [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.0];//edeeef




#define isFacebookLogIn @"isFacebooklogin"
#define isWalkthroughVisited @"isVisitedWalkThrough"
#define isBusinessUser @"isBusUser"
#define isNormalUser @"isNormal"
#define isGuestUser @"isGuest"
#define isLoggedIn @"isLooggedIn"
#define deviceTokenKey @"deviceToken"

#define StatusBarheight [UIApplication sharedApplication].statusBarFrame.size.height


#define NetworkUnavailableMessage @"Network not available, Please connect to a network"

#define ErrorKey @"error"
#define StatusKey @"status"
#define ErrorCodeKey @"error_code"
#define StatusCodeKey @"statusCode"
#define StatusMessageKey @"statusMessage"
#define ErrorDescriptionKey @"error_description"

#define UnableToConnectServerMessage @"There was some problem processing your request. Please check your connectivity and try again."

static NSString *eglueCameraDisabledMessageForUser = @"eglue would like to access your Camera to Upload profile photo. Without camera access you would not be able to enjoy full features of the application.\n\n Would like to access the Camera?";
static NSString *eglueCameraDisabledMessageForBusiness = @"eglue would like to access your Camera to upload upload business logo and offer image. Would like to access the Camera?";

static NSString *contactListDisabledMessage = @"eglue would like to access your Contact list to recommend Business and share coupons with friends. Would you like to access Contact list";

static NSString *galleryPhotosDisabledMessageForUser = @"eglue would like to access your Gallery photos to upload profile photo. Would you like to access Gallery photos?";
static NSString *galleryPhotosDisabledMessageForBusiness = @"eglue would like to access your Gallery photos to upload business logo and offer image. Would you like to access Gallery photos";

#pragma mark - Error Codes

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6_OrLater ([[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_IPHONE_6_PlUS_Or_Later ([[UIScreen mainScreen] bounds].size.height > 667.0)


#pragma mark - Device Type

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)




#pragma mark - Notification Observer Names

static NSString *DirectoryShowHome = @"Com.directory.showHome";
static NSString *DirectoryShowBusImage = @"Com.directory.showBusImage";
static NSString *DirectoryShowUserImage = @"Com.directory.showUserImage";
