//
//  FacebookLoginVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 17/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "User.h"
#import "Constants.h"
#import "UserRegisterVC.h"
#import "FacebookLoginVC.h"
#import "CLFacebookHandler/FacebookWrapper.h"

@interface FacebookLoginVC ()
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UIView *facebookView;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@end

@implementation FacebookLoginVC

- (void)initView {
    [super initView];
    [self initialisation];
}

-(void)initialisation{
    self.title = @"Verify your email";
    self.navigationItem.leftBarButtonItem = nil;
    self.facebookView.layer.cornerRadius = 8;
    UIColor *normalColor = [UIColor colorWithRed:0.24 green:0.22 blue:0.29 alpha:1.0];
    UIColor *highlightColor = AppCommonBlueColor;
    UIFont *normalFont = [UIFont systemFontOfSize:16.0];
    UIFont *highlightedFont = [UIFont boldSystemFontOfSize:16.0];
    NSDictionary *normalAttributes = @{NSFontAttributeName:normalFont, NSForegroundColorAttributeName:normalColor};
    NSDictionary *highlightAttributes = @{NSFontAttributeName:highlightedFont, NSForegroundColorAttributeName:highlightColor};
    
    NSAttributedString *normalText = [[NSAttributedString alloc] initWithString:@"By signing up, you have agreed\n with our " attributes:normalAttributes];
    NSAttributedString *highlightedText = [[NSAttributedString alloc] initWithString:@"terms and conditions." attributes:highlightAttributes];
    
    NSMutableAttributedString *finalAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:normalText];
    [finalAttributedString appendAttributedString:highlightedText];
    self.conditionLabel.attributedText = finalAttributedString;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:isBusinessUser];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isLoggedIn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Actions

-(void)backButtonAction:(UIButton *)backButton{
}

- (IBAction)logInWithFBButtonAction:(UIButton *)sender {
    [self LoginApi];
}


#pragma mark - FacebookWrapper session change Notification

- (void)fbSessionChanged:(NSNotification*)notification {
    NSLog(@"Notification Objetc:%@",notification.object);
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

#pragma mark - Adding User Register VC

-(void)addingUserRegisterVCWithFacebookDetails:(id)facebookDetails{
    UserRegisterVC *userRegisterVC = [[UserRegisterVC alloc] initWithNibName:@"UserRegisterVC" bundle:nil];
    userRegisterVC.isFromFacebookLogIn = YES;
    userRegisterVC.fbUserDetails = facebookDetails;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:userRegisterVC];
    [self.navigationController pushViewController:navigationController animated:YES];
    
}


-(NSString *)getDobInApiFormatWithDateString:(NSString *)dateString{
    NSString *dateFinalString = [dateString convertDateWithInitialFormat:@"dd MMM, yyyy" ToDateWithFormat:@"yyyy-MM-dd"];
    return dateFinalString;
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
                [User saveUserDetails:[responseObject valueForKey:@"data"]];
                [self showingHomePage];
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
#pragma mark - LogIn Api call

-(void)LoginApi {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *tempString = [NSString stringWithFormat:@"email=%@&password=%@",self.userName,self.password];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPELOGIN withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:tempString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        NSLog(@"%@",responseObject);
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:isBusinessUser];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isLoggedIn];
        if([[responseObject valueForKey:@"errorCode"]isEqual:[NSNumber numberWithInt:0]]){
            id userData = [responseObject valueForKey:@"data"];
            if([[userData valueForKey:@"user_role_id"] isEqualToNumber:[NSNumber numberWithInt:2]]){
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isBusinessUser];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLoggedIn];
                [[NSNotificationCenter defaultCenter] postNotificationName:DirectoryShowHome object:nil];
            }else if([[userData valueForKey:@"user_role_id"] isEqualToNumber:[NSNumber numberWithInt:3]]){
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isNormalUser];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLoggedIn];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:DirectoryShowHome object:nil];
            }
        }else if([[responseObject valueForKey:@"errorCode"]isEqual:[NSNumber numberWithInt:1]]){
             [self ShowAlert:[responseObject valueForKey:@"messageText"]];
        }else if([[responseObject valueForKey:@"errorCode"]isEqual:[NSNumber numberWithInt:2]]){
            [self ShowAlert:[responseObject valueForKey:@"messageText"]];
        }else if([[responseObject valueForKey:@"errorCode"]isEqual:[NSNumber numberWithInt:3]]){
            [self ShowAlert:[responseObject valueForKey:@"messageText"]];
        }else{
            
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

#pragma mark - Showing Home Page

-(void)showingHomePage{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isNormalUser];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLoggedIn];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:DirectoryShowHome object:nil];
}
#pragma mark - Showing Alert Controller

-(void)ShowAlert:(NSString*)alertMessage{
    NSString *updatedMessage=[NSString stringWithFormat:@"%@. Do you want to go back to login screen?",alertMessage];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:updatedMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

        [self dismissViewControllerAnimated:YES completion:nil];

    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    if(![alertMessage isEqualToString:@""])
        [self presentViewController:alert animated:YES completion:nil];
}

@end
