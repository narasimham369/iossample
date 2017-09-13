//
//  ResetPasswordVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 03/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "User.h"
#import "Utilities.h"
#import "Constants.h"
#import "BusinessUser.h"
#import "MBProgressHUD.h"
#import "NetworkHandler.h"
#import "UrlGenerator.h"
#import "ResetPasswordVC.h"
#import <CLToolKit/NSString+Extension.h>

@interface ResetPasswordVC ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordText;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@end

@implementation ResetPasswordVC

- (void)initView {
    [super initView];
    self.title = @"Change Password";
    [self showButtonOnLeftWithImageName:@""];
    [[Utilities standardUtilities]addGradientLayerTo:self.updateButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isvalidInput{
    BOOL isvalid = NO;
    if ([self.currentPasswordText.text empty]){
        [self ShowAlert:@"Please enter your current password" errorCode:[NSNumber numberWithInt:1]];
    }else if ([self.passwordNewText.text empty]){
        [self ShowAlert:@"Please enter your new password" errorCode:[NSNumber numberWithInt:1]];
    }else if([self.passwordNewText.text length]<8){
        [self ShowAlert:@"Your password length should be  minimum of 8 " errorCode:[NSNumber numberWithInt:1]];
    }else if ([self.confirmPasswordText.text empty]){
        [self ShowAlert:@"Please enter your confirm password" errorCode:[NSNumber numberWithInt:1]];
    }else if (![self.passwordNewText.text isEqualToString:self.confirmPasswordText.text]){
        [self ShowAlert:@"Password Mismatch" errorCode:[NSNumber numberWithInt:1]];
    }else {
        isvalid = YES;
    }
    return isvalid;
}



#pragma mark - TextField Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField == self.currentPasswordText)
        [self.passwordNewText becomeFirstResponder];
    else if (textField == self.passwordNewText)
        [self.confirmPasswordText becomeFirstResponder];
    else if (textField == self.confirmPasswordText)
        [self.view endEditing:YES];
    return YES;
}

#pragma mark - Button Actions

-(void)backButtonAction:(UIButton *)backButton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)updateButtonAction:(id)sender {
    if([self isvalidInput]){
        [self resetPasswordApi];
    }

}

#pragma mark - Tap Action

- (IBAction)tapAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Showing Alert Controller

-(void)ShowAlert:(NSString*)alertMessage errorCode:(NSNumber*)code{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        if ([code isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)resetPasswordApi{
    
    User *user = [User getUser];
     BusinessUser *busUser = [BusinessUser getBusinessUser];
    NSString *urlParameter;
    if([[NSUserDefaults standardUserDefaults]boolForKey:isBusinessUser]){
        urlParameter = [NSString stringWithFormat:@"userId=%lld&currentPassword=%@&newPassword=%@",busUser.business_id,self.currentPasswordText.text,self.passwordNewText.text];
    }
    else{
    urlParameter = [NSString stringWithFormat:@"userId=%d&currentPassword=%@&newPassword=%@",user.user_id,self.currentPasswordText.text,self.passwordNewText.text];
    }
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPERESETPASSWORD withURLParameter:urlParameter];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self ShowAlert:[responseObject valueForKey:@"messageText"] errorCode:[responseObject valueForKey:@"errorCode"]];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];

}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
