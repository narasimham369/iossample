//
//  FacebookWrapper.h
//  Jeep
//
//  Created by Naveen Shan on 5/30/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookWrapper : NSObject

+ (FacebookWrapper *)standardWrapper;

#pragma mark -

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)handleDidBecomeActive;

- (BOOL)sessionIsOpen;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

- (void)logoutFBSession;

- (void)closeFBSession;

#pragma mark -

- (void)addSessionChangedObserver:(id)observer;

- (void)removeSessionChangedObserver:(id)observer;

#pragma mark -

- (void)publishStory:(NSString *)shareMessage completionHandler:(void (^) (BOOL result, NSError *error))handler;

@end
