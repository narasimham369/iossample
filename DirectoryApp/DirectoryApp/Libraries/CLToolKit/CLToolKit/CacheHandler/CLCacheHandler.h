//
//  CacheHandler.h
//  CLToolKit
//
//  Created by Vaisakh krishnan on 4/22/15.
//  Copyright (c) 2015 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLCacheHandler : NSObject

+ (CLCacheHandler *)standardUtilities;

- (void)removeCacheFolder:(NSString *) folderName;
- (NSString *)setCachePathInFolder:(NSString *)folderName;
- (int) checkNumberOfComponentsAtCacheFolder:(NSString *) folderName;
- (NSArray *) totalNumberOfComponentsAtCacheFolder:(NSString *) folderName;
- ( NSData *)dataFromFolder:(NSString *)folderName WithIdentifier:(NSString *)identifier;
- (NSString *)contentPathInFolder:(NSString *)folderName WithIdentifier:(NSString *)identifier;
- (BOOL)checkComponentAtCacheFolder:(NSString *) folderName WithIdentifier:(NSString *)identifier;
- (void)Write:(NSData *)data toCacheFolder:(NSString *) folderName WithIdentifier:(NSString *)identifier;

@end
