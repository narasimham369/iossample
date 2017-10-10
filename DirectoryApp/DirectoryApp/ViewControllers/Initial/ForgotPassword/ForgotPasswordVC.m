//
//  ForgotPasswordVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 03/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Utilities.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "NetworkHandler.h"
#import "UrlGenerator.h"
#import "ForgotPasswordVC.h"
#import <CLToolKit/NSString+Extension.h>

@interface ForgotPasswordVC ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation ForgotPasswordVC

- (void)initView {
    [super initView];
    self.title = @"Forgot Password";
    [[Utilities standardUtilities]addGradientLayerTo:self.submitButton];
    [self showButtonOnLeftWithImageName:@""];
    NSAttributedString *normalText = [[NSAttributedString alloc] initWithString:@"Enter your email address below and we\nwill send you password reset\ninformations. "];
    NSMutableAttributedString *finalAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:normalText];
    self.messageLabel.attributedText = finalAttributedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextField Delegates


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.emailTextField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - Button Actions

-(void)backButtonAction:(UIButton *)backButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitButtonAction:(id)sender {
    if(![self.emailTextField.text empty]){
       [self forgotPasswordApi];
    }
    else{
       [self ShowAlert:@"Please enter an email address or phone number" errorCode:[NSNumber numberWithInt:1]];
    }
}

#pragma mark - Tap Action

- (IBAction)tapAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Get Favourite Spots Api call

-(void)forgotPasswordApi {
    NSString *urlParameter = self.emailTextField.text;
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEFORGOTPASSWORD withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [self ShowAlert:[responseObject valueForKey:@"messageText"] errorCode:[responseObject valueForKey:@"errorCode"]];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

#pragma mark - Showing Alert Controller

-(void)ShowAlert:(NSString*)alertMessage errorCode:(NSNumber*)code{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        if ([code isEqualToNumber:[NSNumber numberWithInt:0]]) {
             [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
