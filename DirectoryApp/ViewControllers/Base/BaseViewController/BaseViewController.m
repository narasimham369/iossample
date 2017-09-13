//
//  BaseViewController.m
//  TWExperience
//
//  Created by VK Krish on 17/05/16.
//  Copyright © 2016 CL. All rights reserved.
//

#import "CLLogger.h"
#import "BaseViewController.h"


@interface BaseViewController ()
@end

@implementation BaseViewController

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)initView {
    [self viewCustomization];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}



-(void)hidenavigationBar{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
}

- (void)showButtonOnLeftWithImageName:(NSString *)imageName {
    UIImage *buttonImage;
    if(imageName.length == 0)
        buttonImage = [UIImage imageNamed:@"backImage"];
    else
        buttonImage = [UIImage imageNamed:imageName];
    UIButton *ribbonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ribbonButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [ribbonButton setImage:buttonImage forState:UIControlStateNormal];
    [ribbonButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:ribbonButton];
}

-(void)showButtonOnRightWithImageName:(NSString *)imageName{
    UIImage *buttonImage = [UIImage imageNamed:imageName];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, buttonImage.size.width+20, buttonImage.size.height+20);
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, -24)];
    [rightButton setImage:buttonImage forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
}

-(void)settingTitleLabelWithText:(NSString *)titleString{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = titleString;
    [label sizeToFit];
}


#pragma mark - View Customization

- (void)viewCustomization {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self initNavigationBarAppearence];
}

- (void)showTitleWithImage:(UIImage *)image {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
}

- (void)initNavigationBarAppearence {
    UINavigationBar * navigationBarAppearence = [UINavigationBar appearance];
    navigationBarAppearence.translucent = NO;
    navigationBarAppearence.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Dosis-Bold" size:18],NSFontAttributeName ,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    UIImage *gradientImage=[UIImage imageNamed:@"navImage"];
    [navigationBarAppearence setBackgroundImage:gradientImage forBarMetrics:UIBarMetricsDefault];
    // navigationBarAppearence.barTintColor = AppCommonBlueColor;
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
}

#pragma mark  View Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

#pragma mark Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Actions

-(void)backButtonAction:(UIButton *)backButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonAction:(UIButton *)rightButton{
   
}

#pragma mark - Adding Alert Controller for logout

-(void)addingAlertViewControllerForLogout{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:AppName
                               message:@"Are you sure you want to logout?"
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Calling User Logout Api

//-(void)callingUserLogoutApi{
//    User *user = [User getUser];
//    NSMutableDictionary *logoutmutableDictionary = [[NSMutableDictionary alloc] init];
//    [logoutmutableDictionary setObject:[NSNumber numberWithInt:user.profile_id] forKey:@"profile_id"];
//    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:RIBBNURLTYPELOGOUT withURLParameter:nil];
//    NSMutableDictionary * headerDictionary = [[HeaderBodyGenerator sharedHeaderGenerator] headerBodyWithAccessToken:user.access_token];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NetworkHandler *networkHandlr = [[NetworkHandler alloc] initWithRequestUrl:url withBody:logoutmutableDictionary withMethodType:HTTPMethodPOST withHeaderFeild:headerDictionary];
//    [networkHandlr startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode) {
//        [[CLUtilities standardUtilities] performActionsAfterSesionExpired];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
//        NSInteger errorCode = (long)error.code;
//        if(errorCode == 1024){
//            [self ShowAlert:NetworkUnavailableMessage];
//        }
//        else if([[errorResponseObject valueForKey:ErrorCodeKey] isEqualToNumber:[NSNumber numberWithInt:403]]){
//            [[CLUtilities standardUtilities] reloadaccesstokenWithCompleteWithBlock:^(BOOL isSuccess, id response, id errorRespnse) {
//                if(isSuccess){
//                    [self callingUserLogoutApi];
//                }
//                else{
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    NSString *sessionExpiredMessage = [errorRespnse valueForKey:ErrorDescriptionKey];
//                    [self addingSessionExpiredAlertControllerWithMessage:sessionExpiredMessage];
//                }
//            }];
//        }
//        else{
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [self ShowAlert:UnableToConnectServerMessage];
//        }
//        
//    }];
//  
//}

#pragma mark - Showing Alert Controller

-(void)ShowAlert:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
