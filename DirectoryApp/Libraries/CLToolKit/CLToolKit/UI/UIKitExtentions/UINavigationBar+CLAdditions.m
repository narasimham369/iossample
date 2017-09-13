//
//  UINavigationBar+CLAdditions.m
//  CategoryApp
//
//  Created by Vishakh Krishnan on 8/20/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "UINavigationBar+CLAdditions.h"

@implementation UINavigationBar (CLAdditions)

-(void) navigationApperance {
    self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:22.0],UITextAttributeFont,[UIColor redColor],UITextAttributeTextColor, nil];

}
@end
