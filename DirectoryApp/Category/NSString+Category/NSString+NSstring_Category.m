//
//  NSString+NSstring_Category.m
//  Ribbn
//
//  Created by Bibin Mathew on 1/21/17.
//  Copyright © 2017 codelynks. All rights reserved.
//
#import "NSString+NSstring_Category.h"

@implementation NSString (NSstring_Category)

-(NSString *)convertDateWithInitialFormat:(NSString *)initialFormat ToDateWithFormat:(NSString *)dateFormat{
    NSString *finalDateString = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(initialFormat.length==0)
        initialFormat = @"yyyy-MM-dd";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:initialFormat];
    NSDate *myDate = [dateFormatter dateFromString:self];
    if(dateFormat.length==0)
        dateFormat = @"MM/dd/yyyy";
    [dateFormatter setDateFormat:dateFormat];
    finalDateString = [dateFormatter stringFromDate:myDate];
    if(self.length==0)
        return @"";
    return finalDateString;
}

- (NSString *) capitalizeFirstLetter {
    NSString *retVal;
    if([self isEqual:[NSNull null]] || (self.length == 0))
        retVal = @"";
    else if (self.length < 2) {
        retVal = self.capitalizedString;
    } else {
        retVal = [NSString stringWithFormat:@"%@%@",[[self substringToIndex:1] uppercaseString],[self substringFromIndex:1]];
    }
    return retVal;
}
@end
