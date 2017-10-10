//
//  Utilities.m
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/23/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Constants.h"
#import "WebViewUrls.h"
#import "User.h"
#import "Offers.h"
#import "BusinessUser.h"
#import "CategoryList.h"
#import "SubCategories.h"
#import "MyFavouriteSpots.h"
#import "SurpriseBox.h"
#import "States.h"
#import "Countries.h"
#import "SavedCoupons.h"
#import "Utilities.h"
#import "UrlGenerator.h"
#import "NetworkHandler.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Racommendations.h"
#import "BussinessFavorite.h"
#import "SubCategories.h"
#import "CategoryList.h"


@implementation Utilities
+ (Utilities *)standardUtilities {
    static Utilities *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)showMessageAlertControllerInController:(UIViewController *)viewController withAlertMessage:(NSString *)alertMessage{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:AppName message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

-(BOOL)checkWhetherTwoImagesAreSameWithImage1:(UIImage *)image1 nadImage2:(UIImage *)image2{
    NSData *imageData1 = UIImagePNGRepresentation(image1);
    NSData *imageData2 = UIImagePNGRepresentation(image2);
    if([imageData1 isEqualToData:imageData2])
        return YES;
    else
        return NO;
}

-(void)addGradientLayerTo:(UIView*)view{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    UIColor *clear = [UIColor colorWithRed:90.0f / 255.0f green:229.0f / 255.0f blue:168.0f / 255.0f alpha:1.0f];
    UIColor *clear1 = [UIColor colorWithRed:36.0f / 255.0f green:189.0f / 255.0f blue:229.0f / 255.0f alpha:1.0f];
    
    gradientLayer.colors = @[ (__bridge id)clear.CGColor,(__bridge id)clear1.CGColor];
    
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    float width = [[UIScreen mainScreen] bounds].size.width;
    gradientLayer.frame = CGRectMake(0, 0, width, view.frame.size.height);
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

- (UIImage *)compressImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth) {
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}

-(void)handleApiFailureBlockInController:(UIViewController *)viewController withErrorResponse:(id)errorResponse andStatusCode:(int)statusCode{
    NSString *errorMessage = @"";
    if(statusCode == 1024){
        errorMessage = NetworkUnavailableMessage;
    }
    else{
        errorMessage = UnableToConnectServerMessage;
    }
    UIAlertController *errorAlertCntlr = [UIAlertController alertControllerWithTitle:AppName message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [errorAlertCntlr addAction:okAction];
    [viewController presentViewController:errorAlertCntlr animated:YES completion:nil];
}

#pragma mark - GetCountries Api call

-(void)getCountriesApiSuccessResponse:(void(^)(id repsonseObject))success andFailureResponse:(void(^)(id errorResponse, int statusCode))failure{
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETCOUNTRIES withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [Countries saveCountryDetails:[responseObject valueForKey:@"data"]];
        success(responseObject);
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        failure(errorResponseObject,statusCode);
    }];
}

-(void)clearAllLocalData{
    [User deleteAllEntries];
    [BusinessUser deleteAllEntries];
    [Offers deleteAllEntries];
    [MyFavouriteSpots deleteAllEntries];
    [SurpriseBox deleteAllEntries];
    [SavedCoupons deleteAllEntries];
    [Racommendations deleteAllEntries];
    [BussinessFavorite deleteAllEntries];
    [SubCategories deleteAllEntries];
    [CategoryList deleteAllEntries];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:-1] forKey:@"rowValue"];
}

#pragma mark - GetCountries Api call

-(void)getStatesApiWithCountryid:(int)countryId SuccessResponse:(void(^)(id responseObject))succes andFailureresponse:(void(^)(id errorRespnse,int statusCode))failure {
    NSString *urlParameter = [NSString stringWithFormat:@"%d",countryId];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETSTATES withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [States saveStatesDetails:[responseObject valueForKey:@"data"] withCountry:urlParameter];
        [States getStatesWithCountryCode:[NSNumber numberWithInt:1]];
        succes(responseObject);
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        failure(errorResponseObject,statusCode);
    }];
}

-(void)getCategoryListApi:(void(^)(id repsonseObject))success andFailureResponse:(void(^)(id errorResponse, int statusCode))failure{
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETCATEGORYLIST withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [CategoryList saveCategoryListDetails:[responseObject valueForKey:@"data"]];
         success(responseObject);
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
       failure(errorResponseObject,statusCode);
    }];
}

-(void)getSubCategoryListApi:(int)categoryId SuccessResponse:(void(^)(id responseObject))succes andFailureresponse:(void(^)(id errorRespnse,int statusCode))failure {
    NSString *urlParameter = [NSString stringWithFormat:@"%d", categoryId];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETSUBCATEGORYLIST withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [SubCategories saveSubCategoriesDetails:[responseObject valueForKey:@"data"]];
        succes(responseObject);
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
       failure(errorResponseObject,statusCode);
    }];
}
    
-(void)webViewContentApi{
        NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEWEBVIEWCONTENT withURLParameter:nil];
        NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
        [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
            [WebViewUrls saveUrlDetails:[responseObject valueForKey:@"data"]];
        } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        }];
        
    }

-(NSDate *)dateStringFromDateInmilliseconds:(long long)dateInmilliseconds{
    NSDate *dobdate = [NSDate dateWithTimeIntervalSince1970:dateInmilliseconds/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dobdate];
    NSDate *dt = [dateFormatter dateFromString:dateString];
    return dt;
}

-(NSDate *)convertDate:(NSDate *)myDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:myDate];
    NSDate *dt = [dateFormatter dateFromString:dateString];
    return dt;
}

-(void)goingToSettingsPage{
    BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
    if (canOpenSettings)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)goToCameraIsFromUser:(BOOL)isFromUser withSuccessBlock:(void(^)(BOOL isSuccess))response {
    __block BOOL isSuccess = false;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        isSuccess = true;
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined)  {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted) {
                isSuccess = true;
                
                
            }
            else {
                [self camDenied:isFromUser];
            }
            response(isSuccess);
        }];
    }
    else if (authStatus == AVAuthorizationStatusRestricted) {
        UIAlertView *cameraAlertView = [[UIAlertView alloc] initWithTitle:AppName message:@"You've been restricted from using the camera on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [cameraAlertView show];
    }
    else {
        [self camDenied:isFromUser];
    }
    response(isSuccess);
}

-(BOOL)gotoGalleryIsFromUser:(BOOL)isFromUser{
     ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status != ALAuthorizationStatusDenied) {
        //show alert for asking the user to give permission
        return YES;
    }
    else{
        [self galleryAccesDenied:isFromUser];
        return NO;
    }
}

- (void)camDenied:(BOOL)isFromUser {
    NSString *alertText;
    if(isFromUser)
        alertText = eglueCameraDisabledMessageForUser;
    else
        alertText = eglueCameraDisabledMessageForBusiness;
        UIAlertView *cameraAlert = [[UIAlertView alloc] initWithTitle:AppName message:alertText delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"OK", nil];
        cameraAlert.tag = 3001;
        dispatch_async(dispatch_get_main_queue(), ^{
            [cameraAlert show];
        });
}

-(void)galleryAccesDenied:(BOOL)isFromUser{
    NSString *alertText;
    if(isFromUser)
        alertText = galleryPhotosDisabledMessageForUser;
    else
        alertText = galleryPhotosDisabledMessageForBusiness;
    UIAlertView *cameraAlert = [[UIAlertView alloc] initWithTitle:AppName message:alertText delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"OK", nil];
    cameraAlert.tag = 3001;
    dispatch_async(dispatch_get_main_queue(), ^{
        [cameraAlert show];
    });

}
-(NSString*)encodeDataFromString:(NSString*)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *decodevalue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    return decodevalue;
}


#pragma mark -UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 3001 && buttonIndex == 1) {
        [self goingToSettingsPage];
    }
}
@end
