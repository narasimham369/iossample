//
//  CLEmailShare.m
//  CLCatalogue
//
//  Created by Aravind on 9/27/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "CLEmailShare.h"

#import "CLSocialShareHandler.h"

@interface CLEmailShare ()

@property (nonatomic,strong) MFMailComposeViewController* controller;
@end


@implementation CLEmailShare

-(void) shareToEmail:(UIViewController *) viewController withImage:(UIImage *) image
imageNamed:(NSString *)name  imageUrl:(NSString *) url{    
    self.controller =[CLSocialShareHandler sendEmailWithImage:image imageName:name imageUrl:url subject:nil message:nil];
    if(self.controller == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Share" message:@"Please set up a Mail account in order to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.controller.mailComposeDelegate = self;
    [viewController presentViewController:self.controller animated:YES completion:^{
        NSLog(@"Completed");
    }];
}

- (BOOL)canSendMail {
    return [MFMailComposeViewController canSendMail];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error        {
    NSString *message ;
    switch (result)                {
            
        case MFMailComposeResultCancelled:
            message = @"Message Deleted";
            break;
        case MFMailComposeResultSaved:
            message = @"Message Saved";
            break;
        case MFMailComposeResultSent:
            message = @"Message Sent";
            break;
        case MFMailComposeResultFailed:
            message = @"Failed";
            break;
        default:
            message = @"Not sent";
            
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Share" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    alert = nil;
    //[self.controller dismissViewControllerAnimated:YES completion:Nil];
#ifdef __IPHONE_6_0
    [self.controller dismissViewControllerAnimated:YES completion:nil];
#else
    [self.controller dismissModalViewControllerAnimated:YES];
#endif
}


@end
