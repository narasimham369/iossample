//
//  NetworkHandler.h
//  NetworkHandler
//
//  Created by VK on 3/9/15.
//  Copyright (c) 2015 CL. All rights reserved.
//

#import "RequestBodyGenerator.h"

@implementation RequestBodyGenerator

+(RequestBodyGenerator *) sharedBodyGenerator{
    static RequestBodyGenerator *sharedBodyGenerator;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        sharedBodyGenerator = [[self alloc] init];
    });
    return sharedBodyGenerator;
}

#pragma mark - Request body Generator

- (NSData *)requestBodyGeneratorWith:(id)contentDictionary {
    NSString * string = nil;
    if ([NSJSONSerialization isValidJSONObject:contentDictionary]) {
        string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:contentDictionary
                                                                                options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    }
    NSLog(@"%@",string);
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}


@end

@implementation HeaderBodyGenerator


+(HeaderBodyGenerator *) sharedHeaderGenerator {
    static HeaderBodyGenerator *sharedBodyGenerator;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        sharedBodyGenerator = [[self alloc] init];
    });
    return sharedBodyGenerator;
}

- (NSMutableDictionary *)urlEncodedHeaderBody {
    NSMutableDictionary * headerDictionary = [[NSMutableDictionary alloc]init];
    //[headerDictionary setValue:@"Accept" forKey:@"application/json"];
    [headerDictionary setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    return headerDictionary;
}

- (NSMutableDictionary *)headerBodyWithAccessToken:(NSString *)accesToken {
    NSMutableDictionary * headerDictionary =   [[NSMutableDictionary alloc] init];
    if(accesToken)
        [headerDictionary setObject:accesToken forKey:@"access-token"];
    return headerDictionary;
}

- (NSMutableDictionary *)headerBody {
        NSMutableDictionary * headerDictionary = [[NSMutableDictionary alloc]init];
        //[headerDictionary setValue:@"application/json" forKey:@"Accept"];
        [headerDictionary setValue:@"application/json" forKey:@"Content-Type"];
        return headerDictionary;
}


@end
