//
//  CLSocialShareHandler.m
//  CLToolKit
//
//  Created by Vishakh Krishnan on 9/26/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "CLSocialShareHandler.h"

@implementation CLSocialShareHandler

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

+ (MFMailComposeViewController *)sendEmailWithImage:(UIImage *)image imageName:(NSString *)filename imageUrl:(NSString *)url subject:(NSString *)subject message:(NSString *)message ToRecipients:(NSArray *)recipients {
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        [controller setSubject:subject];
        [controller setMessageBody:message isHTML:NO];
        [controller setToRecipients:recipients];
        if(image) {
            NSData *imageData = UIImagePNGRepresentation(image);
            [controller addAttachmentData:imageData mimeType:@"image/png" fileName:filename];
        }
        return controller;
    }
    else {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:"]];
    }
    return nil;
}

+ (NSString *)customizeLikeButton {
    
    NSString *likeButtonIFrame = @"<iframe src=\"http://www.facebook.com/plugins/likebox.php?href=https%3A%2F%2Fwww.facebook.com%2FFacebookDevelopers&amp;width=292&amp;height=590&amp;colorscheme=light&amp;show_faces=true&amp;header=true&amp;stream=true&amp;show_border=true&amp;appId=581840061853687\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:292px; height:590px;\" allowTransparency=\"true\"></iframe>";
    NSString *likeButtonHtml = [NSString stringWithFormat:@"<HTML><BODY>%@</BODY></HTML>", likeButtonIFrame];
    return likeButtonHtml;
}

@end
