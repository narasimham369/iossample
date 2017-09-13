//
//  ImageCache.h
//  CLCatalogue
//
//  Created by Vishakh Krishnan on 9/19/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIImage;
@interface ImageCache : NSObject

+ (ImageCache *)sharedCache;
- (void)removeImagesFromLocal;
- (NSMutableArray *) checkimagesAtComponentsPath;
- (void)removeSpecificImagesFromLocal:(NSString *)imageName;
- (BOOL) checkNumberOfComponentsAtPath:(NSString *)identifier;
- (UIImage *)imageFromCacheWithIdentifier:(NSString *)identifier;
- (NSString*)addImage:(UIImage *)image toCacheWithIdentifier:(NSString *)identifier;
- (NSString *)addOrginalImage:(UIImage *)image toCacheWithIdentifier:(NSString *)identifier;


- (NSString *)addImage:(UIImage *)image toFolder:(NSString *)folderName toCacheWithIdentifier:(NSString *)identifier;
- (UIImage *)imageFromFolder:(NSString *)folderName WithIdentifier:(NSString *)identifier;
-(void)removeFolderWithName:(NSString *)folderPath;
- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
@end
