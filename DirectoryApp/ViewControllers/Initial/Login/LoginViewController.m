//
//  LoginViewController.m
//  Garazone
//
//  Created by Hari R Krishna on 2/13/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//
#import "User.h"
#import "Constants.h"
#import "BusinessUser.h"
#import "UserRegisterVC.h"
#import "ForgotPasswordVC.h"
#import "BusinessRegisterVC.h"
#import "LoginViewController.h"
#import "MapViewController.h"
#import "FacebookLoginVC.h"
#import "CLFacebookHandler/FacebookWrapper.h"


#import "Utilities.h"
#import "UrlGenerator.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "NetworkHandler.h"
#import "FacebookLoginVC.h"
#import <CLToolKit/UIKitExt.h>
#import "RequestBodyGenerator.h"
#import <CLToolKit/ImageCache.h>
#import "UIImageView+WebCache.h"
#import <CLToolKit/CLAlertHandler.h>
#import <CommonCrypto/CommonDigest.h>
#import <CLToolKit/NSString+Extension.h>
#import <CLToolKit/CLCoreDataAdditions.h>


@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (weak, nonatomic) IBOutlet UIView *usernameCarryView;
@property (weak, nonatomic) IBOutlet UIView *passwordCarryView;
@property (weak, nonatomic) IBOutlet UIView *userCarryView;
@property (weak, nonatomic) IBOutlet UIView *BussinessCarryView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIView *logoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameTop;//50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgotBottom;//40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBottom;//40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orBottom;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skipTop;//20
@property (weak, nonatomic) IBOutlet UIView *userButtonRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userButtonRighte;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bussinessButtonleft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skipBottom;

@end

@implementation LoginViewController

#pragma mark - View LifeCycle

- (void)initView {
    [super initView];
    [self Custumisation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View Custumisation

-(void)Custumisation{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.usernameTextField.delegate=self;
    self.passwordTextField.delegate=self;
    self.userCarryView.layer.cornerRadius=5;
    self.BussinessCarryView.layer.cornerRadius=5;
    self.usernameCarryView.layer.cornerRadius=5;
    self.passwordCarryView.layer.cornerRadius=5;
    self.loginButton.layer.cornerRadius=5;
    if(IS_IPHONE_5){
        self.userNameTop.constant=40;
        self.forgotBottom.constant=15;
        self.orBottom.constant=18;
        self.skipBottom.constant=110;
    }else if(IS_IPHONE_6_PlUS_Or_Later){
        self.skipTop.constant=0;
    }else if(IS_IPHONE4){
        self.loginScrollView.scrollEnabled=YES;
    }
    [[Utilities standardUtilities]addGradientLayerTo:self.logoView];
    [[Utilities standardUtilities]addGradientLayerTo:self.loginButton];

}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    
//}







#pragma mark - View Actions

- (IBAction)LoginButtonAction:(id)sender {
    if([self isvalidInput]){
        if([self.usernameTextField.text validEmail] == YES)
        {
            self.type =@"1";
        }
        else
        {
            self.type =@"2";
        }
        
        [self LoginApi];
    }
    [self.view endEditing:YES];
}

- (IBAction)ForgotButtonAction:(id)sender {
    ForgotPasswordVC *forgot =[[ForgotPasswordVC alloc]initWithNibName:@"ForgotPasswordVC" bundle:nil];
    UINavigationController *forgotLogNav = [[UINavigationController alloc] initWithRootViewController:forgot];
    [self presentViewController:forgotLogNav animated:YES completion:nil];
}

- (IBAction)LoginWithFaceBookAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FacebookWrapper standardWrapper]  logoutFBSession];
    [[FacebookWrapper standardWrapper] openFaceBookSessionInViewController:self];
    [[FacebookWrapper standardWrapper] addSessionChangedObserver:self];
    [[FacebookWrapper standardWrapper] addUserCancelledObserver:self];
    self.facebookButton.userInteractionEnabled = NO;
}

- (IBAction)UserButtonAction:(id)sender {
    UserRegisterVC *userRegisterVC = [[UserRegisterVC alloc] initWithNibName:@"UserRegisterVC" bundle:nil];
    UINavigationController *userRegisterNav = [[UINavigationController alloc] initWithRootViewController:userRegisterVC];
    [self presentViewController:userRegisterNav animated:YES completion:nil];
}

- (IBAction)BussinessButtonAction:(id)sender {
    BusinessRegisterVC *businessRegisterVC = [[BusinessRegisterVC alloc] initWithNibName:@"BusinessRegisterVC" bundle:nil];
    UINavigationController *businessRegisterNav = [[UINavigationController alloc] initWithRootViewController:businessRegisterVC];
    [self presentViewController:businessRegisterNav animated:YES completion:nil];
}

- (IBAction)SkipButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ViewTapAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Text Feild Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }else if (textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}





#pragma mark - Validation

-(BOOL)isvalidInput{
    BOOL isvalid = NO;
    if ([self.usernameTextField.text empty]){
        [self ShowAlert:@"Please enter an email address"];
    }
    else if (!([self.usernameTextField.text validEmail] || [self.usernameTextField.text validateMobile])){
        [self ShowAlert:@"Please enter a valid email address/phonenumber"];
        
    }
   else if ([self.passwordTextField.text empty]){
        [self ShowAlert:@"Please enter your password"];
    }
   else if ([self.passwordTextField.text length]<8){
        [self ShowAlert:@"Password is incorrect"];
    }
    
    else {
        isvalid = YES;
    }
    return isvalid;
}







#pragma mark - FacebookWrapper session change Notification

- (void)fbSessionChanged:(NSNotification*)notification {
    [[FacebookWrapper standardWrapper] removeSessionChangedObserver:self];
    [[FacebookWrapper standardWrapper] removeUserCancelledObserver:self];
    self.facebookButton.userInteractionEnabled = YES;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self callingSocialRegisterApiWithFBDetails:notification.object];
}

- (void)fbUserCancelled:(NSNotification *)notification {
    [[FacebookWrapper standardWrapper] removeSessionChangedObserver:self];
    [[FacebookWrapper standardWrapper] removeUserCancelledObserver:self];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.facebookButton.userInteractionEnabled = YES;
}

-(void)callingSocialRegisterApiWithFBDetails:(id)fbDetails{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *socialMediaId = [NSString stringWithFormat:@"%@",[fbDetails valueForKey:@"id"]];
    NSString *emailIdString = @"";
    if([fbDetails valueForKey:@"email"])
        emailIdString = [NSString stringWithFormat:@"%@",[fbDetails valueForKey:@"email"]];
    NSString *registerString = [NSString stringWithFormat:@"firstName=&lastName=&dob=&phone=&email=%@&socialMediaId=%@&address=&city=&state=&zip=&gender=",emailIdString,socialMediaId];
    NSURL *registerUrlString = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPESOCIALREGISTRATION withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:registerUrlString withBody:registerString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSString *messageString = [responseObject valueForKey:@"messageText"];
            if([messageString isEqualToString:@"Social media id / email already exist"]){
                [User saveUserDetails:[responseObject valueForKey:@"data"]];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isFacebookLogIn];
                [self showingHomePage];
            }
        }
        else{
            [self addingUserRegisterVCWithFacebookDetails:fbDetails];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
        
    }];
    
}
#pragma mark - Adding User Register VC

-(void)addingUserRegisterVCWithFacebookDetails:(id)facebookDetails{
    UserRegisterVC *userRegisterVC = [[UserRegisterVC alloc] initWithNibName:@"UserRegisterVC" bundle:nil];
    userRegisterVC.isFromFacebookLogIn = YES;
    userRegisterVC.fbUserDetails = facebookDetails;
    [self presentViewController:userRegisterVC animated:YES completion:nil];
    
}

#pragma mark - Showing Home Page

-(void)showingHomePage{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isNormalUser];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLoggedIn];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:DirectoryShowHome object:nil];
}

#pragma mark - LogIn Api call

-(void)LoginApi {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *tempString = [NSString stringWithFormat:@"email=%@&password=%@&type=%@",self.usernameTextField.text,self.passwordTextField.text,self.type];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPELOGIN withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:tempString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"]isEqual:[NSNumber numberWithInt:0]]){
            id userData = [responseObject valueForKey:@"data"];
            if([[userData valueForKey:@"user_role_id"] isEqualToNumber:[NSNumber numberWithInt:2]]){
                [BusinessUser saveUserDetails:[responseObject valueForKey:@"data"]];
              //  BusinessUser *bus = [BusinessUser getBusinessUser];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isBusinessUser];
            }
            else if([[userData valueForKey:@"user_role_id"] isEqualToNumber:[NSNumber numberWithInt:3]]){
                [User saveUserDetails:[responseObject valueForKey:@"data"]];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isNormalUser];
            }
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLoggedIn];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:DirectoryShowHome object:nil];

            }else if([[responseObject valueForKey:@"errorCode"]isEqual:[NSNumber numberWithInt:2]]){
                [self ShowAlert:[responseObject valueForKey:@"messageText"]];
            }else if([[responseObject valueForKey:@"errorCode"]isEqual:[NSNumber numberWithInt:3]]){
                [self ShowAlert:[responseObject valueForKey:@"messageText"]];
        }else{
             [self ShowAlert:[responseObject valueForKey:@"messageText"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

#pragma mark - Showing Alert Controller

-(void)ShowAlert:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alert addAction:firstAction];
    if(![alertMessage isEqualToString:@""])
        [self presentViewController:alert animated:YES completion:nil];
}

@end
