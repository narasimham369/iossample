//
//  UIColor+CLAdditions.m
//  CLToolKit
//
//  Created by Vaisakh krishnan on 18 Aug, 2013
//  Copyright (c) 2013 Codelynks. All rights reserved.

#import "UIColor+CLAdditions.h"

@implementation UIColor (CLAdditions)

/** Matches the given content against the regular expression pattern, extracting
 *  any captured groups into an NSArray. Unmatched captured groups are represented
 *  by NSNull instances in the returned array.
 */
+ (NSArray *)getCapturedStrings:(NSString *)content withPattern:(NSString *)pattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSTextCheckingResult *result = [regex firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];

    if (!result)
        return nil;

    NSMutableArray *capturedStrings = [NSMutableArray array];
    for (NSUInteger i = 0; i <= regex.numberOfCaptureGroups; i++) {
        NSRange capturedRange = [result rangeAtIndex:i];
        if (capturedRange.location != NSNotFound) {
            [capturedStrings insertObject:[content substringWithRange:capturedRange] atIndex:i];
        } else {
            [capturedStrings insertObject:[NSNull null] atIndex:i];
        }
    }
    return [NSArray arrayWithArray:capturedStrings];
}

/** Parses a color component in a color expression. Values containing
 *  periods (.) are treated as unscaled floats. Integer values
 *  are normalized by 255.
 */
+ (CGFloat)parseColorComponent:(NSString *)s {
    if ([s rangeOfString:@"."].location != NSNotFound) {
        return [s floatValue];
    } else {
        return [s floatValue] / 255.0f;
    }
}

// Create a color using a hex RGB value
// ex. [UIColor colorFromHexValue: 0x03047F]
+ (UIColor *)colorFromHexValue:(NSInteger)rgbValue {
    float alpha = (float) ((rgbValue >> 24) & 0xFF) / 255.0f;
    if (alpha == 0) {
        alpha = 1.0f;
    }

    return [UIColor colorWithRed:(float) ((rgbValue >> 16) & 0xFF) / 255.0f
                           green:(float) ((rgbValue >> 8) & 0xFF) / 255.0f
                            blue:(float) ((rgbValue >> 0) & 0xFF) / 255.0f
                           alpha:alpha];

}

// Create a color using a "0xaarrggbb"  "0xrrggbb" "#aarrggbb"  "#rrggbb"
+ (UIColor *)colorFromString:(NSString *)value {
    // Matches the name 'transparent' for clear color.
    if ([value isEqualToString:@"transparent"]) {
        return [UIColor clearColor];

    } else if ([value hasPrefix:@"0x"]) {
        return [self colorFromHexString:[value substringFromIndex:2]];

    } else if ([value hasPrefix:@"#"]) {
        return [self colorFromHexString:[value substringFromIndex:1]];

    } else {
        // Remove all whitespace.
        NSString *cString = [[[value componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                componentsJoinedByString:@""]
                uppercaseString];

        NSArray *csStrings = [self getCapturedStrings:cString
                                          withPattern:@"(RGB|RGBA|HSL|HSLA)\\((\\d{1,3}|[0-9.]+),(\\d{1,3}|[0-9.]+),(\\d{1,3}|[0-9.]+)(?:,(\\d{1,3}|[0-9.]+))?\\)"];

        BOOL isRGB = [[csStrings objectAtIndex:1] hasPrefix:@"RGB"];
        BOOL isAlpha = [[csStrings objectAtIndex:1] hasSuffix:@"A"];

        // Color space with alpha specified but no alpha provided.
        if (isAlpha && [[csStrings objectAtIndex:5] isEqual:[NSNull null]])
            return nil;

        CGFloat a = isAlpha ? [self parseColorComponent:[csStrings objectAtIndex:5]] : 1.0f;

        if (isRGB) {
            return [UIColor colorWithRed:[self parseColorComponent:[csStrings objectAtIndex:2]]
                                   green:[self parseColorComponent:[csStrings objectAtIndex:3]]
                                    blue:[self parseColorComponent:[csStrings objectAtIndex:4]]
                                   alpha:a];
        } else {
            return [UIColor colorWithHue:[self parseColorComponent:[csStrings objectAtIndex:2]]
                              saturation:[self parseColorComponent:[csStrings objectAtIndex:3]]
                              brightness:[self parseColorComponent:[csStrings objectAtIndex:4]]
                                   alpha:a];
        }
    }
}

+ (UIColor *)colorFromHexString:(NSString *)value {
    unsigned int c;
    [[NSScanner scannerWithString:value] scanHexInt:&c];

    float alpha = value.length > 6 ? ((float) ((c >> 24) & 0xFF) / 255.0f) : 1.0f;
    UIColor *color = [UIColor colorWithRed:(float) ((c >> 16) & 0xFF) / 255.0f
                                     green:(float) ((c >> 8) & 0xFF) / 255.0f
                                      blue:(float) ((c >> 0) & 0xFF) / 255.0f
                                     alpha:alpha];
    return color;
}


//+ (UIColor *)colorFromString:(NSString *)value {
//    // Matches the name 'transparent' for clear color.
//    if ([value isEqualToString:@"transparent"]) {
//        return [UIColor clearColor];
//    }
//
//    // Look at UIColor selectors for a matching selector.
//    // Name matches can take the form of 'colorname' (matching selectors like +redColor with 'red').
//    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@Color", value]);
//    if (selector) {
//        if ([[UIColor class] respondsToSelector:selector]) {
//            // [[UIColor class] performSelector:selector] would be better here, but it causes
//            // a warning: "PerformSelector may cause a leak because its selector is unknown"
//            // return objc_msgSend([UIColor class], selector);
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//            return [[UIColor class] performSelector:selector];
//#pragma clang diagnostic pop
//        }
//    }
//
//    // Remove all whitespace.
//    NSString *cString = [[[value componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
//            componentsJoinedByString:@""]
//            uppercaseString];
//
//    NSArray *hexStrings = [self getCapturedStrings:cString
//                                       withPattern:@"(?:0X|#)([0-9A-F]{6})"];
//
//    UIColor *color = nil;
//
//    if (hexStrings) {
//        unsigned int c;
//        [[NSScanner scannerWithString:[hexStrings objectAtIndex:1]] scanHexInt:&c];
//        color = [UIColor colorWithRed:(float) ((c >> 16) & 0xFF) / 255.0f
//                                green:(float) ((c >> 8) & 0xFF) / 255.0f
//                                 blue:(float) ((c >> 0) & 0xFF) / 255.0f
//                                alpha:1.0f];
//    } else {
//        NSArray *csStrings = [self getCapturedStrings:cString
//                                          withPattern:@"(RGB|RGBA|HSL|HSLA)\\((\\d{1,3}|[0-9.]+),(\\d{1,3}|[0-9.]+),(\\d{1,3}|[0-9.]+)(?:,(\\d{1,3}|[0-9.]+))?\\)"];
//
//        if (csStrings) {
//
//            BOOL isRGB = [[csStrings objectAtIndex:1] hasPrefix:@"RGB"];
//            BOOL isAlpha = [[csStrings objectAtIndex:1] hasSuffix:@"A"];
//
//            // Color space with alpha specified but no alpha provided.
//            if (isAlpha && [[csStrings objectAtIndex:5] isEqual:[NSNull null]])
//                return nil;
//
//            CGFloat a = isAlpha ?
//                    [self parseColorComponent:[csStrings objectAtIndex:5]] :
//                    1.0f;
//
//            if (isRGB) {
//                color = [UIColor colorWithRed:[self parseColorComponent:[csStrings objectAtIndex:2]]
//                                        green:[self parseColorComponent:[csStrings objectAtIndex:3]]
//                                         blue:[self parseColorComponent:[csStrings objectAtIndex:4]]
//                                        alpha:a];
//            } else {
//                color = [UIColor colorWithHue:[self parseColorComponent:[csStrings objectAtIndex:2]]
//                                   saturation:[self parseColorComponent:[csStrings objectAtIndex:3]]
//                                   brightness:[self parseColorComponent:[csStrings objectAtIndex:4]]
//                                        alpha:a];
//            }
//        }
//    }
//
//    return color;
//}

@end
