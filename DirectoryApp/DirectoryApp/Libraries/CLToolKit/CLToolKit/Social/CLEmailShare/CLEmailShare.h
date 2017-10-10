//
//  CLEmailShare.h
//  CLCatalogue
//
//  Created by Aravind on 9/27/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MessageUI/MFMailComposeViewController.h>

@interface CLEmailShare : NSObject<MFMailComposeViewControllerDelegate>

- (BOOL)canSendMail;
-(void) shareToEmail:(UIViewController *) viewController withImage:(UIImage *) image
          imageNamed:(NSString *)name  imageUrl:(NSString *) url;


@end
