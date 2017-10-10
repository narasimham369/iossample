//
//  NetworkHandler.h
//  NetworkHandler
//
//  Created by VK on 3/9/15.
//  Copyright (c) 2015 CL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBodyGenerator : NSObject

+(RequestBodyGenerator *) sharedBodyGenerator;

- (NSData *)requestBodyGeneratorWith:(id)contentDictionary;

@end

@interface HeaderBodyGenerator : NSObject

- (NSMutableDictionary *)headerBody ;
- (NSMutableDictionary *)urlEncodedHeaderBody ;
+(HeaderBodyGenerator *) sharedHeaderGenerator;
- (NSMutableDictionary *)headerBodyWithAccessToken:(NSString *)accesToken;

@end
