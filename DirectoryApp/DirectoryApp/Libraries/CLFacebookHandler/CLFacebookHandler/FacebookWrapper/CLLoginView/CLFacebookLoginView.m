//
//  CLFacebookLoginView.m
//  TWExperience
//
//  Created by Jay Krish on 17/05/16.
//  Copyright © 2016 AkulaInternational. All rights reserved.
//

#define CLLoginError @"Something went wrong please allow us"

#import "CLFacebookLoginView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface CLFacebookLoginView () <FBSDKLoginButtonDelegate>

@property (strong, nonatomic) FBSDKLoginButton *loginView;

@end

@implementation CLFacebookLoginView

#pragma mark - View LifeCycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self initView];
}

- (void)initView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeProfileChange:) name:FBSDKProfileDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
    
    self.loginView = [[FBSDKLoginButton alloc] init];
    self.loginView.delegate = self;
    [self addViewContent];
}

- (void)addViewContent {
    [self addSubview:self.loginView];
}

#pragma mark - View layoutSubViews

- (void)layoutSubviews {
    self.loginView.frame = self.bounds;
}


#pragma mark - FBSDKLoginButton delegate

- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error {
    if(error) {
        if(self.CLDelegate && [self.CLDelegate respondsToSelector:@selector(CLFacebookLoginViewItem:handleError:)]) {
            [self.CLDelegate CLFacebookLoginViewItem:self handleError:error.localizedDescription];
        }
        return;
    }
    if(!result.isCancelled) {
    NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"picture, email,first_name,gender,last_name,link,locale,location,name,timezone,updated_time,verified",@"fields", nil];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:dict]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             if(self.CLDelegate && [self.CLDelegate respondsToSelector:@selector(CLFacebookLoginViewItem:fetchUserDetails:)]) {
                 [self.CLDelegate CLFacebookLoginViewItem:self fetchUserDetails:result];
             }
         }
     }];
    }
    else  {
        if(self.CLDelegate && [self.CLDelegate respondsToSelector:@selector(CLFacebookLoginViewItem:handleError:)]) {
            [self.CLDelegate CLFacebookLoginViewItem:self handleError:CLLoginError];
        }
    }

}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    if(self.CLDelegate && [self.CLDelegate respondsToSelector:@selector(CLFacebookLoginViewItem:userISLoggedOUT:)]) {
        [self.CLDelegate CLFacebookLoginViewItem:self userISLoggedOUT:[FBSDKAccessToken currentAccessToken]];
    }
}

#pragma mark - Observations

- (void)observeProfileChange:(NSNotification *)notfication {
    if ([FBSDKProfile currentProfile]) {
         
     }
}

- (void)observeTokenChange:(NSNotification *)notfication {
    if (![FBSDKAccessToken currentAccessToken]) {
        
    } else {
        [self observeProfileChange:nil];
    }
}

@end
