//
//  NetworkHandler.h
//  NetworkHandler
//
//  Created by VK on 3/9/15.
//  Copyright (c) 2015 CL. All rights reserved.
//

#import <Foundation/Foundation.h>
//static NSString *BaseUrl = @"http://bizdir.pumexinfotech.com/BizDirectoryApp/";

//testing purpose
static NSString *BaseUrl = @"http://dev.glucommunity.com/BizDirectoryApp/";

//main server
//static NSString *BaseUrl = @"http://admin.glucommunity.com/BizDirectoryApp/";

static NSString *LoginUrl = @"login";
static NSString *UserRegisterUrl = @"userRegistration";
static NSString *GetCountriesUrl = @"getAllCountries";
static NSString *GetStatesUrl = @"getAllStates?country_id=";
static NSString *updateUserProfPic = @"updateProfileImage";
static NSString *GetMyFavouriteSpotUrl = @"getMyFavorites?user_id=";
static NSString *GetCategoryListUrl = @"getAllParentCategories";
static NSString *GetSubCategoryListUrl = @"/getSubCategories?parent_id=";
static NSString *BusinessRegisterUrl = @"businessRegistration";
static NSString *Businesssearch = @"search?";
static NSString *uploadBusinesslogoImageUrl =@"updateBusinessLogoImage";
static NSString *businessRegistration =@"businessUserRegistration";
static NSString *updateBusinessProfileUrl =@"updateBusinessProfile";
static NSString *GetSavedCoupons = @"getMySavedCoupons?user_id=";
static NSString *GetMyRecommendations = @"getMySurpriseCoupons?user_id=";
static NSString *GetOfferListByStatus = @"getOfferListWithSavedStatus?";
static NSString *resetPasswordUrl = @"updatePassword?";
static NSString *forgotPasswordUrl = @"forgotPassword?phoneorEmail=";
static NSString *saveOffer = @"saveOffer";
static NSString *updateOffer = @"updateOffer";
static NSString *deletOffer =@"deleteOffer?";
static NSString *saveUserCoupon =@"saveUserCoupon?";
static NSString *addFavorite =@"addFavorite?";
static NSString *getOfferList =@"getOfferList?";
static NSString *getBusinessDetails = @"getBusinessFullDetails?";
static NSString *getUserReviewsByPage = @"getBusinessReviewsByPage?";
static NSString *imageUrlForOffer = @"uploads/OfferImages/";
static NSString *imageUrlForBusinessUser = @"uploads/BusinessLogos/";
static NSString *imageUrlForCommonUser = @"uploads/ProfileImages/";
static NSString *getBusReccomenders = @"getRecommenders?";
static NSString *getBusFavoriters = @"getBusinessFavorites?";
static NSString *saveUserReview = @"saveUserReview";
static NSString *FavoriteStatus = @"getBusinessFullDetailsWithFavouritedStatus?";
static NSString *recommendBusiness = @"recommendBusinessToUsers";
static NSString *sayThanks = @"sayThanksToRecommendedUsers";
static NSString *sendSpecialCoupon = @"sendSpecialCouponToRecommendedUsers";
static NSString *saveUserClick = @"saveUserClick?";
static NSString *editprofile = @"updateUserProfile";
static NSString *editbusinessprofile = @"updateBusinessProfile";
static NSString *socialRegistration = @"socialMediaRegistration";
static NSString *removeFavorites = @"removeFavorites?";
static NSString *deleteSavedCoupon = @"deleteSavedCoupon?";
static NSString *sendSpecialCouponToFavoritedUsers = @"sendSpecialCouponToFavoritedUsers";
static NSString *sayThanksToFavoritedUsers = @"sayThanksToFavoritedUsers";
static NSString *updateDeviceTocken = @"updateDeviceTocken";
static NSString *editProfile = @"editProfile?";
static NSString *getRecommendedUsersPhoneAndEmail = @"getRecommendedUsersPhoneAndEmail?";
static NSString *shareCouponToUser = @"shareCouponToUser";
static NSString *getCouponSharedUsersPhoneAndEmail = @"getCouponSharedUsersPhoneAndEmail?";
static NSString *deleteNotification = @"deleteNotification?";
static NSString *readNotification = @"readNotification?";
static NSString *checkEmailExist = @"checkEmailExist?";
static NSString *checkPhoneExist = @"checkPhoneExist?";
static NSString *getSurpriseBoxCount = @"getSurpriseBoxCount?";
static NSString *getWebViewContent = @"getApplicationURLs";


typedef NS_ENUM(NSInteger, ABNBURLTYPE ){
    EGLUEURLTYPELOGIN = 1,
    EGLUEURLTYPEUSERREGISTER = 2,
    EGLUEURLTYPEGETCOUNTRIES = 3,
    EGLUEURLTYPEGETSTATES = 4,
    EGLUEURLTYPEGETMYFAVOURITESPOTS = 5,
    EGLUEURLTYPEGETCATEGORYLIST = 6,
    EGLUEURLTYPEGETSUBCATEGORYLIST = 7,
    EGLUEURLTYPEBUSINESSREGISTER = 8,
    EGLUEURLTYPEBUSINESEARCH = 9,
    EGLUEURLTYPEUPDATEBUSINESSPROFILE = 10,
    EGLUEURLTYPEGETSAVEDCOUPONS = 11,
    EGLUEURLTYPEGETMYRECOMMENDATIONS = 12,
    EGLUEURLTYPEGETOFFERLISTBYSTATUS = 13,
    EGLUEURLTYPEFORGOTPASSWORD = 14,
    EGLUEURLTYPERESETPASSWORD = 15,
    EGLUEURLTYPEDELETEOFFER = 16,
    EGLUEIMAGEURLFOROFFER = 100,
    EGLUEIMAGEURLFORBUSINESSUSER = 101,
    EGLUEIMAGEURLFORCOMMONUSERUSER = 102,
    GLUEIMAGEURLFORSAVECOUPON = 17,
    GLUEIMAGEURLFORADDFAVORITE = 18,
    EGLUEURLTYPEGETOFFERLIST = 19,
    EGLUEURLTYPEGETBUSINESSDETAILS = 20,
    EGLUEURLTYPEGETREVIEWS = 21,
    EGLUEURLTYPEGETBUSINESSRECCOMENDERS = 22,
    EGLUEURLTYPEGETBUSINESSFAVORITERS = 23,
    EGLUEURLTYPESAVEREVIEW = 24,
    EGLUEURLTYPEGETFAVORITEDETAILS = 25,
    EGLUEURLTYPERECOMMENDBUSINESS = 26,
    EGLUEURLTYPESAYTHANKS = 27,
    EGLUEURLTYPESENDSPECIALCOUPON = 28,
    EGLUEURLTYPESOCIALREGISTRATION = 30,
    EGLUEURLTYPESAVEUSER = 29,
    EGLUEURLTYPEEDITPROFILE = 31,
    EGLUEURLTYPEEDITBUSINESSPROFILE = 32,
    EGLUEURLTYPEREMOVEUSERFAVORITES = 33,
    EGLUEURLTYPEREMOVEUSERSAVEDCOUPON = 34,
    EGLUEURLTYPESENDFAVORITECOUPON = 35,
    EGLUEURLTYPESAYTHANKSFAVORITE = 36,
    EGLUEURLTYPEDEVICEREGISTRATION = 37,
    EGLUEURLTYPEGETPROFILE = 38,
    EGLUEURLTYPEGETRECOMENTUSERSLIST = 39,
    EGLUEURLTYPESHARECOUPON = 40,
    EGLUEURLTYPESHAREUSERSLIST = 41,
    EGLUEURLTYPEDELETESURPRICE = 42,
    EGLUEURLTYPEREADSURPRICE = 43,
    EGLUEURLTYPEEMAILCHECK = 44,
    EGLUEURLTYPEPHONECHECK = 45,
    EGLUEURLTYPESURPRICECOUNT = 46,
    EGLUEURLTYPEWEBVIEWCONTENT = 47,

};


@interface UrlGenerator : NSObject

+(UrlGenerator *) sharedHandler;
- (NSURL *)urlForRequestType:(ABNBURLTYPE) type withURLParameter:(NSString *)urlParameter;

@end
