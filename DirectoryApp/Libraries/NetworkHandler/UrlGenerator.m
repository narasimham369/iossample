//
//  NetworkHandler.h
//  NetworkHandler
//
//  Created by VK on 3/9/15.
//  Copyright (c) 2015 CL. All rights reserved.
//

#import "UrlGenerator.h"

@implementation UrlGenerator

+(UrlGenerator *) sharedHandler {
    static UrlGenerator *handler;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (NSURL *)urlForRequestType:(ABNBURLTYPE) type withURLParameter:(NSString *)urlParameter {
    NSString *appendingUrl;
    switch (type) {
        case EGLUEURLTYPELOGIN:
            appendingUrl = LoginUrl;
            break;
        case EGLUEURLTYPEUSERREGISTER:
            appendingUrl = UserRegisterUrl;
            break;
        case EGLUEURLTYPEGETCOUNTRIES:
            appendingUrl = GetCountriesUrl;
            break;
        case EGLUEURLTYPEGETSTATES:
            appendingUrl = [NSString stringWithFormat:@"%@%@",GetStatesUrl,urlParameter];
            break;
        case EGLUEURLTYPEGETMYFAVOURITESPOTS:
            appendingUrl = [NSString stringWithFormat:@"%@%@",GetMyFavouriteSpotUrl,urlParameter];
            break;
        case EGLUEURLTYPEGETCATEGORYLIST:
            appendingUrl = GetCategoryListUrl;
            break;
        case EGLUEURLTYPEGETSUBCATEGORYLIST:
            appendingUrl = [NSString stringWithFormat:@"%@%@",GetSubCategoryListUrl,urlParameter];
            break;
        case EGLUEURLTYPEBUSINESSREGISTER:
            appendingUrl = BusinessRegisterUrl;
            break;
        case EGLUEURLTYPEBUSINESEARCH:
            appendingUrl = [NSString stringWithFormat:@"%@%@",Businesssearch,urlParameter];
            break;
        case EGLUEURLTYPEUPDATEBUSINESSPROFILE:
            appendingUrl = updateBusinessProfileUrl;
            break;
        case EGLUEURLTYPEGETSAVEDCOUPONS:
            appendingUrl = [NSString stringWithFormat:@"%@%@",GetSavedCoupons,urlParameter];
            break;
        case EGLUEURLTYPEGETMYRECOMMENDATIONS:
            appendingUrl = [NSString stringWithFormat:@"%@%@",GetMyRecommendations,urlParameter];
            break;
        case EGLUEURLTYPEGETOFFERLISTBYSTATUS:
            appendingUrl = [NSString stringWithFormat:@"%@%@",GetOfferListByStatus,urlParameter];
            break;
        case EGLUEURLTYPEFORGOTPASSWORD:
            appendingUrl = [NSString stringWithFormat:@"%@%@",forgotPasswordUrl,urlParameter];
            break;
        case EGLUEURLTYPERESETPASSWORD:
            appendingUrl = [NSString stringWithFormat:@"%@%@",resetPasswordUrl,urlParameter];
            break;
        case EGLUEURLTYPEDELETEOFFER:
            appendingUrl = [NSString stringWithFormat:@"%@%@",deletOffer,urlParameter];
            break;
            
        case EGLUEIMAGEURLFOROFFER:
            appendingUrl = [NSString stringWithFormat:@"%@%@",imageUrlForOffer,urlParameter];
            break;
        case EGLUEIMAGEURLFORBUSINESSUSER:
            appendingUrl = [NSString stringWithFormat:@"%@%@",imageUrlForBusinessUser,urlParameter];
            break;
        case GLUEIMAGEURLFORSAVECOUPON:
            appendingUrl = [NSString stringWithFormat:@"%@%@",saveUserCoupon,urlParameter];
            break;
        case GLUEIMAGEURLFORADDFAVORITE:
            appendingUrl = [NSString stringWithFormat:@"%@%@",addFavorite,urlParameter];
            break;
        case EGLUEURLTYPEGETOFFERLIST:
            appendingUrl = [NSString stringWithFormat:@"%@%@",getOfferList,urlParameter];
            break;
        case EGLUEURLTYPEGETBUSINESSDETAILS:
            appendingUrl = [NSString stringWithFormat:@"%@%@",getBusinessDetails,urlParameter];
            break;
        case EGLUEIMAGEURLFORCOMMONUSERUSER:
            appendingUrl = [NSString stringWithFormat:@"%@%@",imageUrlForCommonUser,urlParameter];
            break;
        case EGLUEURLTYPEGETREVIEWS:
            appendingUrl = [NSString stringWithFormat:@"%@%@",getUserReviewsByPage,urlParameter];
            break;
        case EGLUEURLTYPEGETBUSINESSRECCOMENDERS:
            appendingUrl = [NSString stringWithFormat:@"%@%@",getBusReccomenders,urlParameter];
            break;
        case EGLUEURLTYPEGETBUSINESSFAVORITERS:
            appendingUrl = [NSString stringWithFormat:@"%@%@",getBusFavoriters,urlParameter];
            break;
        case EGLUEURLTYPESAVEUSER:
            appendingUrl = [NSString stringWithFormat:@"%@%@",saveUserClick,urlParameter];
            break;
        case EGLUEURLTYPESAVEREVIEW:
            appendingUrl = saveUserReview;
            break;
        case EGLUEURLTYPEGETFAVORITEDETAILS:
            appendingUrl = [NSString stringWithFormat:@"%@%@",FavoriteStatus,urlParameter];
            break;
        case EGLUEURLTYPERECOMMENDBUSINESS:
            appendingUrl = [NSString stringWithFormat:@"%@",recommendBusiness];
            break;
        case EGLUEURLTYPESAYTHANKS:
            appendingUrl = sayThanks;
            break;
        case EGLUEURLTYPESENDSPECIALCOUPON:
            appendingUrl = sendSpecialCoupon;
            break;
        case EGLUEURLTYPESOCIALREGISTRATION:
            appendingUrl = socialRegistration;
            break;
        case EGLUEURLTYPEEDITPROFILE:
            appendingUrl = [NSString stringWithFormat:@"%@",editprofile];
            break;
        case EGLUEURLTYPEEDITBUSINESSPROFILE:
            appendingUrl = [NSString stringWithFormat:@"%@",editbusinessprofile];
            break;
        case EGLUEURLTYPEREMOVEUSERFAVORITES:
            appendingUrl = [NSString stringWithFormat:@"%@%@",removeFavorites,urlParameter];
            break;
        case EGLUEURLTYPEREMOVEUSERSAVEDCOUPON:
            appendingUrl = [NSString stringWithFormat:@"%@%@",deleteSavedCoupon,urlParameter];
            break;
        case EGLUEURLTYPESENDFAVORITECOUPON:
            appendingUrl = sendSpecialCouponToFavoritedUsers;
            break;
        case EGLUEURLTYPEDEVICEREGISTRATION:
            appendingUrl = updateDeviceTocken;
            break;
        case EGLUEURLTYPEGETPROFILE:
            appendingUrl = [NSString stringWithFormat:@"%@%@",editProfile,urlParameter];
            break;
        case EGLUEURLTYPEGETRECOMENTUSERSLIST:
            appendingUrl = [NSString stringWithFormat:@"%@%@",getRecommendedUsersPhoneAndEmail,urlParameter];
            break;
        case EGLUEURLTYPESHAREUSERSLIST:
            appendingUrl = [NSString stringWithFormat:@"%@%@",getCouponSharedUsersPhoneAndEmail,urlParameter];
            break;
        case EGLUEURLTYPEDELETESURPRICE:
            appendingUrl = [NSString stringWithFormat:@"%@%@",deleteNotification,urlParameter];
            break;
        case EGLUEURLTYPEREADSURPRICE:
            appendingUrl = [NSString stringWithFormat:@"%@%@",readNotification,urlParameter];
            break;
        case EGLUEURLTYPESHARECOUPON:
            appendingUrl = [NSString stringWithFormat:@"%@",shareCouponToUser];
            break;
        case EGLUEURLTYPEEMAILCHECK:
            appendingUrl = [NSString stringWithFormat:@"%@%@",checkEmailExist,urlParameter];
            break;
        case EGLUEURLTYPEPHONECHECK:
            appendingUrl = [NSString stringWithFormat:@"%@%@",checkPhoneExist,urlParameter];
            break;
        case EGLUEURLTYPESURPRICECOUNT:
            appendingUrl = [NSString stringWithFormat:@"%@%@",getSurpriseBoxCount,urlParameter];
            break;
        case EGLUEURLTYPESAYTHANKSFAVORITE:
            appendingUrl = sayThanksToFavoritedUsers;
            break;
        case EGLUEURLTYPEWEBVIEWCONTENT:
            appendingUrl = [NSString stringWithFormat:@"%@",getWebViewContent];
            break;
        default:
            break;
    }
    if([appendingUrl rangeOfString:@"%"].location != NSNotFound) {
        return [NSURL URLWithString:[BaseUrl stringByAppendingString:appendingUrl]] ;
    }
    return [NSURL URLWithString:[[BaseUrl stringByAppendingString:appendingUrl] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
}

@end
