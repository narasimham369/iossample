//
//  Utilities.h
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/23/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Utilities : NSObject
+ (Utilities *)standardUtilities;
-(void)clearAllLocalData;
-(void)showMessageAlertControllerInController:(UIViewController *)viewController withAlertMessage:(NSString *)alertMessage;
-(BOOL)checkWhetherTwoImagesAreSameWithImage1:(UIImage *)image1 nadImage2:(UIImage *)image2;
- (UIImage *)compressImage:(UIImage *)image;
-(void)handleApiFailureBlockInController:(UIViewController *)viewController withErrorResponse:(id)errorResponse andStatusCode:(int)statusCode;
-(void)getCountriesApiSuccessResponse:(void(^)(id repsonseObject))success andFailureResponse:(void(^)(id errorResponse, int statusCode))failure;
-(void)getStatesApiWithCountryid:(int)countryId SuccessResponse:(void(^)(id responseObject))succes andFailureresponse:(void(^)(id errorRespnse,int statusCode))failure;
-(NSDate *)dateStringFromDateInmilliseconds:(long long)dateInmilliseconds;
-(NSDate *)convertDate:(NSDate *)myDate;
-(void)getCategoryListApi:(void(^)(id repsonseObject))success andFailureResponse:(void(^)(id errorResponse, int statusCode))failure;
-(void)getSubCategoryListApi:(int)categoryId SuccessResponse:(void(^)(id responseObject))succes andFailureresponse:(void(^)(id errorRespnse,int statusCode))failure;
-(void)goingToSettingsPage;
- (void)goToCameraIsFromUser:(BOOL)isFromUser withSuccessBlock:(void(^)(BOOL isSuccess))response;
- (BOOL)gotoGalleryIsFromUser:(BOOL)isFromUser;
-(void)addGradientLayerTo:(UIView*)view;
-(NSString*)encodeDataFromString:(NSString*)string;
-(void)clearAllLocalDataFirstRegistration;
-(void)webViewContentApi;
@end
