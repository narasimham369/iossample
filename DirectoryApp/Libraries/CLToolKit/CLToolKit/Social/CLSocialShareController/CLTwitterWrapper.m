//
//  CLTwitterWrapper.m
//  CLToolKit
//
//  Created by Aravind on 8/21/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "CLTwitterWrapper.h"

@implementation CLTwitterWrapper

+ (SLComposeViewController *)shareToTwitter:(NSString *) shareMessage withShareImage:(UIImage *) shareImage withShareUrl:(NSURL *) shareUrl{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:shareMessage];
        [tweetSheet addImage:shareImage];
        [tweetSheet addURL:shareUrl];
        return tweetSheet;

    }else
        return nil;
}

@end
