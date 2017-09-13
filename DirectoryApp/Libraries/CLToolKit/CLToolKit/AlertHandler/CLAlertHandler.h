//
//  AlertHandler.h
//  CLToolKit
//
//  Created by Vaisakh krishnan on 4/22/15.
//  Copyright (c) 2015 Codelynks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLAlertHandler : NSObject

+ (CLAlertHandler *)standardHandler;
- (void)showAlert:(NSString *)alertMessage title:(NSString *)title;
- (void)showAlert:(NSString *)alertMessage title:(NSString *)title delegate:(id)delegate;
- (void)showAlert:(NSString *)alertMessage alertTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitle:(NSString *)otherTitle delegate:(id)delegate;
- (void)showAlert:(NSString *)alertMessage withTag:(int)alertTag alertTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitle:(NSString *)otherTitle delegate:(id)delegate;
- (void)showAlert:(NSString *)alertMessage withTag:(int)alertTag title:(NSString *)title delegate:(id)delegate;
- (void)showAlert:(NSString *)alertMessage title:(NSString *)title inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)( BOOL isSuccess ))buttonAction;
- (void)showAlert:(NSString *)alertMessage withOkButtonTitle:(NSString *)okButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle title:(NSString *)title inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)( BOOL isSuccess ))buttonAction;


@end
