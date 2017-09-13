//
//  AppDelegate.m
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/13/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Constants.h"
#import "ReviewsVC.h"
#import "ProfileVC.h"
#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import "WalkThroughVC.h"
#import "BusinessOwnerVC.h"
#import "FacebookLoginVC.h"
#import "MapViewController.h"
#import "LoginViewController.h"
#import <Crashlytics/Crashlytics.h>
#import "ECSlidingViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "CLFacebookHandler/FacebookWrapper.h"
#import <UserNotifications/UserNotifications.h>
#import "User.h"
#import "UrlGenerator.h"
#import "Reachability.h"
#import "NetworkHandler.h"
#import "RequestBodyGenerator.h"
#import "SurpriseBoxVc.h"
#import "BusinessUser.h"



#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@import GoogleMaps;
@import GooglePlaces;

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property (nonatomic,strong)ECSlidingViewController *slidingViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[FacebookWrapper standardWrapper] handlerApplication:application didFinishLaunchingWithOptions:launchOptions];
    [GMSPlacesClient provideAPIKey:@"AIzaSyBbZIXvsBY0FEnCsx2-I2YYTfQ5LgbrQ4o"];
    [GMSServices provideAPIKey:@"AIzaSyBbZIXvsBY0FEnCsx2-I2YYTfQ5LgbrQ4o"];
    [self addingObserver];
    [self InitWindow];
    [Fabric with:@[CrashlyticsKit]];
    [[Fabric sharedSDK] setDebug: YES];
    [self settingValues];
    [self registerPushNotification];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)settingValues{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:-1] forKey:@"rowValue"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"categoryId"];
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options{
    return [[FacebookWrapper standardWrapper] handleapplication:app openURL:url options:options];
}


-(void)addingObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHome) name:DirectoryShowHome object:nil];
}

-(void)showHome{
    
    [self InitWindow];
}

-(void)InitWindow{
    UIViewController *previousRootViewController = self.window.rootViewController;
    [previousRootViewController dismissViewControllerAnimated:NO completion:^{
        [previousRootViewController.view removeFromSuperview];
    }];
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:isLoggedIn];
    //BOOL isWalkThroughVisited = [[NSUserDefaults standardUserDefaults] boolForKey:isWalkthroughVisited];
    BOOL isWalkThroughVisited = YES;
    BOOL isBusiUser = [[NSUserDefaults standardUserDefaults]boolForKey:isBusinessUser];
    BOOL isNormUser = [[NSUserDefaults standardUserDefaults]boolForKey:isNormalUser];
    if(isLogIn){
        NSString *temp=[[NSUserDefaults standardUserDefaults]valueForKey:deviceTokenKey];
        [self DeviceToken:temp];
        if(isNormUser){
            [self settingEcSlidingViewController];
        }else if (isBusiUser){
             [self settingBusinessUserHomePage];
            }
            
    }
    else{
        if(isWalkThroughVisited){
            [self settingEcSlidingViewController];
        }
        else{
            WalkThroughVC *faq = [[WalkThroughVC alloc] initWithNibName:@"WalkThroughVC" bundle:nil];
            self.window.rootViewController = faq;
        }
    }
}

-(void)settingEcSlidingViewController{
    MapViewController *mapVC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:mapVC];
    ProfileVC *profileVC = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
    self.slidingViewController.topViewController = mapVC;
    self.slidingViewController.underLeftViewController = profileVC;
    self.slidingViewController.anchorRightPeekAmount  = iPhone?60.0:300;
    self.window.rootViewController = self.slidingViewController;
    
    [self.slidingViewController.topViewController.view addGestureRecognizer:self.slidingViewController.panGesture];
}

-(void)settingBusinessUserHomePage{
    BusinessOwnerVC *businessOwnerVc = [[BusinessOwnerVC alloc] initWithNibName:@"BusinessOwnerVC" bundle:nil];
    self.window.rootViewController = businessOwnerVc;
}

-(void)settingLoginVC{
    LoginViewController *logInVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.window.rootViewController = logInVC;
}

#pragma mark - Push Notification Delegates

- (void)registerPushNotification {
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0") ){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }else {
        UIUserNotificationType types = UIUserNotificationTypeAlert| UIUserNotificationTypeSound |UIUserNotificationTypeBadge;
        UIUserNotificationSettings *mySettings =[UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *newDeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newDeviceToken = [newDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults]setObject:newDeviceToken forKey:deviceTokenKey];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"User Info:%@",userInfo);
    if([[[userInfo valueForKey:@"data"] valueForKey:@"user_type"]isEqual:[NSNumber numberWithInt:2]]){
          UIViewController *topViewController;
        UIViewController *rootVC = self.window.rootViewController;
        if([[rootVC presentedViewController] isKindOfClass:[UINavigationController class]]){
            UINavigationController *naController = (UINavigationController *)[rootVC presentedViewController];
            topViewController = [[naController viewControllers] lastObject];
        }
        else
            topViewController = self.window.rootViewController;
        
        NSString *alertMessage=[[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]valueForKey:@"body"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                                preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//            
//            if(![topViewController isKindOfClass:[SurpriseBoxVc class]]){
//                [topViewController presentViewController:navigationController animated:YES completion:nil];
//            }else{
//                SurpriseBoxVc *vc = (SurpriseBoxVc *)topViewController;
//                [vc getMyRecommendationsApi];
//            }
//            
//        }];
        UIAlertAction *SecondAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
       // [alert addAction:firstAction];
        [alert addAction:SecondAction];
        [topViewController presentViewController:alert animated:YES completion:nil];

        

    }else{
    UIViewController *topViewController;
    NSString *alertMessage=[[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]valueForKey:@"body"];
    SurpriseBoxVc *vc = [[SurpriseBoxVc alloc] initWithNibName:@"SurpriseBoxVc" bundle:nil];
    vc.isFromPush=YES;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:vc];
    UIViewController *rootVC = self.window.rootViewController;
    if([[rootVC presentedViewController] isKindOfClass:[UINavigationController class]]){
        UINavigationController *naController = (UINavigationController *)[rootVC presentedViewController];
        topViewController = [[naController viewControllers] lastObject];
    }
    else
        topViewController = self.window.rootViewController;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        if(![topViewController isKindOfClass:[SurpriseBoxVc class]]){
            [topViewController presentViewController:navigationController animated:YES completion:nil];
        }else{
            SurpriseBoxVc *vc = (SurpriseBoxVc *)topViewController;
            [vc getMyRecommendationsApi];
        }
        
    }];
    UIAlertAction *SecondAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

    }];
    [alert addAction:firstAction];
    [alert addAction:SecondAction];
    [topViewController presentViewController:alert animated:YES completion:nil];
    }
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"%@",response.notification.request.content.userInfo);
    if([[[response.notification.request.content.userInfo valueForKey:@"data"] valueForKey:@"user_type"]isEqual:[NSNumber numberWithInt:2]]){
    }else{
    UIViewController *topViewController;
    SurpriseBoxVc *vc = [[SurpriseBoxVc alloc] initWithNibName:@"SurpriseBoxVc" bundle:nil];
    vc.isFromPush=YES;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:vc];
    UIViewController *rootVC = self.window.rootViewController;
    if([[rootVC presentedViewController] isKindOfClass:[UINavigationController class]]){
        UINavigationController *naController = (UINavigationController *)[rootVC presentedViewController];
        topViewController = [[naController viewControllers] lastObject];
    }
    else
        topViewController = self.window.rootViewController;
    
    if(![topViewController isKindOfClass:[SurpriseBoxVc class]]){
    [topViewController presentViewController:navigationController animated:YES completion:nil];
    }else{
        SurpriseBoxVc *vc = (SurpriseBoxVc *)topViewController;
        [vc getMyRecommendationsApi];
    }
    }
}

#pragma mark - DeviceToken Api call

-(void)DeviceToken:(NSString*)token {
     User *user=[User getUser];
    BusinessUser  *Bussuser=[BusinessUser getBusinessUser];
    BOOL isBusiUser = [[NSUserDefaults standardUserDefaults]boolForKey:isBusinessUser];
    BOOL isNormUser = [[NSUserDefaults standardUserDefaults]boolForKey:isNormalUser];
    NSString *userId;
    if(isNormUser){
      userId=[NSString stringWithFormat:@"%d",user.user_id];
    }else if (isBusiUser){
    userId=[NSString stringWithFormat:@"%lld",Bussuser.bus_user_id];
    }
    NSString *tempString = [NSString stringWithFormat:@"user_id=%@&token=%@",userId,token];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEDEVICEREGISTRATION withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:tempString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        
        } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {

    }];
}

@end
