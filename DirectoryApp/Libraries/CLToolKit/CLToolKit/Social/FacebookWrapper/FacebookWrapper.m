//
//  FacebookWrapper.m
//  Jeep
//
//  Created by Naveen Shan on 5/30/13.
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import "FacebookWrapper.h"

#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>

NSString *const FBSessionStateChangedNotification = @"com.jeep.Login:FBSessionStateChangedNotification";

@implementation FacebookWrapper

+ (FacebookWrapper *)standardWrapper {
    static FacebookWrapper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Facebook Handles

/*
 * Handles URL for with a Facebook session information.
 */
- (BOOL)handleOpenURL:(NSURL *)url {
    BOOL facebookOpenURL = [FBSession.activeSession handleOpenURL:url];
    if (facebookOpenURL) {
        //[self notifySessionChanged];
    } else {
        // NSLog(@"FacebookWrapper handleOpenURL : which is not supported by Facebook Skipped...");
    }
    
    return facebookOpenURL;
}

/*
 * Opens a Facebook session and optionally shows the login UI.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_location",
                            @"user_likes",
                            @"email",
                            @"user_photos",
                            nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             if (error) {
                                                 // NSLog(@"Session error");
                                                 //[self fbResync];
                                                 [NSThread sleepForTimeInterval:0.5];   //half a second
                                                 [FBSession openActiveSessionWithReadPermissions:permissions
                                                                                    allowLoginUI:YES
                                                                               completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                                                                   [self sessionStateChanged:session state:state error:error];
                                                                               }];
                                                 
                                             }
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error    {
    // NSLog(@"state is %d",state);
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                // NSLog(@"FacebookWrapper Info : Valid FBSession found...");
                [self fetchFacebookUserInfo];
            }
            else {
                //NSLog(@"FacebookWrapper Info : Valid FBSession found ERROR: %@", [error localizedDescription]);
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed: {
            //NSLog(@"FBSessionStateClosedLoginFailed ERROR: %@", [error localizedDescription]);
            [FBSession.activeSession closeAndClearTokenInformation];
            // NSLog(@"FacebookWrapper Info : No Valid FBSession found***");
        }
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)sessionIsOpen {
    return FBSession.activeSession.isOpen;
}

- (void)logoutFBSession{
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
}

- (void)closeFBSession {
    [FBSession.activeSession close];
}

// We need to properly handle activation of the application with regards to Facebook Login
// (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
- (void)handleDidBecomeActive {
    [FBSession.activeSession handleDidBecomeActive];
}

#pragma mark -

- (void)addSessionChangedObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(fbSessionChanged:) name:FBSessionStateChangedNotification object:nil];
}

- (void)removeSessionChangedObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:FBSessionStateChangedNotification object:nil];
}

- (void)notifySessionChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification object:[FBSession activeSession]];
}

#pragma mark - Requests

- (void)fetchFacebookUserInfo {
    
    NSMutableDictionary *userDetails = [NSMutableDictionary dictionary];
    if ([self sessionIsOpen]) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                               id<FBGraphUser> user,
                                                               NSError *error) {
            if (!error) {
                NSString *userInfo = @"";
                userInfo = [userInfo stringByAppendingString:[NSString stringWithFormat:@"username: %@\n\n",user.first_name]];
                [userDetails setValue:userInfo forKey:@"firstname"];
                userInfo = [userInfo stringByAppendingString:[NSString stringWithFormat:@"email: %@\n\n",[user objectForKey:@"email"]]];
                [userDetails setValue:userInfo forKey:@"email"];
                
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectForKey:@"id"]]];
                NSData *tempData =  [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:nil error:nil];
                [[NSUserDefaults standardUserDefaults] setValue:user.first_name forKey:kUserName];
                [[NSUserDefaults standardUserDefaults] setValue:[user objectForKey:@"email"] forKey:@"email"];
                [userDetails setValue:tempData forKey:@"userimagedata"];
                [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:@"fbuserdetails"];
                //[[NSUserDefaults standardUserDefaults] setValue:@"fblogin" forKey:@"logintype"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *propicUrlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectForKey:@"id"]];
                [[NSUserDefaults standardUserDefaults] setValue:propicUrlString forKey:@"profilepicurl"];
                //    NSData *propicData =  [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:propicurl] returningResponse:nil error:nil];
                // userDetails.photo = [[ImageCache sharedCache] addImage:[UIImage imageWithData:tempData] toCacheWithIdentifier:@"Photo"];
                
                [self notifySessionChanged];
            }
            // else
            //NSLog(@"%@",[error localizedDescription]);
        }];
    }
}

- (void)checkForPermission:(NSString *)permission completionHandler:(void (^) (BOOL result, NSError *error))handler {
    if ([FBSession.activeSession.permissions indexOfObject:permission] == NSNotFound) {
        // No permissions found in session, ask for it
        //        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
        //            if (error) {
        //                handler(NO,error);
        //            } else {
        //                handler(YES,nil);
        //            }
        //        }];
        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
            if (error) {
                handler(NO,error);
            } else {
                handler(YES,nil);
            }
        }];
    }
    else {
        handler(YES,nil);
    }
}

- (NSError *)processFacebookError:(NSError *)error {
    NSDictionary *dict = [error userInfo];
    NSDictionary *responseKey = [dict objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"];
    NSDictionary *body = [responseKey objectForKey:@"body"];
    NSDictionary *errorBody = [body objectForKey:@"error"];
    
    int code = [[errorBody objectForKey:@"code"] intValue];
    NSString *message = [errorBody objectForKey:@"message"];
    
    NSDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:message,NSLocalizedDescriptionKey, nil];
    NSError *fbError = [NSError errorWithDomain:@"Facebook Error" code:code userInfo:userInfo];
    return fbError;
}

- (void)publishStory:(NSString *)shareMessage completionHandler:(void (^) (BOOL result, NSError *error))handler {
    
    [self checkForPermission:@"publish_actions" completionHandler:^(BOOL result, NSError *error) {
        if (! result) {
            NSError *fbError = [self processFacebookError:error];
            handler(NO,fbError);
            return;
        }
        
        [FBRequestConnection startForPostStatusUpdate:shareMessage
                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                        
                                        if(!error)  {
                                            handler(YES,nil);
                                        }
                                        else {
                                            NSError *fbError = [self processFacebookError:error];
                                            handler(NO,fbError);
                                        }
                                        
                                    }];
    }];
}

-(void)fbResync
{
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){
                }
            }];
        }
    }
}

@end
