//
//  CLSocialShareWrapper.m
//  CLToolKit
//
//  Created by Aravind on 8/21/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "CLSocialShareWrapper.h"

@implementation CLSocialShareWrapper

+ (UIActivityViewController *)shareToAll:(NSArray *) array{
     UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    return activityController;
}
@end
