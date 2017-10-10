//
//  CLTwitterWrapper.h
//  CLToolKit
//
//  Created by Aravind on 8/21/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
@interface CLTwitterWrapper : NSObject
+ (SLComposeViewController *)shareToTwitter:(NSString *) shareMessage withShareImage:(UIImage *) shareImage withShareUrl:(NSURL *) shareUrl;
@end
