//
//  HookedDealsVC.h
//  DirectoryApp
//
//  Created by smacardev on 09/10/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "BaseViewController.h"

@interface HookedDealsVC : BaseViewController
@property (nonatomic)  BOOL isFromBussinessRegister;
@property (strong, nonatomic)  NSString *userName;
@property (strong, nonatomic)  NSString *password;
- (IBAction)GotItTouch:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPosition_btn;

@end
