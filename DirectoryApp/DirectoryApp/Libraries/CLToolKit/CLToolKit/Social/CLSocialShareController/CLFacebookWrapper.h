//
//  CLFacebookWrapper.h
//  CLToolKit
//
//  Created by Aravind on 8/21/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>

@interface CLFacebookWrapper : NSObject

+ (SLComposeViewController *)shareToFacebook:(NSString *) shareMessage withShareImage:(UIImage *) shareImage withShareUrl:(NSURL *) shareUrl;

@end
