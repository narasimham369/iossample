//
//  CacheHandler.m
//  CLToolKit
//
//  Created by Vaisakh krishnan on 4/22/15.
//  Copyright (c) 2015 Codelynks. All rights reserved.
//

#import "CLCacheHandler.h"

@implementation CLCacheHandler

+ (CLCacheHandler *)standardUtilities {
    static CLCacheHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Inorder to save any type of file locally

#pragma mark - Save Data

- (void)Write:(NSData *)data toCacheFolder:(NSString *) folderName WithIdentifier:(NSString *)identifier {
    NSString *folderPath = [self setCachePathInFolder:folderName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@",identifier];
    fileName = [folderPath stringByAppendingPathComponent:fileName];
    [data writeToFile:fileName atomically:NO];
}

- (NSString *)setCachePathInFolder:(NSString *)folderName {
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"];
    NSString *cachePath = [NSString stringWithFormat:@"Library/Caches/%@/%@",applicationName,folderName];
    return [NSHomeDirectory() stringByAppendingPathComponent:cachePath];
}

#pragma mark - Get Data

- ( NSData *)dataFromFolder:(NSString *)folderName WithIdentifier:(NSString *)identifier {
    NSString *folderPath = [self setCachePathInFolder:folderName];
    NSString *fileName = [NSString stringWithFormat:@"%@",identifier];
    fileName = [folderPath stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    if(data) {
        return data;
    }
    return nil;
}

#pragma mark - Local path of particular Item

- (NSString *)contentPathInFolder:(NSString *)folderName WithIdentifier:(NSString *)identifier {
    NSString *folderPath = [self setCachePathInFolder:folderName];
    NSString *fileName = [NSString stringWithFormat:@"%@",identifier];
    fileName = [folderPath stringByAppendingPathComponent:fileName];
    return fileName;
}

#pragma mark - Remove Particular Folder

- (void)removeCacheFolder:(NSString *) folderName {
    NSString *folderPath = [self setCachePathInFolder:folderName];
    if([[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:nil]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:folderPath error:&error];
        //        if(error)
        //            NSLog(@"error %@",[error localizedDescription]);
    }
}

#pragma mark - Check Number of items in Folder

- (int) checkNumberOfComponentsAtCacheFolder:(NSString *) folderName {
    int count = 0;
    NSString *folderPath = [self setCachePathInFolder:folderName];
    if([[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:nil]) {
        count = (int)[[NSFileManager defaultManager] subpathsAtPath:folderPath].count;
    }
    return count;
}

#pragma mark - Check Whether an item exist or not

- (BOOL)checkComponentAtCacheFolder:(NSString *) folderName WithIdentifier:(NSString *)identifier {
    BOOL isExist = NO;
    NSString *folderPath = [self setCachePathInFolder:folderName];
    if([[NSFileManager defaultManager] fileExistsAtPath:[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",identifier]] isDirectory:nil]) {
        isExist = YES;
    }
    return isExist;
}

#pragma mark - total number of componets at path

- (NSArray *) totalNumberOfComponentsAtCacheFolder:(NSString *) folderName {
    NSArray * count ;
    NSString *folderPath = [self setCachePathInFolder:folderName];
    if([[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:nil]) {
        count = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    }
    return count;
}

@end
