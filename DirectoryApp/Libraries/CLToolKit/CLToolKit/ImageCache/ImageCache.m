//
//  ImageCache.m
//  CLCatalogue
//
//  Created by Vishakh Krishnan on 9/19/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "ImageCache.h"
@class UIImage;
@implementation ImageCache

+ (ImageCache *)sharedCache {
    static ImageCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[ImageCache alloc] init];
    });
    return sharedCache;
}

- (NSString *)setCachePath {
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    NSString *cachePath = [NSString stringWithFormat:@"Library/Caches/%@/ImageCache",applicationName];
    return [NSHomeDirectory() stringByAppendingPathComponent:cachePath];
}


- (UIImage *)imageFromCacheWithIdentifier:(NSString *)identifier {
    NSString *folderPath = [self setCachePath];
    NSString *fileName = [NSString stringWithFormat:@"%@.png",identifier];
    fileName = [folderPath stringByAppendingPathComponent:identifier];
    if([UIImage imageWithContentsOfFile:fileName]) {
        return [UIImage imageWithContentsOfFile:fileName];
    }
    return nil;
}

#pragma mark - Image saved with the orginal size

- (NSString *)addOrginalImage:(UIImage *)image toCacheWithIdentifier:(NSString *)identifier {
    NSString *folderPath = [self setCachePath];
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@.png",identifier];
    if ([identifier isEqualToString:@"screenShot.ig"]) {
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
            && [[UIScreen mainScreen] scale] == 2.0) {
            // Retina
            image = [self scale:image toSize:CGSizeMake(306, 306)];
        } else {
            // Not Retina
            image = [self scale:image toSize:CGSizeMake(612, 612)];
        }
        
    }
    
    
    fileName = [folderPath stringByAppendingPathComponent:identifier];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:fileName atomically:YES];
    return fileName;
}

#pragma mark - image resized and saved locally

- (NSString *)addImage:(UIImage *)image toCacheWithIdentifier:(NSString *)identifier {
    NSString *folderPath = [self setCachePath];
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@.png",identifier];
    fileName = [folderPath stringByAppendingPathComponent:identifier];
    UIImage * tempImage = [self scale:image toSize:CGSizeMake(45, 45)];
    NSData *imageData = UIImagePNGRepresentation(tempImage);
    [imageData writeToFile:fileName atomically:YES];
    return fileName;
}


- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (BOOL) checkNumberOfComponentsAtPath:(NSString *)identifier {
    BOOL check = NO;
    NSString *folderPath = [self setCachePath];
    NSString * temp = [NSString stringWithFormat:@"%@.png",identifier];
    if([[NSFileManager defaultManager] fileExistsAtPath:[folderPath stringByAppendingPathComponent:temp] isDirectory:nil]) {
        check = YES;
    }
    
    return check;
}

- (NSMutableArray *) checkimagesAtComponentsPath {
    int count = 0;
    NSMutableArray * responseArray = [[NSMutableArray alloc]init];;
    NSString *folderPath = [self setCachePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:nil]) {
        count = (int)[[NSFileManager defaultManager] subpathsAtPath:folderPath].count;
    }
    NSArray * dataArray = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    for (int i=0; i<count; i++) {
        if(![[dataArray objectAtIndex:i] isEqualToString:@"UserPhoto.png"]){
            if(![[dataArray objectAtIndex:i] isEqualToString:@"screenShot.ig"]) {
                [responseArray addObject:[dataArray objectAtIndex:i]];
                // NSLog(@"%@",[dataArray objectAtIndex:i]);
            }
        }
    }
    //    if([[NSFileManager defaultManager] fileExistsAtPath:[folderPath stringByAppendingPathComponent:@"UserPhoto.png"] isDirectory:nil]) {
    //
    //    }
    
    return responseArray;
}

//- (NSString *)addImage:(UIImage *)image toFolder:(NSString *)folderName toCacheWithIdentifier:(NSString *)identifier {
//    NSString *folderPath = [self setNewFolderPath:folderName];
//    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:nil]) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    NSString * fileName = [NSString stringWithFormat:@"%@.png",identifier];
//    fileName = [folderPath stringByAppendingPathComponent:fileName];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    [imageData writeToFile:fileName atomically:YES];
//    return fileName;
//}

- (void)removeImagesFromLocal {
    NSString *folderPath = [self setCachePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:folderPath error:nil];
    }
}

-(void)removeFolderWithName:(NSString *)folderPath{
    NSString *foldePath = [self setNewFolderPath:folderPath];
    if([[NSFileManager defaultManager] fileExistsAtPath:foldePath isDirectory:nil]) {
       [[NSFileManager defaultManager] removeItemAtPath:foldePath error:nil];
    }
}

- (void)removeSpecificImagesFromLocal:(NSString *)imageName {
    NSString *fileName = [NSString stringWithFormat:@"%@",imageName];
    NSString *folderPath = [[self setCachePath] stringByAppendingPathComponent:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:folderPath error:nil];
    }
}

#pragma mark - Add And Retrive Images from User Specified Folder

- (NSString *)setNewFolderPath:(NSString *)newPath {
    NSString *applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *cachePath = [NSString stringWithFormat:@"Library/Caches/%@/%@",applicationName,newPath];
    return [NSHomeDirectory() stringByAppendingPathComponent:cachePath];
}


- (NSString *)addImage:(UIImage *)image toFolder:(NSString *)folderName toCacheWithIdentifier:(NSString *)identifier {
    NSString *folderPath = [self setNewFolderPath:folderName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * fileName = [NSString stringWithFormat:@"%@.png",identifier];
    fileName = [folderPath stringByAppendingPathComponent:fileName];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:fileName atomically:YES];
    return fileName;
}

- (UIImage *)imageFromFolder:(NSString *)folderName WithIdentifier:(NSString *)identifier {
    NSString *folderPath = [self setNewFolderPath:folderName];
    NSString * fileName = [NSString stringWithFormat:@"%@.png",identifier];
    fileName = [folderPath stringByAppendingPathComponent:fileName];
    if([UIImage imageWithContentsOfFile:fileName]) {
        return [UIImage imageWithContentsOfFile:fileName];
    }
    return nil;
}


@end
