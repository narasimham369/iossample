//
//  CLDateHandler.m
//  CLToolKit
//
//  Created by Vaisakh krishnan on 4/22/15.
//  Copyright (c) 2015 Codelynks. All rights reserved.
//

#import "CLDateHandler.h"

@implementation CLDateHandler

+ (CLDateHandler *)standardUtilities {
    static CLDateHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - String to Date Convertion

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    return dateFormatter;
}

- (NSString *)convertDate:(NSDate *)currentDate toFormatedString:(NSString *)formateString withTimeZone:(NSTimeZone *)timezone {
    [self.dateFormatter setTimeZone:timezone];
    [self.dateFormatter setDateFormat:formateString];
    return [self.dateFormatter stringFromDate:currentDate];
}

- (NSString *)createTimeStampFor:(NSDate *)date {
    return [NSString stringWithFormat:@"%lld",[@(floor([date timeIntervalSince1970])) longLongValue]];
}

- (NSDate *)convertToDate:(NSString *)dateString corespondingTo:(NSString *)formatedDateString withTimeZone:(NSTimeZone *)timezone {
    [self.dateFormatter setTimeZone:timezone];
    [self.dateFormatter setDateFormat:formatedDateString];
    NSDate *dateTemp =[[NSDate alloc]init];
    dateTemp =[self.dateFormatter dateFromString:dateString];
    return dateTemp;
}


@end
