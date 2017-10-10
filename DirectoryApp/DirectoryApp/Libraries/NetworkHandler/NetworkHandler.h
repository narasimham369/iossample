//
//  NetworkHandler.h
//  NetworkHandler
//
//  Created by VK on 3/9/15.
//  Copyright (c) 2015 CL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    HTTPMethodGET,
    HTTPMethodPOST,
    HTTPMethodPUT,
}MethodType;

typedef enum{
    fileTypeVideo,
    fileTypeJPGImage,
    fileTypePNGImage,
    fileTypeDocument,
    fileTypePowerPoint,
    fileTypeHTML,
    fileTypePDF
}FileType;

extern NSString * const kNetworkFailFailNotification;


@interface NetworkHandler : NSObject

+(BOOL)networkUnavalible;

- (void)cancellAllOperations ;
- (id)initWithRequestUrl:(NSURL *) requestUrl withBody:(id) data withMethodType:(MethodType) method withHeaderFeild:(NSMutableDictionary *)headerDictionary;
- (void)startServieRequestWithSucessBlockSuccessBlock:(void (^)( id responseObject,int statusCode))success FailureBlock:(void (^)( NSError *error,int statusCode,id errorResponseObject))failure;
-(void)startDownloadRequestSuccessBlock:(void (^)( id responseObject))success FailureBlock:(void (^)( NSString *errorDescription))failure  ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress;
-(void)startUploadRequest:(NSString *)filename withData:(NSData *)Data withType:(FileType)fileType withUrlParameter:(NSString *)urlParameter withFileLocation:(NSString *)fileLocation
             SuccessBlock:(void (^)( id responseObject))success
            ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
             FailureBlock:(void (^)( NSString *errorDescription,id errorResponse))failure;
-(void)startMultipleFileUploadRequest:(NSString *)filename
                          withBaseUrl:(NSString *)baseUrl
                          withUrlPart:(NSString *)urlPart
                             withData:(NSArray *)dataArray
                             withType:(FileType)fileType
                         SuccessBlock:(void (^)( id responseObject,int statusCode))success
                        ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                         FailureBlock:(void (^)(NSError *error,int statusCode,id errorResponse))failure;

-(void)startOldMultipleImageUploadRequest:(NSString *)filename withData:(NSArray *)dataImageArray withType:(FileType)fileType withUrlParameter:(NSString *)urlParameter andFileLocation:(NSArray  *)fileLocationsArray
                             SuccessBlock:(void (^)( id responseObject))success
                            ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                             FailureBlock:(void (^)( NSString *errorDescription,id errorResponse))failure;
@end
