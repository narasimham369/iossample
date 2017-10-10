//
//  AlertHandler.m
//
//  Created by Vaisakh Krishnan on 08/01/16.
//  Copyright © 2016 Pumex. All rights reserved.

#import "CLAlertHandler.h"

@implementation CLAlertHandler

+ (CLAlertHandler *)standardHandler {
    static CLAlertHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


#pragma mark - UIAlert

- (void)showAlert:(NSString *)alertMessage title:(NSString *)title {
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:title message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)showAlert:(NSString *)alertMessage title:(NSString *)title delegate:(id)delegate{
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:title message:alertMessage delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)showAlert:(NSString *)alertMessage alertTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitle:(NSString *)otherTitle delegate:(id)delegate {
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:title message:alertMessage delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    [alert show];
}

- (void)showAlert:(NSString *)alertMessage withTag:(int)alertTag alertTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitle:(NSString *)otherTitle delegate:(id)delegate {
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:title message:alertMessage delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    alert.tag = alertTag;
    [alert show];
}

- (void)showAlert:(NSString *)alertMessage withTag:(int)alertTag title:(NSString *)title delegate:(id)delegate {
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:title message:alertMessage delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = alertTag;
    [alert show];
}

#pragma mark - UIAlertzview Controller

- (void)showAlert:(NSString *)alertMessage title:(NSString *)title inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)( BOOL isSuccess ))buttonAction {
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:title
                               message:alertMessage
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   buttonAction(YES);
                                                   
                                               }];
    [alert addAction:ok];
    [controller presentViewController:alert animated:YES completion:nil];
}

- (void)showAlert:(NSString *)alertMessage withOkButtonTitle:(NSString *)okButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle title:(NSString *)title inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)( BOOL isSuccess ))buttonAction {
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:title
                               message:alertMessage
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   buttonAction(YES);
                                                   
                                               }];
    [alert addAction:ok];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       buttonAction(NO);
                                                       
                                                   }];
    [alert addAction:cancel];
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
