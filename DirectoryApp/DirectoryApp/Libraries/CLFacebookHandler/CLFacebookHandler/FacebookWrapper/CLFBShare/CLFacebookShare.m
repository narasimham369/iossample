//
//  CLFacebookShare.m
//  TWExperience
//
//  Created by Jay Krish on 17/05/16.
//  Copyright © 2016 AkulaInternational. All rights reserved.
//

#import "CLFacebookShare.h"

#import <Social/Social.h>

@implementation CLFacebookShare

+ (CLFacebookShare *)shareHandler {
    static CLFacebookShare *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (id)shareToFacebook:(NSDictionary *)dataDictionary withComposerUI:(BOOL)isNeeded inViewController:(UIViewController *)viewController {
    if(isNeeded)
        return [self shareToFacebook:dataDictionary];
    else
        [self shareToFaceBookWithoutComposer:dataDictionary inViewController:viewController];
    return nil;
}

- (void)shareToFaceBookWithoutComposer:(NSDictionary *)dataDictionary inViewController:(UIViewController *)viewController {
    [[FacebookWrapper standardWrapper] publishStory:[dataDictionary valueForKey:@"Message"] inViewController:viewController completionHandler:^(BOOL result, NSError *error) {
        if(result) {
            if(self.CLShareDelegate && [self.CLShareDelegate respondsToSelector:@selector(CLFacebookShareViewItem:isSucces:withError:)]) {
                [self.CLShareDelegate CLFacebookShareViewItem:self isSucces:YES withError:nil];
            }
        }
        else {
            if(self.CLShareDelegate && [self.CLShareDelegate respondsToSelector:@selector(CLFacebookShareViewItem:isSucces:withError:)]) {
                [self.CLShareDelegate CLFacebookShareViewItem:self isSucces:NO withError:error.localizedDescription];
            }
        }
    }];
}


- (SLComposeViewController *)shareToFacebook:(NSDictionary *) dataDictionary {
    NSString * shareMessage = [dataDictionary valueForKey:@"Message"];
    UIImage * shareImage = [dataDictionary valueForKey:@"ShareImage"];
    NSURL * shareUrl = [dataDictionary valueForKey:@"ShareUrl"];
    
   // if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
     if(shareMessage)
        [facebookPost setInitialText:shareMessage];
    if(shareImage)
        [facebookPost addImage:shareImage];
    if(shareUrl)
        [facebookPost addURL:shareUrl];
        return facebookPost;
//    }
//    else
//        return nil;
}

@end
