//
//  NetworkHandler.h
//  NetworkHandler
//
//  Created by VK on 3/9/15.
//  Copyright (c) 2015 CL. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TWERESPONSETYPE ){
    TWERESPONSETYPELogin = 1,
    TWERESPONSETYPEREGISTER = 2,
    TWERESPONSETYPEFORGOTpassword = 3,
    TWERESPONSETYPEDELETEPRODUCT = 4,
    TWERESPONSETYPEGETALLUSER = 5
    
};

@interface ResponseHandler : NSObject

+(ResponseHandler *) sharedHandler;
- (BOOL)processResponse:(TWERESPONSETYPE )responseType withStatusCode:(int)statusCode;
- (NSString *)processError:(TWERESPONSETYPE )responseType withStatusCode:(int)statusCode withError:(NSError *)error withResponse:(id) errorResponseObject;

@end
