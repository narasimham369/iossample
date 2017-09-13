//
//  CLFacebookWrapper.m
//  CLToolKit
//
//  Created by Aravind on 8/21/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "CLFacebookWrapper.h"

@implementation CLFacebookWrapper

+ (SLComposeViewController *)shareToFacebook:(NSString *) shareMessage withShareImage:(UIImage *) shareImage withShareUrl:(NSURL *) shareUrl{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookPost setInitialText:shareMessage];
        [facebookPost addImage:shareImage];
        [facebookPost addURL:shareUrl];
        return facebookPost;
    }
    else
        return nil;
}
@end
