//
//  FacebookWrapper.h
//  TWExperience
//
//  Created by Jay Krish on 17/05/16.
//  Copyright © 2016 AkulaInternational. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FacebookWrapper : NSObject

+ (FacebookWrapper *)standardWrapper;

- (void)activateApp;
- (BOOL)isUserLoggedIn;
- (void)logoutFBSession;

- (void)addSessionChangedObserver:(id)observer;
- (void)removeSessionChangedObserver:(id)observer;
- (void)addUserCancelledObserver :(id)observer;
- (void)removeUserCancelledObserver:(id)observer;
- (void)addPublicActionObserver:(id)observer;
- (void)removePublicActionObserver:(id)observer;
- (void)fetchFaceBookFriendsWithFriendsID:(NSString *)friendsId;
- (void)appInviteFromViewController:(UIViewController *)viewController;
- (BOOL)handlerApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (BOOL)handleapplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options;
- (void)openFaceBookSessionInViewController:(UIViewController *)viewController;
- (void)publishStory:(NSString *)shareMessage inViewController:(UIViewController *)viewController completionHandler:(void (^) (BOOL result, NSError *error))handler;
-(void)gettingProfilePicturesFromAlbum:(NSString *)albumId withCompletionBlock:(void(^)(id photoList,NSError *error))response;
-(void)getAlbumsWithCompletionBlock:(void(^)(id AlbumList,NSError *error))response;

@end
