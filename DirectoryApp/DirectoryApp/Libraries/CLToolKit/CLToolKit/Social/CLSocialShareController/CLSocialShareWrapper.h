//
//  CLSocialShareWrapper.h
//  CLToolKit
//
//  Created by Aravind on 8/21/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIActivityViewController.h>

@interface CLSocialShareWrapper : NSObject

+ (UIActivityViewController *)shareToAll:(NSArray *) array;
@end
