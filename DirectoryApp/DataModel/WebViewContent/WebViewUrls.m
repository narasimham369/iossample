//
//  WebViewUrls.m
//  DirectoryApp
//
//  Created by Vishnu KM on 02/05/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "WebViewUrls.h"

#import "Utilities.h"
#import <UIKit/UIKit.h>
#import <CLToolKit/CLCoreDataAdditions.h>

@implementation WebViewUrls
+ (void)saveUrlDetails:(NSArray *)detailsArray{
    for (int i = 0; i<detailsArray.count; i++) {
         id urlDetails = [detailsArray objectAtIndex:i];
        WebViewUrls *urls = [self getUrlID:[urlDetails valueForKey:@"url_id"]];
        if(urls == nil ){
        urls = [[CLCoreDataAdditions sharedInstance] newEntityForName:@"WebViewUrls"];
    }
        if([[detailsArray objectAtIndex:i] valueForKey:@"url_name"]){
        if(![[[detailsArray objectAtIndex:i] valueForKey:@"url_name"]isEqual:[NSNull null]])
            urls.url_name= [NSString stringWithFormat:@"%@",[[detailsArray objectAtIndex:i] valueForKey:@"url_name"]];
    }
    if([[detailsArray objectAtIndex:i] valueForKey:@"url_id"]){
        if(![[[detailsArray objectAtIndex:i] valueForKey:@"url_id"]isEqual:[NSNull null]])
            urls.url_id = [[[detailsArray objectAtIndex:i] valueForKey:@"url_id"] intValue];
    }
    if([[detailsArray objectAtIndex:i] valueForKey:@"content_type"]){
        if(![[[detailsArray objectAtIndex:i] valueForKey:@"content_type"]isEqual:[NSNull null]])
            urls.content_type= [NSString stringWithFormat:@"%@",[[detailsArray objectAtIndex:i] valueForKey:@"content_type"]];
    }
    
        [[CLCoreDataAdditions sharedInstance] saveEntity];
    }
    
}

+(WebViewUrls *)getUrlID:(NSNumber *)url{
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF.url_id==%@",url];
    NSArray *urlArray = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"WebViewUrls" withPredicate:urlPredicate];
    if(urlArray.count>0)
        return [urlArray firstObject];
    else
        return nil;
}


#pragma mark - GET User

+ (WebViewUrls *)getUrls{
    NSArray *detailArrayPost = [[CLCoreDataAdditions sharedInstance]getAllDocuments:@"WebViewUrls"];
    if (detailArrayPost.count != 0) {
        return [detailArrayPost objectAtIndex:0];
    }
    return nil;
}

+(WebViewUrls *)getUrlsWithId:(NSNumber *)ID{
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF.url_id==%@",ID];
    NSArray *detailArrayPost = [[CLCoreDataAdditions sharedInstance] getAllDocumentsFor:@"WebViewUrls" withPredicate:urlPredicate];
    if(detailArrayPost.count>0)
        return [detailArrayPost firstObject];
    else
        return nil;
}


@end
