//
//  CLDateHandler.h
//  CLToolKit
//
//  Created by Vaisakh krishnan on 4/22/15.
//  Copyright (c) 2015 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLDateHandler : NSObject

+ (CLDateHandler *)standardUtilities;
- (NSString *)createTimeStampFor:(NSDate *)date;
- (NSString *)convertDate:(NSDate *)currentDate toFormatedString:(NSString *)formateString withTimeZone:(NSTimeZone *)timezone;
- (NSDate *)convertToDate:(NSString *)dateString corespondingTo:(NSString *)formatedDateString withTimeZone:(NSTimeZone *)timezone;


@end
