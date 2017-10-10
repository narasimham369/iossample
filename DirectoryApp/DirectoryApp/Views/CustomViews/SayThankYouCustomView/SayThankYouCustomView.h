//
//  SayThankYouCustomView.h
//  DirectoryApp
//
//  Created by Vishnu KM on 02/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ThankYouViewDelegate;

@interface SayThankYouCustomView : UIView

@property (nonatomic, assign) id<ThankYouViewDelegate>thankUViewDelegate;
@end

@protocol ThankYouViewDelegate <NSObject>
- (void)DissmissView:(SayThankYouCustomView *)sayThankView;
-(void)sendButtonActionFromView:(SayThankYouCustomView *)sayThankView DelegateWithMessageContent:(NSString *)messageContent;
@end

