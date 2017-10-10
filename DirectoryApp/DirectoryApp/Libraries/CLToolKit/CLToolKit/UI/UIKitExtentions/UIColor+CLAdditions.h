//
//  UIColor+CLAdditions.h
//  CLToolKit
//
//  Created by Vaisakh krishnan on 18 Aug, 2013
//  Copyright (c) 2013 Codelynks. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIColor (CLAdditions)

+ (UIColor *)colorFromString:(NSString *)value;

+ (UIColor *)colorFromHexValue:(NSInteger)hex;

@end
