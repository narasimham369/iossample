//
//  NSDate+NSDate_Category.m
//  Ribbn
//
//  Created by Bibin Mathew on 1/21/17.
//  Copyright © 2017 codelynks. All rights reserved.
//

#import "NSDate+NSDate_Category.h"

@implementation NSDate (NSDate_Category)
-(NSString *)convertDateToDateWithFormat:(NSString *)dateFormat{
    if(dateFormat.length == 0)
        dateFormat = @"MM/dd/yyyy";
    NSString *finalDateString = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:dateFormat];
    finalDateString = [dateFormatter stringFromDate:self];
    return finalDateString;
}

@end
