//
//  CLFacebookLoginView.h
//  TWExperience
//
//  Created by Jay Krish on 17/05/16.
//  Copyright © 2016 AkulaInternational. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLFacebookViewDelegate ;

@interface CLFacebookLoginView : UIView

@property (nonatomic,strong)id<CLFacebookViewDelegate>CLDelegate;

@end


@protocol CLFacebookViewDelegate <NSObject>

- (void)CLFacebookLoginViewItem:(CLFacebookLoginView *)facebookView userISLoggedOUT:(id)session;
- (void)CLFacebookLoginViewItem:(CLFacebookLoginView *)facebookView fetchUserDetails:(id)user;
- (void)CLFacebookLoginViewItem:(CLFacebookLoginView *)facebookView handleError:(NSString *)error;


@end
