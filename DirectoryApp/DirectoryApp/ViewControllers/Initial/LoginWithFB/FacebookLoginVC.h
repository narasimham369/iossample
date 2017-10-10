//
//  FacebookLoginVC.h
//  DirectoryApp
//
//  Created by Vishnu KM on 17/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FacebookLoginVC : BaseViewController
@property (nonatomic)  BOOL isFromBussinessRegister;
@property (strong, nonatomic)  NSString *userName;
@property (strong, nonatomic)  NSString *password;
@end
