//
//  WebViewUrls.h
//  DirectoryApp
//
//  Created by Vishnu KM on 02/05/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <CoreData/CoreData.h>
NS_ASSUME_NONNULL_BEGIN
@interface WebViewUrls : NSManagedObject
+ (WebViewUrls *)getUrls;
+(WebViewUrls *)getUrlsWithId:(NSNumber *)ID;
+ (void)saveUrlDetails:(NSMutableDictionary *)detailsArray;
@end
NS_ASSUME_NONNULL_END

#import "WebViewUrls+CoreDataProperties.h"
