//
//  NSURL+CLLoggerExtension.h
//  CLLogger
//
//  Created by Timmi on 3/18/15.
//  Copyright (c) 2015 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CLLoggerExtension)

- (NSString *) CLStringByObfuscatingQueryParameters;

@end
